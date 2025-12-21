import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GuestAuthNotifier extends StateNotifier<AsyncValue<bool>> {
  GuestAuthNotifier() : super(const AsyncValue.loading()) {
    _load();
  }

  static const _prefsKey = 'guest_mode_enabled';

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final enabled = prefs.getBool(_prefsKey) ?? false;
      state = AsyncValue.data(enabled);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> enableGuest() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_prefsKey, true);
      state = const AsyncValue.data(true);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> disableGuest() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_prefsKey, false);
      state = const AsyncValue.data(false);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final guestAuthProvider = StateNotifierProvider<GuestAuthNotifier, AsyncValue<bool>>(
  (ref) => GuestAuthNotifier(),
);
