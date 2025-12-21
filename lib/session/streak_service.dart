import '../storage/models/session_record.dart';
import '../storage/models/user_settings.dart';

class StreakStats {
  const StreakStats({
    required this.currentStreakDays,
    required this.bestStreakDays,
    required this.todayMeditationMinutes,
    required this.todayCumulativeMinutes,
    required this.todayLongestMinutes,
    required this.totalSessions,
    required this.totalMinutes,
    required this.mode,
  });

  final int currentStreakDays;
  final int bestStreakDays;

  /// Display value for "today" based on the selected counting mode.
  final int todayMeditationMinutes;
  final int todayCumulativeMinutes;
  final int todayLongestMinutes;
  final int totalSessions;
  final int totalMinutes;
  final MeditationCountMode mode;
}

StreakStats calculateStreakStats(
  List<SessionRecord> sessions,
  int dailyGoalMinutes,
  MeditationCountMode mode,
) {
  // Per-day aggregations
  final Map<DateTime, int> cumulativeByDay = {};
  final Map<DateTime, int> longestByDay = {};
  for (final session in sessions) {
    // Fallback to planned duration when a completed session failed to persist actual minutes (e.g. app closed mid-write).
    final durationForStats = session.actualDurationMinutes > 0
        ? session.actualDurationMinutes
        : (session.completed ? session.plannedDurationMinutes : 0);
    if (durationForStats <= 0) continue;
    final localEnd = session.endTime.toLocal();
    final key = DateTime(localEnd.year, localEnd.month, localEnd.day);
    cumulativeByDay[key] = (cumulativeByDay[key] ?? 0) + durationForStats;
    final currentMax = longestByDay[key] ?? 0;
    if (durationForStats > currentMax) {
      longestByDay[key] = durationForStats;
    }
  }

  final today = DateTime.now();
  final todayKey = DateTime(today.year, today.month, today.day);
  final todayCumulative = cumulativeByDay[todayKey] ?? 0;
  final todayLongest = longestByDay[todayKey] ?? 0;
  final todayMeditation = mode == MeditationCountMode.deepest
      ? todayLongest
      : todayCumulative;

  // Pick which daily metric to use for streak logic.
  int dayValue(DateTime day) {
    return mode == MeditationCountMode.deepest
        ? (longestByDay[day] ?? 0)
        : (cumulativeByDay[day] ?? 0);
  }

  int currentStreak = 0;
  var cursor = todayKey;
  while (dayValue(cursor) >= dailyGoalMinutes) {
    currentStreak += 1;
    cursor = cursor.subtract(const Duration(days: 1));
  }

  final sortedDays = {...cumulativeByDay.keys, ...longestByDay.keys}.toList()
    ..sort();
  int bestStreak = 0;
  int temp = 0;
  DateTime? previous;
  for (final day in sortedDays) {
    if (dayValue(day) >= dailyGoalMinutes) {
      if (previous != null && day.difference(previous).inDays == 1) {
        temp += 1;
      } else {
        temp = 1;
      }
      bestStreak = temp > bestStreak ? temp : bestStreak;
    } else {
      temp = 0;
    }
    previous = day;
  }

  final totalSessions = sessions
      .where(
        (s) =>
            s.actualDurationMinutes > 0 ||
            (s.completed && s.plannedDurationMinutes > 0),
      )
      .length;
  final totalMinutes = sessions.fold<int>(0, (sum, s) {
    final durationForStats = s.actualDurationMinutes > 0
        ? s.actualDurationMinutes
        : (s.completed ? s.plannedDurationMinutes : 0);
    return sum + durationForStats;
  });

  return StreakStats(
    currentStreakDays: currentStreak,
    bestStreakDays: bestStreak,
    todayMeditationMinutes: todayMeditation,
    todayCumulativeMinutes: todayCumulative,
    todayLongestMinutes: todayLongest,
    totalSessions: totalSessions,
    totalMinutes: totalMinutes,
    mode: mode,
  );
}
