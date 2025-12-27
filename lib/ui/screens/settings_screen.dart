import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../auth/auth_controller.dart';
import '../../auth/auth_providers.dart';
import '../../auth/guest_auth_provider.dart';
import '../../config/app_config.dart';
import '../../notifications/notification_service.dart';
import '../../session/streak_service.dart';
import '../../storage/models/user_settings.dart';
import '../../storage/settings_repository.dart';
import 'home_screen.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  UserSettings? _settings;
  bool _loading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final data = ref.read(settingsProvider).valueOrNull;
    if (data != null && _settings == null) {
      _settings = data;
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsProvider);
    final StreakStats stats = ref.watch(streakStatsProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final authState = ref.watch(authStateProvider);
    final guestState = ref.watch(guestAuthProvider);
    final isSignedIn = authState.valueOrNull != null;
    final accountBusy = _loading || authState.isLoading || guestState.isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: settingsAsync.when(
        data: (settings) {
          _settings ??= settings;
          final local = _settings!;
          final selectedTheme = local.theme == AppThemePreference.light
              ? AppThemePreference.dark
              : local.theme;
          final dailyGoalMinutes = AppConfig.hideMultiTime
              ? AppConfig.fixedDailyGoalMinutes
              : local.dailyGoalMinutes;
          final defaultSessionMinutes = AppConfig.hideMultiTime
              ? AppConfig.fixedSessionMinutes
              : local.defaultSessionDurationMinutes;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _section(
                  'Goals',
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Daily goal: $dailyGoalMinutes min'),
                      if (!AppConfig.hideMultiTime)
                        Slider(
                          value: dailyGoalMinutes.toDouble(),
                          min: 15,
                          max: 120,
                          divisions: 21,
                          onChanged: (v) =>
                              _save((s) => s.dailyGoalMinutes = v.round()),
                        ),
                      if (AppConfig.hideMultiTime)
                        Text(
                          'Fixed at ${AppConfig.fixedDailyGoalMinutes} minutes.',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      const SizedBox(height: 8),
                      Text('Default session: $defaultSessionMinutes min'),
                      if (!AppConfig.hideMultiTime)
                        Slider(
                          value: defaultSessionMinutes.toDouble(),
                          min: 15,
                          max: 90,
                          divisions: 15,
                          onChanged: (v) => _save(
                            (s) => s.defaultSessionDurationMinutes = v.round(),
                          ),
                        ),
                      if (AppConfig.hideMultiTime)
                        Text(
                          'Fixed at ${AppConfig.fixedSessionMinutes} minutes.',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _section(
                  'Daily Meditation Count',
                  RadioGroup<MeditationCountMode>(
                    groupValue: local.meditationCountMode,
                    onChanged: (mode) {
                      if (mode == null) return;
                      unawaited(_save((s) => s.meditationCountMode = mode));
                    },
                    child: Column(
                      children: [
                        _modeOption(
                          context,
                          local,
                          MeditationCountMode.cumulative,
                          'Cumulative Time',
                          'Counts the total time you meditate in a day by adding all completed sessions. Example: 2 min + 4 min = 6 min.',
                        ),
                        _modeOption(
                          context,
                          local,
                          MeditationCountMode.deepest,
                          'Deepest Sit',
                          'Counts only your longest uninterrupted meditation session in a day. Example: 2 min + 4 min = 4 min. This encourages deeper, single sits.',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _section(
                  'Notifications',
                  Column(
                    children: [
                      SwitchListTile(
                        value: local.reminderEnabled,
                        onChanged: (v) => _toggleReminder(v),
                        title: const Text('Daily reminder'),
                      ),
                      if (local.reminderEnabled) ...[
                        ListTile(
                          title: const Text('Reminder time'),
                          subtitle: Text(local.reminderTime ?? 'Pick a time'),
                          trailing: const Icon(Icons.timer),
                          onTap: _pickReminderTime,
                        ),
                        Wrap(
                          spacing: 8,
                          children: List.generate(7, (index) {
                            final day = index + 1;
                            final labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                            final active = local.reminderDays.contains(day);
                            return FilterChip(
                              label: Text(labels[index]),
                              selected: active,
                              labelStyle: TextStyle(
                                color: active ? colorScheme.onPrimary : colorScheme.onSurface,
                              ),
                              onSelected: (selected) =>
                                  _toggleReminderDay(day, selected),
                            );
                          }),
                        ),
                      ],
                      SwitchListTile(
                        value: local.preEndAlertEnabled,
                        onChanged: (v) =>
                            _save((s) => s.preEndAlertEnabled = v),
                        title: const Text('5 minutes remaining alert'),
                      ),
                      SwitchListTile(
                        value: local.completionSoundEnabled,
                        onChanged: (v) =>
                            _save((s) => s.completionSoundEnabled = v),
                        title: const Text('Completion notification'),
                      ),
                      SwitchListTile(
                        value: local.vibrationEnabled,
                        onChanged: (v) => _save((s) => s.vibrationEnabled = v),
                        title: const Text('Vibration'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _section(
                  'Theme',
                  SegmentedButton<AppThemePreference>(
                    segments: const [
                      ButtonSegment(
                        value: AppThemePreference.dark,
                        label: Text('Dark'),
                      ),
                      ButtonSegment(
                        value: AppThemePreference.light,
                        label: Text('Light'),
                        enabled: false,
                      ),
                    ],
                    selected: {selectedTheme},
                    onSelectionChanged: (value) =>
                        _save((s) => s.theme = AppThemePreference.dark),
                  ),
                ),
                const SizedBox(height: 16),
                _section(
                  'Share',
                  Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.ios_share),
                        title: const Text('Export summary'),
                        subtitle: Text(
                          'Total ${stats.totalMinutes} min, streak ${stats.currentStreakDays} days',
                        ),
                        onTap: () => SharePlus.instance.share(
                          ShareParams(
                            text:
                                '60x60.live — ${stats.totalMinutes} minutes meditated.\nCurrent streak: ${stats.currentStreakDays} days. Best: ${stats.bestStreakDays} days.',
                            subject: '60x60.live progress',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _section(
                  'Distraction shield',
                  const Text(
                    'Want to keep the screen locked into this session? On iOS, enable Guided Access: Settings → Accessibility → Guided Access. Start a session, triple-press the side button, and tap Start.',
                  ),
                ),
                const SizedBox(height: 16),
                _section(
                  'Account',
                  Column(
                    children: [
                      if (isSignedIn)
                        OutlinedButton.icon(
                          onPressed: accountBusy
                              ? null
                              : () async {
                                  setState(() => _loading = true);
                                  await ref
                                      .read(authControllerProvider.notifier)
                                      .signOut();
                                  if (mounted) setState(() => _loading = false);
                                },
                          icon: const Icon(Icons.logout),
                          label: const Text('Sign out'),
                        )
                      else
                        OutlinedButton.icon(
                          onPressed: accountBusy
                              ? null
                              : () async {
                                  setState(() => _loading = true);
                                  await ref
                                      .read(guestAuthProvider.notifier)
                                      .disableGuest();
                                  if (mounted) setState(() => _loading = false);
                                },
                          icon: const Icon(Icons.login),
                          label: const Text('Sign in'),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        error: (e, _) => Center(child: Text('Error: $e')),
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
      ),
    );
  }

  Widget _section(String title, Widget child) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }

  Future<void> _save(void Function(UserSettings settings) apply) async {
    final repo = ref.read(settingsRepositoryProvider);
    await repo.update((settings) {
      apply(settings);
      _settings = settings;
      return settings;
    });
    setState(() {});
    await _rescheduleReminder();
  }

  Future<void> _toggleReminder(bool enabled) async {
    await _save((s) => s.reminderEnabled = enabled);
  }

  Future<void> _toggleReminderDay(int day, bool selected) async {
    await _save((s) {
      final days = List<int>.from(s.reminderDays);
      if (selected) {
        if (!days.contains(day)) {
          days.add(day);
        }
      } else {
        days.remove(day);
      }
      days.sort();
      s.reminderDays = days;
    });
  }

  Widget _modeOption(
    BuildContext context,
    UserSettings local,
    MeditationCountMode mode,
    String title,
    String info,
  ) {
    final selected = local.meditationCountMode == mode;
    return RadioListTile<MeditationCountMode>(
      value: mode,
      title: Row(
        children: [
          Expanded(child: Text(title)),
          IconButton(
            icon: const Icon(Icons.info_outline, size: 20),
            tooltip: info,
            onPressed: () => _showModeInfo(context, title, info),
          ),
        ],
      ),
      subtitle: Text(selected ? 'Active' : ''),
    );
  }

  void _showModeInfo(BuildContext context, String title, String description) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(description),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickReminderTime() async {
    final current = _settings;
    if (current == null) return;
    final initial =
        _parseTime(current.reminderTime) ?? const TimeOfDay(hour: 7, minute: 0);
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked != null) {
      await _save((s) => s.reminderTime = _formatTime(picked));
    }
  }

  Future<void> _rescheduleReminder() async {
    final settings = _settings;
    if (settings == null) return;
    final notifications = ref.read(notificationServiceProvider);
    if (settings.reminderEnabled) {
      await notifications.requestPermissions();
      final time =
          _parseTime(settings.reminderTime) ??
          const TimeOfDay(hour: 7, minute: 0);
      await notifications.scheduleDailyReminder(
        enabled: true,
        time: time,
        daysOfWeek: settings.reminderDays,
      );
    } else {
      await notifications.cancelDailyReminders();
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
}
