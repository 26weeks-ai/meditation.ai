import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../config/app_config.dart';
import '../../notifications/notification_service.dart';
import '../../storage/settings_repository.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  bool _hydrated = false;
  int _dailyGoal = 60;
  int _defaultDuration = 60;
  bool _reminderEnabled = false;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 7, minute: 0);
  List<int> _reminderDays = List<int>.generate(7, (index) => index + 1);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final settings = ref.read(settingsProvider).valueOrNull;
    if (settings != null && !_hydrated) {
      if (AppConfig.hideMultiTime) {
        _dailyGoal = AppConfig.fixedDailyGoalMinutes;
        _defaultDuration = AppConfig.fixedSessionMinutes;
      } else {
        _dailyGoal = _clamp(settings.dailyGoalMinutes, 15, 120);
        _defaultDuration = _clamp(
          settings.defaultSessionDurationMinutes,
          15,
          90,
        );
      }
      _reminderEnabled = settings.reminderEnabled;
      _reminderDays = _normalizeReminderDays(settings.reminderDays);
      _reminderTime = _parseTime(settings.reminderTime) ?? _reminderTime;
      _hydrated = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Getting ready')),
      body: settingsAsync.when(
        data: (_) => SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'One hour. One day.',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              const Text(
                'Set your daily goal and how long you want each sit to be.',
              ),
              const SizedBox(height: 24),
              _sectionCard(
                title: 'Daily goal',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$_dailyGoal minutes'),
                    if (!AppConfig.hideMultiTime)
                      Slider(
                        value: _dailyGoal.toDouble(),
                        min: 15,
                        max: 120,
                        divisions: 21,
                        label: '$_dailyGoal',
                        onChanged: (v) =>
                            setState(() => _dailyGoal = v.round()),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _sectionCard(
                title: 'Default session',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$_defaultDuration minutes'),
                    if (!AppConfig.hideMultiTime)
                      Slider(
                        value: _defaultDuration.toDouble(),
                        min: 15,
                        max: 90,
                        divisions: 15,
                        label: '$_defaultDuration',
                        onChanged: (v) =>
                            setState(() => _defaultDuration = v.round()),
                      )
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _sectionCard(
                title: 'Daily reminder',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SwitchListTile(
                      value: _reminderEnabled,
                      onChanged: (v) => setState(() => _reminderEnabled = v),
                      title: const Text('Remind me once a day'),
                    ),
                    if (_reminderEnabled) ...[
                      Row(
                        children: [
                          TextButton(
                            onPressed: _pickReminderTime,
                            child: Text('Time: ${_formatTime(_reminderTime)}'),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Wrap(
                              spacing: 8,
                              children: List.generate(7, (index) {
                                final day = index + 1;
                                final labels = [
                                  'M',
                                  'T',
                                  'W',
                                  'T',
                                  'F',
                                  'S',
                                  'S',
                                ];
                                final active = _reminderDays.contains(day);
                                return ChoiceChip(
                                  label: Text(labels[index]),
                                  selected: active,
                                  onSelected: (_) => _toggleDay(day),
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveAndGo,
                child: const Text('Finish'),
              ),
            ],
          ),
        ),
        error: (e, st) {
          debugPrint('Onboarding settings error: $e');
          debugPrintStack(stackTrace: st);
          return Center(child: Text('Something went wrong: $e'));
        },
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
      ),
    );
  }

  Widget _sectionCard({required String title, required Widget child}) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }

  Future<void> _pickReminderTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
      initialEntryMode: TimePickerEntryMode.dialOnly,
    );
    if (picked != null) {
      setState(() => _reminderTime = picked);
    }
  }

  void _toggleDay(int day) {
    setState(() {
      if (_reminderDays.contains(day)) {
        _reminderDays.remove(day);
      } else {
        _reminderDays.add(day);
      }
      _reminderDays.sort();
    });
  }

  Future<void> _saveAndGo() async {
    debugPrint('Onboarding: finish tapped');
    final normalizedDays = _normalizeReminderDays(_reminderDays);
    final dailyGoal = AppConfig.hideMultiTime
        ? AppConfig.fixedDailyGoalMinutes
        : _clamp(_dailyGoal, 15, 120);
    final defaultDuration = AppConfig.hideMultiTime
        ? AppConfig.fixedSessionMinutes
        : _clamp(_defaultDuration, 15, 90);

    if (_reminderEnabled && normalizedDays.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pick at least one reminder day.')),
        );
      }
      return;
    }

    if (mounted) {
      final shouldUpdateState =
          dailyGoal != _dailyGoal ||
          defaultDuration != _defaultDuration ||
          !_listEquals(normalizedDays, _reminderDays);
      if (shouldUpdateState) {
        setState(() {
          _dailyGoal = dailyGoal;
          _defaultDuration = defaultDuration;
          _reminderDays = normalizedDays;
        });
      }
    }

    debugPrint('Onboarding: saving settings');
    final repo = ref.read(settingsRepositoryProvider);
    await repo.update((settings) {
      settings.dailyGoalMinutes = dailyGoal;
      settings.defaultSessionDurationMinutes = defaultDuration;
      settings.reminderEnabled = _reminderEnabled;
      settings.reminderTime = _formatTime(_reminderTime);
      settings.reminderDays = normalizedDays;
      settings.onboardingCompleted = true;
      return settings;
    });
    debugPrint('Onboarding: settings saved');

    if (_reminderEnabled) {
      debugPrint(
        'Onboarding: scheduling reminders (${normalizedDays.join(',')})',
      );
      final notifications = ref.read(notificationServiceProvider);
      await notifications.requestPermissions();
      await notifications.scheduleDailyReminder(
        enabled: true,
        time: _reminderTime,
        daysOfWeek: normalizedDays,
      );
      debugPrint('Onboarding: reminders scheduled');
    } else {
      debugPrint('Onboarding: cancelling reminders');
      await ref.read(notificationServiceProvider).cancelDailyReminders();
    }

    if (mounted) {
      debugPrint('Onboarding: navigating to /home');
      context.go('/home');
    }
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  TimeOfDay? _parseTime(String? value) {
    if (value == null || !value.contains(':')) return null;
    final parts = value.split(':');
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    return TimeOfDay(hour: hour, minute: minute);
  }

  List<int> _normalizeReminderDays(List<int> days) {
    return days.where((d) => d >= 1 && d <= 7).toSet().toList()..sort();
  }

  bool _listEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  int _clamp(int value, int min, int max) {
    if (value < min) return min;
    if (value > max) return max;
    return value;
  }
}
