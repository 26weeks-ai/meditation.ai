import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_providers.dart';
import 'auth_service.dart';
import 'guest_auth_provider.dart';

class AuthUiState {
  const AuthUiState({this.isLoading = false, this.error});

  final bool isLoading;
  final String? error;

  AuthUiState copyWith({bool? isLoading, String? error}) {
    return AuthUiState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AuthController extends StateNotifier<AuthUiState> {
  AuthController(this._auth, this._guestAuth) : super(const AuthUiState());

  final AuthService _auth;
  final GuestAuthNotifier _guestAuth;

  Future<void> signInWithGoogle() async {
    await _signIn(_auth.signInWithGoogle);
  }

  Future<void> signInWithApple() async {
    await _signIn(_auth.signInWithApple);
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _auth.signOut();
      await _guestAuth.disableGuest();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> _signIn(Future<void> Function() action) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await action();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthUiState>((ref) {
  return AuthController(
    ref.watch(authServiceProvider),
    ref.watch(guestAuthProvider.notifier),
  );
});
