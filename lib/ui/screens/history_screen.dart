import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../storage/models/session_record.dart';
import '../../storage/session_repository.dart';
import '../../theme/app_theme_bw.dart';

enum HistoryFilter { week, month, all }

final historyFilterProvider = StateProvider<HistoryFilter>(
  (ref) => HistoryFilter.week,
);

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(sessionHistoryProvider);
    final filter = ref.watch(historyFilterProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Wrap(
              spacing: 8,
              children: HistoryFilter.values.map((f) {
                final labels = {
                  HistoryFilter.week: 'Last 7 days',
                  HistoryFilter.month: 'Last 30 days',
                  HistoryFilter.all: 'All',
                };
                return ChoiceChip(
                  label: Text(labels[f]!),
                  selected: filter == f,
                  onSelected: (_) =>
                      ref.read(historyFilterProvider.notifier).state = f,
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: sessionsAsync.when(
              data: (sessions) {
                final filtered = _filterSessions(sessions, filter);
                if (filtered.isEmpty) {
                  return const Center(child: Text('No sessions yet.'));
                }
                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final session = filtered[index];
                    final date = session.startTime.toLocal();
                    final status = session.completed
                        ? 'Completed'
                        : 'Interrupted';
                    final statusColor = session.completed
                        ? Theme.of(context).colorScheme.onSurface
                        : AppColorsBW.textMuted;
                    return ListTile(
                      title: Text(
                        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
                      ),
                      subtitle: Text(
                        'Planned ${session.plannedDurationMinutes}m • Actual ${session.actualDurationMinutes}m',
                      ),
                      trailing: session.completed
                          ? Text(
                              status,
                              style: Theme.of(context).textTheme.labelMedium
                                  ?.copyWith(color: statusColor),
                            )
                          : Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                status,
                                style: Theme.of(context).textTheme.labelMedium
                                    ?.copyWith(color: statusColor),
                              ),
                            ),
                    );
                  },
                );
              },
              loading: () =>
                  const Center(child: CircularProgressIndicator.adaptive()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }

  List<SessionRecord> _filterSessions(
    List<SessionRecord> sessions,
    HistoryFilter filter,
  ) {
    if (filter == HistoryFilter.all) return sessions;
    final now = DateTime.now();
    final threshold = filter == HistoryFilter.week
        ? now.subtract(const Duration(days: 7))
        : now.subtract(const Duration(days: 30));
    return sessions.where((s) => s.startTime.isAfter(threshold)).toList();
  }
}
