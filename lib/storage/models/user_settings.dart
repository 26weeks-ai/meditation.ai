import 'package:isar/isar.dart';

part 'user_settings.g.dart';

enum AppThemePreference { dark, light }

enum MeditationCountMode { cumulative, deepest }

@collection
class UserSettings {
  Id id = Isar.autoIncrement;

  int dailyGoalMinutes = 60;
  int defaultSessionDurationMinutes = 60;
  bool reminderEnabled = false;
  String? reminderTime; // HH:mm
  List<int> reminderDays = List<int>.generate(7, (index) => index + 1);
  bool preEndAlertEnabled = false;
  bool completionSoundEnabled = true;
  bool vibrationEnabled = true;
  @Enumerated(EnumType.name)
  AppThemePreference theme = AppThemePreference.dark;
  bool onboardingCompleted = false;
  @Enumerated(EnumType.name)
  MeditationCountMode meditationCountMode = MeditationCountMode.cumulative;
}
