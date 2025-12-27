import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../notifications/notification_service.dart';
import '../storage/models/session_record.dart';
import '../storage/session_repository.dart';

const _sessionRunningPrefsKey = 'sixty_sixty_live.session_running';

enum SessionStatus { idle, running, paused, completed, interrupted }

class SessionTimerState {
  const SessionTimerState({
    required this.status,
    required this.elapsed,
    this.record,
  });

  final SessionStatus status;
  final Duration elapsed;
  final SessionRecord? record;

  Duration get remaining {
    if (record == null) return Duration.zero;
    final total = Duration(minutes: record!.plannedDurationMinutes);
    final rem = total - elapsed;
    return rem.isNegative ? Duration.zero : rem;
  }

  SessionTimerState copyWith({
    SessionStatus? status,
    Duration? elapsed,
    SessionRecord? record,
  }) {
    return SessionTimerState(
      status: status ?? this.status,
      elapsed: elapsed ?? this.elapsed,
      record: record ?? this.record,
    );
  }

  factory SessionTimerState.idle() => const SessionTimerState(
    status: SessionStatus.idle,
    elapsed: Duration.zero,
    record: null,
  );
}

class SessionTimerController extends StateNotifier<SessionTimerState> {
  SessionTimerController(this._sessions, this._notifications)
    : super(SessionTimerState.idle());

  final SessionRepository _sessions;
  final NotificationService _notifications;
  Timer? _ticker;
  DateTime? _pausedAt;
  Duration _pausedDuration = Duration.zero;
  bool _preEndAlert = false;
  bool _completionAlert = false;
  bool _vibration = false;

  Duration _elapsedAt(DateTime now) {
    final record = state.record;
    if (record == null) return Duration.zero;
    final pausedExtra =
        _pausedAt == null ? Duration.zero : now.difference(_pausedAt!);
    final elapsed = now.difference(record.startTime) -
        _pausedDuration -
        pausedExtra;
    return elapsed.isNegative ? Duration.zero : elapsed;
  }

  Duration _remainingAt(DateTime now) {
    final record = state.record;
    if (record == null) return Duration.zero;
    final planned = Duration(minutes: record.plannedDurationMinutes);
    final remaining = planned - _elapsedAt(now);
    return remaining.isNegative ? Duration.zero : remaining;
  }

  int _remainingMinutes(Duration remaining) {
    if (remaining.inSeconds <= 0) return 0;
    return (remaining.inSeconds / 60).ceil();
  }

  void _resetPauseState() {
    _pausedAt = null;
    _pausedDuration = Duration.zero;
  }

  void _resetAlertConfig() {
    _preEndAlert = false;
    _completionAlert = false;
    _vibration = false;
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  Future<void> _setSessionRunningFlag(bool running) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_sessionRunningPrefsKey, running);
  }

  Future<void> start({
    required int durationMinutes,
    required bool preEndAlert,
    required bool completionAlert,
    required bool vibration,
  }) async {
    if (state.status == SessionStatus.running ||
        state.status == SessionStatus.paused) {
      await reset();
    }
    final start = DateTime.now();
    final end = start.add(Duration(minutes: durationMinutes));
    final record = SessionRecord()
      ..startTime = start
      ..endTime = end
      ..plannedDurationMinutes = durationMinutes;
    final id = await _sessions.insert(record);
    record.id = id;

    _preEndAlert = preEndAlert;
    _completionAlert = completionAlert;
    _vibration = vibration;
    _resetPauseState();
    await _setSessionRunningFlag(true);
    await WakelockPlus.enable();
    await _notifications.scheduleSessionAlerts(
      durationMinutes: durationMinutes,
      preEndAlert: preEndAlert,
      completionAlert: completionAlert,
      vibration: vibration,
    );

    _startTicker();
    state = SessionTimerState(
      status: SessionStatus.running,
      elapsed: Duration.zero,
      record: record,
    );
  }

  Future<void> pause() async {
    if (state.status != SessionStatus.running) return;
    final now = DateTime.now();
    _pausedAt = now;
    final elapsed = _elapsedAt(now);
    _ticker?.cancel();
    await _setSessionRunningFlag(false);
    await _notifications.cancelSessionAlerts();
    await WakelockPlus.disable();
    state = state.copyWith(status: SessionStatus.paused, elapsed: elapsed);
  }

  Future<void> resume() async {
    if (state.status != SessionStatus.paused || state.record == null) return;
    final now = DateTime.now();
    final pausedAt = _pausedAt;
    if (pausedAt != null) {
      _pausedDuration += now.difference(pausedAt);
      _pausedAt = null;
    }
    await _setSessionRunningFlag(true);
    await WakelockPlus.enable();
    final remaining = _remainingAt(now);
    await _notifications.scheduleSessionAlerts(
      durationMinutes: _remainingMinutes(remaining),
      preEndAlert: _preEndAlert,
      completionAlert: _completionAlert,
      vibration: _vibration,
    );
    _startTicker();
    state = state.copyWith(
      status: SessionStatus.running,
      elapsed: _elapsedAt(now),
    );
  }

  Future<void> resetSession() async {
    await reset();
  }

  Future<void> endEarly({bool interrupted = true}) async {
    if (state.record == null) return;
    final now = DateTime.now();
    final record = state.record!;
    final elapsedMinutes = _elapsedAt(now)
        .inMinutes
        .clamp(0, record.plannedDurationMinutes)
        .toInt();
    record
      ..actualDurationMinutes = elapsedMinutes
      ..endTime = now
      ..interrupted = interrupted
      ..completed = !interrupted;
    await _sessions.update(record);
    await _wrapUp(SessionStatus.interrupted, record);
  }

  Future<void> _complete() async {
    if (state.record == null) return;
    final now = DateTime.now();
    final record = state.record!;
    record
      ..actualDurationMinutes = record.plannedDurationMinutes
      ..endTime = now
      ..completed = true
      ..interrupted = false;
    await _sessions.update(record);
    await _wrapUp(SessionStatus.completed, record);
  }

  Future<void> _wrapUp(SessionStatus status, SessionRecord record) async {
    _ticker?.cancel();
    _resetPauseState();
    _resetAlertConfig();
    await _setSessionRunningFlag(false);
    await _notifications.cancelSessionAlerts();
    await WakelockPlus.disable();
    state = state.copyWith(
      status: status,
      elapsed: Duration(minutes: record.actualDurationMinutes),
      record: record,
    );
  }

  void _tick() {
    final record = state.record;
    if (record == null || state.status != SessionStatus.running) return;
    final now = DateTime.now();
    final planned = Duration(minutes: record.plannedDurationMinutes);
    final elapsed = _elapsedAt(now);
    final remaining = planned - elapsed;
    if (remaining.isNegative || remaining.inSeconds <= 0) {
      _complete();
    } else {
      state = state.copyWith(
        elapsed: elapsed,
      );
    }
  }

  Future<void> reset() async {
    _ticker?.cancel();
    _resetPauseState();
    _resetAlertConfig();
    await _setSessionRunningFlag(false);
    await _notifications.cancelSessionAlerts();
    await WakelockPlus.disable();
    state = SessionTimerState.idle();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}

final sessionTimerProvider =
    StateNotifierProvider<SessionTimerController, SessionTimerState>((ref) {
      final sessions = ref.watch(sessionRepositoryProvider);
      final notifications = ref.watch(notificationServiceProvider);
      return SessionTimerController(sessions, notifications);
    });
