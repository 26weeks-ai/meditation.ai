import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import 'isar_service.dart';
import 'models/user_settings.dart';

const _settingsId = 1;

class SettingsRepository {
  SettingsRepository(this._isarManager);

  final IsarManager _isarManager;
  bool _recovering = false;

  Isar get _isar => _isarManager.isar;

  Future<UserSettings> loadOrCreate() async {
    try {
      final existing = await _isar.userSettings.get(_settingsId);
      if (existing != null) {
        final changed = _sanitizeSettings(existing);
        if (changed) {
          await _isar.writeTxn(() => _isar.userSettings.put(existing));
        }
        _recovering = false;
        return existing;
      }

      final allSettings = await _isar.userSettings.where().findAll();
      if (allSettings.isNotEmpty) {
        final latest = _pickLatest(allSettings);
        final migrated = _cloneWithId(latest, _settingsId);
        _sanitizeSettings(migrated);
        await _isar.writeTxn(() async {
          await _isar.userSettings.put(migrated);
          for (final settings in allSettings) {
            if (settings.id != _settingsId) {
              await _isar.userSettings.delete(settings.id);
            }
          }
        });
        _recovering = false;
        return migrated;
      }
    } catch (error, stackTrace) {
      debugPrint('Settings load failed, resetting local settings: $error');
      debugPrintStack(stackTrace: stackTrace);
      // If the store is corrupted or schema-mismatched, reset settings to defaults.
      await _recoverFromCorruption();
    }
    final settings = UserSettings()..id = _settingsId;
    _sanitizeSettings(settings);
    await _isar.writeTxn(() => _isar.userSettings.put(settings));
    _recovering = false;
    return settings;
  }

  Stream<UserSettings> watchSettings() {
    return _watchSettings();
  }

  Stream<UserSettings> _watchSettings() async* {
    await for (final _ in _isar.userSettings.watchLazy(fireImmediately: true)) {
      yield await loadOrCreate();
    }
  }

  Future<void> update(UserSettings Function(UserSettings) modifier) async {
    final current = await loadOrCreate();
    final updated = modifier(current);
    _sanitizeSettings(updated);
    try {
      await _isar.writeTxn(() => _isar.userSettings.put(updated));
      _recovering = false;
    } catch (error, stackTrace) {
      debugPrint('Settings update failed, resetting local settings: $error');
      debugPrintStack(stackTrace: stackTrace);
      await _recoverFromCorruption();
      rethrow;
    }
  }

  Future<void> _recoverFromCorruption() async {
    if (_recovering) return;
    _recovering = true;
    debugPrint('Settings recovery: resetting local database');
    await _isarManager.reset();
  }

  bool _sanitizeSettings(UserSettings settings) {
    var changed = false;

    final dailyGoal = _clamp(settings.dailyGoalMinutes, 15, 120);
    if (dailyGoal != settings.dailyGoalMinutes) {
      settings.dailyGoalMinutes = dailyGoal;
      changed = true;
    }

    final defaultDuration = _clamp(
      settings.defaultSessionDurationMinutes,
      15,
      90,
    );
    if (defaultDuration != settings.defaultSessionDurationMinutes) {
      settings.defaultSessionDurationMinutes = defaultDuration;
      changed = true;
    }

    final sanitizedDays =
        settings.reminderDays.where((d) => d >= 1 && d <= 7).toSet().toList()
          ..sort();
    if (sanitizedDays.length != settings.reminderDays.length ||
        !_listEquals(sanitizedDays, settings.reminderDays)) {
      settings.reminderDays = sanitizedDays;
      changed = true;
    }

    if (settings.reminderEnabled && settings.reminderDays.isEmpty) {
      settings.reminderEnabled = false;
      changed = true;
    }

    if (settings.reminderTime != null && !_isValidTime(settings.reminderTime)) {
      settings.reminderTime = null;
      changed = true;
    }

    return changed;
  }

  bool _listEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  UserSettings _pickLatest(List<UserSettings> allSettings) {
    var latest = allSettings.first;
    for (final settings in allSettings.skip(1)) {
      if (settings.id > latest.id) {
        latest = settings;
      }
    }
    return latest;
  }

  UserSettings _cloneWithId(UserSettings source, int id) {
    final settings = UserSettings()..id = id;
    settings.dailyGoalMinutes = source.dailyGoalMinutes;
    settings.defaultSessionDurationMinutes =
        source.defaultSessionDurationMinutes;
    settings.reminderEnabled = source.reminderEnabled;
    settings.reminderTime = source.reminderTime;
    settings.reminderDays = List<int>.from(source.reminderDays);
    settings.preEndAlertEnabled = source.preEndAlertEnabled;
    settings.completionSoundEnabled = source.completionSoundEnabled;
    settings.vibrationEnabled = source.vibrationEnabled;
    settings.dndEnabled = source.dndEnabled;
    settings.iosShortcutsSetupDone = source.iosShortcutsSetupDone;
    settings.androidPolicyAccessGrantedCached =
        source.androidPolicyAccessGrantedCached;
    settings.theme = source.theme;
    settings.onboardingCompleted = source.onboardingCompleted;
    settings.meditationCountMode = source.meditationCountMode;
    return settings;
  }

  bool _isValidTime(String? value) {
    if (value == null) return false;
    final parts = value.split(':');
    if (parts.length != 2) return false;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return false;
    return hour >= 0 && hour < 24 && minute >= 0 && minute < 60;
  }

  int _clamp(int value, int min, int max) {
    if (value < min) return min;
    if (value > max) return max;
    return value;
  }
}

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepository(ref.watch(isarProvider)),
);

final settingsProvider = StreamProvider<UserSettings>(
  (ref) => ref.watch(settingsRepositoryProvider).watchSettings(),
);
