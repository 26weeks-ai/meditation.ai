import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sixty_sixty_live/notifications/notification_service.dart';
import 'package:sixty_sixty_live/session/timer_controller.dart';
import 'package:sixty_sixty_live/storage/models/session_record.dart';
import 'package:sixty_sixty_live/storage/models/user_settings.dart';
import 'package:sixty_sixty_live/storage/session_repository.dart';
import 'package:sixty_sixty_live/storage/settings_repository.dart';
import 'package:sixty_sixty_live/ui/screens/session_screen.dart';

class FakeSessionRepository implements SessionRepository {
  @override
  Future<int> insert(SessionRecord record) async => 1;

  @override
  Future<void> update(SessionRecord record) async {}

  @override
  Stream<List<SessionRecord>> watchAll() => Stream<List<SessionRecord>>.empty();

  @override
  Future<List<SessionRecord>> fetchAll() async => [];
}

class FakeNotificationService implements NotificationService {
  @override
  Future<void> cancelDailyReminders() async {}

  @override
  Future<void> cancelSessionAlerts() async {}

  @override
  Future<void> requestPermissions() async {}

  @override
  Future<void> scheduleDailyReminder({
    required bool enabled,
    required TimeOfDay time,
    required List<int> daysOfWeek,
  }) async {}

  @override
  Future<void> scheduleSessionAlerts({
    required int durationMinutes,
    required bool preEndAlert,
    required bool completionAlert,
    required bool vibration,
  }) async {}
}

class TestSessionTimerController extends SessionTimerController {
  TestSessionTimerController(SessionTimerState initialState)
      : super(FakeSessionRepository(), FakeNotificationService()) {
    state = initialState;
  }

  bool pauseCalled = false;
  bool resetCalled = false;

  @override
  Future<void> pause() async {
    pauseCalled = true;
    state = state.copyWith(status: SessionStatus.paused);
  }

  @override
  Future<void> resetSession() async {
    resetCalled = true;
    state = SessionTimerState.idle();
  }
}

SessionRecord _sampleRecord() {
  final start = DateTime(2024, 1, 1, 8, 0);
  return SessionRecord()
    ..startTime = start
    ..endTime = start.add(const Duration(minutes: 60))
    ..plannedDurationMinutes = 60;
}

Future<GlobalKey<NavigatorState>> _pumpSessionScreen(
  WidgetTester tester, {
  required MeditationCountMode mode,
  required TestSessionTimerController controller,
}) async {
  final settings = UserSettings()..meditationCountMode = mode;
  final container = ProviderContainer(
    overrides: [
      settingsProvider.overrideWith((ref) => Stream.value(settings)),
      sessionTimerProvider.overrideWith((ref) => controller),
    ],
  );
  addTearDown(container.dispose);

  final navKey = GlobalKey<NavigatorState>();
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        navigatorKey: navKey,
        home: const Scaffold(body: Text('Home')),
      ),
    ),
  );

  navKey.currentState!.push(
    MaterialPageRoute(builder: (_) => const SessionScreen()),
  );
  await tester.pumpAndSettle();
  return navKey;
}

void main() {
  testWidgets(
    'Back in Deepest Sit shows confirmation dialog and does not pop',
    (tester) async {
      final controller = TestSessionTimerController(
        SessionTimerState(
          status: SessionStatus.running,
          elapsed: Duration.zero,
          record: _sampleRecord(),
        ),
      );

      await _pumpSessionScreen(
        tester,
        mode: MeditationCountMode.deepest,
        controller: controller,
      );

      await tester.pageBack();
      await tester.pumpAndSettle();

      expect(find.text('Deepest Sit mode'), findsOneWidget);
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.byType(SessionScreen), findsOneWidget);
      expect(controller.resetCalled, isFalse);
    },
  );

  testWidgets('Back in Cumulative pauses and pops', (tester) async {
    final controller = TestSessionTimerController(
      SessionTimerState(
        status: SessionStatus.running,
        elapsed: Duration.zero,
        record: _sampleRecord(),
      ),
    );

    await _pumpSessionScreen(
      tester,
      mode: MeditationCountMode.cumulative,
      controller: controller,
    );

    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.byType(SessionScreen), findsNothing);
    expect(find.text('Home'), findsOneWidget);
    expect(controller.pauseCalled, isTrue);
  });
}
