import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../session/streak_service.dart';
import '../../storage/models/session_record.dart';
import '../../storage/models/user_settings.dart';
import 'home_screen.dart';

class CompletionScreen extends ConsumerWidget {
  const CompletionScreen({super.key, this.record});

  final Object? record;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final StreakStats stats = ref.watch(streakStatsProvider);
    final todayLabel =
        stats.mode == MeditationCountMode.deepest ? 'Deepest sit today' : 'Today';
    final session = record is SessionRecord ? record as SessionRecord : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Done'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Done.',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            if (session != null)
              Text(
                '${session.actualDurationMinutes} minutes',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _stat(todayLabel, '${stats.todayMeditationMinutes} min'),
                    _stat('Current streak', '${stats.currentStreakDays} d'),
                    _stat('Best', '${stats.bestStreakDays} d'),
                  ],
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                context.go('/home');
              },
              child: const Text('Back to home'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white60)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
      ],
    );
  }
}
