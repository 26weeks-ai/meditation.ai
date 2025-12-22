class AppConfig {
  static const bool hideMultiTime = bool.fromEnvironment(
    'HIDE_MULTI_TIME',
    defaultValue: true,
  );
  static const int fixedSessionMinutes = int.fromEnvironment(
    'FIXED_SESSION_MINUTES',
    defaultValue: 60,
  );
  static const int fixedDailyGoalMinutes = int.fromEnvironment(
    'FIXED_DAILY_GOAL_MINUTES',
    defaultValue: 60,
  );

  static const List<int> durationPresets = [15, 30, 45, 60];
}
