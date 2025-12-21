import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'auth/auth_providers.dart';
import 'auth/guest_auth_provider.dart';
import 'storage/models/user_settings.dart';
import 'storage/settings_repository.dart';
import 'ui/screens/completion_screen.dart';
import 'ui/screens/history_screen.dart';
import 'ui/screens/home_screen.dart';
import 'ui/screens/login_screen.dart';
import 'ui/screens/onboarding_screen.dart';
import 'ui/screens/session_screen.dart';
import 'ui/screens/settings_screen.dart';
import 'ui/screens/splash_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = RouterNotifier(ref);
  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    refreshListenable: notifier,
    redirect: notifier.handleRedirect,
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: '/session',
        builder: (context, state) => const SessionScreen(),
      ),
      GoRoute(
        path: '/completion',
        builder: (context, state) {
          return CompletionScreen(record: state.extra);
        },
      ),
      GoRoute(
        path: '/history',
        builder: (context, state) => const HistoryScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
});

class RouterNotifier extends ChangeNotifier {
  RouterNotifier(this.ref) {
    ref.listen(authStateProvider, _onAuthChanged);
    ref.listen(settingsProvider, _onSettingsChanged);
    ref.listen(guestAuthProvider, _onGuestChanged);
  }

  final Ref ref;

  void _onAuthChanged(AsyncValue<User?>? prev, AsyncValue<User?> next) {
    if (_asyncFlagsChanged(prev, next)) {
      notifyListeners();
      return;
    }
    final prevUid = prev?.valueOrNull?.uid;
    final nextUid = next.valueOrNull?.uid;
    if (prevUid != nextUid) {
      notifyListeners();
    }
  }

  void _onSettingsChanged(
    AsyncValue<UserSettings>? prev,
    AsyncValue<UserSettings> next,
  ) {
    if (_asyncFlagsChanged(prev, next)) {
      notifyListeners();
      return;
    }
    final prevCompleted = prev?.valueOrNull?.onboardingCompleted;
    final nextCompleted = next.valueOrNull?.onboardingCompleted;
    if (prevCompleted != nextCompleted) {
      notifyListeners();
    }
  }

  void _onGuestChanged(AsyncValue<bool>? prev, AsyncValue<bool> next) {
    if (_asyncFlagsChanged(prev, next)) {
      notifyListeners();
      return;
    }
    final prevValue = prev?.valueOrNull;
    final nextValue = next.valueOrNull;
    if (prevValue != nextValue) {
      notifyListeners();
    }
  }

  bool _asyncFlagsChanged<T>(AsyncValue<T>? prev, AsyncValue<T> next) {
    if (prev == null) return true;
    if (prev.isLoading != next.isLoading) return true;
    if (prev.hasError != next.hasError) return true;
    return false;
  }

  String? handleRedirect(BuildContext context, GoRouterState state) {
    final authState = ref.read(authStateProvider);
    final settingsState = ref.read(settingsProvider);
    final guestState = ref.read(guestAuthProvider);

    final loggingIn = state.matchedLocation == '/login';
    final onOnboarding = state.matchedLocation == '/onboarding';
    final atSplash = state.matchedLocation == '/splash';

    debugPrint(
      'Router check: loc=${state.matchedLocation} '
      'authLoading=${authState.isLoading} settingsLoading=${settingsState.isLoading} '
      'guestLoading=${guestState.isLoading}',
    );

    if (authState.isLoading ||
        settingsState.isLoading ||
        guestState.isLoading) {
      final target = atSplash ? null : '/splash';
      if (target != null) {
        debugPrint('Router redirect: loading -> $target');
      }
      return target;
    }

    final guestMode = guestState.valueOrNull ?? false;
    final user = authState.valueOrNull;
    if (user == null && !guestMode) {
      final target = loggingIn ? null : '/login';
      if (target != null) {
        debugPrint('Router redirect: auth -> $target');
      }
      return target;
    }

    // If settings failed to load, fall back to defaults so the app can proceed.
    final settings =
        settingsState.valueOrNull ??
        (settingsState.hasError ? UserSettings() : null);
    if (settings == null) return '/splash';
    debugPrint(
      'Router state: user=${user?.uid ?? 'guest'} guest=$guestMode '
      'onboarding=${settings.onboardingCompleted}',
    );

    if (!settings.onboardingCompleted && !onOnboarding) {
      debugPrint('Router redirect: onboarding -> /onboarding');
      return '/onboarding';
    }

    if (onOnboarding && settings.onboardingCompleted) {
      debugPrint('Router redirect: onboarding complete -> /home');
      return '/home';
    }

    if ((atSplash || loggingIn) && settings.onboardingCompleted) {
      debugPrint('Router redirect: entry -> /home');
      return '/home';
    }

    return null;
  }
}
