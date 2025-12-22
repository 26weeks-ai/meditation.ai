import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../notifications/notification_service.dart';
import '../storage/models/session_record.dart';
import '../storage/session_repository.dart';

enum SessionStatus { idle, running, completed, interrupted }

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

  Future<void> start({
    required int durationMinutes,
    required bool preEndAlert,
    required bool completionAlert,
    required bool vibration,
  }) async {
    if (state.status == SessionStatus.running) {
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

    await WakelockPlus.enable();
    await _notifications.scheduleSessionAlerts(
      durationMinutes: durationMinutes,
      preEndAlert: preEndAlert,
      completionAlert: completionAlert,
      vibration: vibration,
    );

    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    state = SessionTimerState(
      status: SessionStatus.running,
      elapsed: Duration.zero,
      record: record,
    );
  }

  Future<void> endEarly({bool interrupted = true}) async {
    if (state.record == null) return;
    final now = DateTime.now();
    final record = state.record!;
    final elapsedMinutes = now
        .difference(record.startTime)
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
    final record = state.record!;
    record
      ..actualDurationMinutes = record.plannedDurationMinutes
      ..completed = true
      ..interrupted = false;
    await _sessions.update(record);
    await _wrapUp(SessionStatus.completed, record);
  }

  Future<void> _wrapUp(SessionStatus status, SessionRecord record) async {
    _ticker?.cancel();
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
    if (record == null) return;
    final now = DateTime.now();
    final elapsed = now.difference(record.startTime);
    final remaining = record.endTime.difference(now);
    if (remaining.isNegative || remaining.inSeconds <= 0) {
      _complete();
    } else {
      state = state.copyWith(
        elapsed: elapsed.isNegative ? Duration.zero : elapsed,
      );
    }
  }

  Future<void> reset() async {
    _ticker?.cancel();
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
