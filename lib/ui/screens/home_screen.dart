import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../config/app_config.dart';
import '../../session/streak_service.dart';
import '../../session/timer_controller.dart';
import '../../storage/models/user_settings.dart';
import '../../storage/settings_repository.dart';
import '../../storage/session_repository.dart';

final selectedDurationProvider = StateProvider.autoDispose<int>((ref) {
  if (AppConfig.hideMultiTime) {
    return AppConfig.fixedSessionMinutes;
  }
  final settings = ref.read(settingsProvider).valueOrNull;
  return settings?.defaultSessionDurationMinutes ?? AppConfig.fixedSessionMinutes;
});

final streakStatsProvider = Provider<StreakStats>((ref) {
  final sessions = ref.watch(sessionHistoryProvider).valueOrNull ?? [];
  final settings = ref.watch(settingsProvider).valueOrNull;
  final goal = AppConfig.hideMultiTime
      ? AppConfig.fixedDailyGoalMinutes
      : (settings?.dailyGoalMinutes ?? AppConfig.fixedDailyGoalMinutes);
  final mode = settings?.meditationCountMode ?? MeditationCountMode.cumulative;
  return calculateStreakStats(sessions, goal, mode);
});

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);
    final streaks = ref.watch(streakStatsProvider);
    final selectedDuration = ref.watch(selectedDurationProvider);
    final timerState = ref.watch(sessionTimerProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leadingWidth: kToolbarHeight,
        leading: SizedBox(
          width: kToolbarHeight,
          child: IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => context.push('/history'),
            tooltip: 'History',
          ),
        ),
        titleSpacing: 0,
        centerTitle: true,
        title: Text(
          '60x60.live',
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        actions: [
          SizedBox(
            width: kToolbarHeight,
            child: IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => context.push('/settings'),
              tooltip: 'Settings',
            ),
          ),
        ],
      ),
      body: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator.adaptive()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (settings) {
          final goalMinutes = AppConfig.hideMultiTime
              ? AppConfig.fixedDailyGoalMinutes
              : settings.dailyGoalMinutes;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Do nothing.',
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  'Stay with it.',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 20),
                _progressCard(context, streaks, goalMinutes),
                const SizedBox(height: 16),
                _durationPicker(context, ref, selectedDuration),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () async {
                    if (timerState.status == SessionStatus.running) {
                      context.push('/session');
                      return;
                    }
                    final controller = ref.read(sessionTimerProvider.notifier);
                    await controller.start(
                      durationMinutes: selectedDuration,
                      preEndAlert: settings.preEndAlertEnabled,
                      completionAlert: settings.completionSoundEnabled,
                      vibration: settings.vibrationEnabled,
                    );
                    if (context.mounted) {
                      context.push('/session');
                    }
                  },
                  child: Text(
                    timerState.status == SessionStatus.running
                        ? 'Resume session'
                        : 'Start session',
                  ),
                ),
                const SizedBox(height: 20),
                _streakCard(context, streaks),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => context.push('/history'),
                        child: const Text('History'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => context.push('/settings'),
                        child: const Text('Settings'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _progressCard(BuildContext context, StreakStats stats, int goal) {
    final label =
        stats.mode == MeditationCountMode.deepest ? 'Deepest sit today' : 'Today';
    final todayValue = stats.todayMeditationMinutes;
    final percent = (todayValue / goal).clamp(0, 1.0).toDouble();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label),
            const SizedBox(height: 6),
            Text(
              '$todayValue/$goal minutes',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: LinearProgressIndicator(
                value: percent,
                minHeight: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _durationPicker(BuildContext context, WidgetRef ref, int selected) {
    if (AppConfig.hideMultiTime) {
      return const SizedBox.shrink();
    }

    final presets = AppConfig.durationPresets;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Duration'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              children: presets
                  .map(
                    (m) => ChoiceChip(
                      label: Text('$m min'),
                      selected: selected == m,
                      onSelected: (_) => ref.read(selectedDurationProvider.notifier).state = m,
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 12),
            Text('Custom: $selected min'),
            Slider(
              value: selected.toDouble(),
              min: 10,
              max: 120,
              divisions: 22,
              onChanged: (v) => ref.read(selectedDurationProvider.notifier).state = v.round(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _streakCard(BuildContext context, StreakStats stats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _metric(context, 'Current streak', '${stats.currentStreakDays}d'),
            _metric(context, 'Best streak', '${stats.bestStreakDays}d'),
            _metric(context, 'Total mins', '${stats.totalMinutes}'),
          ],
        ),
      ),
    );
  }

  Widget _metric(BuildContext context, String label, String value) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
      ],
    );
  }
}
