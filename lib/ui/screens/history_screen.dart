import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../storage/models/session_record.dart';
import '../../storage/session_repository.dart';

enum HistoryFilter { week, month, all }

final historyFilterProvider = StateProvider<HistoryFilter>((ref) => HistoryFilter.week);

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(sessionHistoryProvider);
    final filter = ref.watch(historyFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
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
                  HistoryFilter.all: 'All'
                };
                return ChoiceChip(
                  label: Text(labels[f]!),
                  selected: filter == f,
                  onSelected: (_) => ref.read(historyFilterProvider.notifier).state = f,
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
                    final status = session.completed ? 'Completed' : 'Interrupted';
                    return ListTile(
                      title: Text(
                        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
                      ),
                      subtitle: Text(
                          'Planned ${session.plannedDurationMinutes}m • Actual ${session.actualDurationMinutes}m'),
                      trailing: Text(
                        status,
                        style: TextStyle(
                          color: session.completed ? Colors.greenAccent : Colors.orangeAccent,
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator.adaptive()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }

  List<SessionRecord> _filterSessions(List<SessionRecord> sessions, HistoryFilter filter) {
    if (filter == HistoryFilter.all) return sessions;
    final now = DateTime.now();
    final threshold = filter == HistoryFilter.week
        ? now.subtract(const Duration(days: 7))
        : now.subtract(const Duration(days: 30));
    return sessions.where((s) => s.startTime.isAfter(threshold)).toList();
  }
}
