import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';

import '../firebase_options.dart';

class AuthService {
  AuthService(this._auth);

  final FirebaseAuth _auth;
  bool _googleInitialized = false;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  Future<UserCredential> signInWithGoogle() async {
    if (kIsWeb) {
      throw UnsupportedError('Google Sign-In is not supported on web.');
    }

    final google = GoogleSignIn.instance;
    if (!_googleInitialized) {
      final clientId = switch (defaultTargetPlatform) {
        TargetPlatform.iOS || TargetPlatform.macOS =>
          DefaultFirebaseOptions.currentPlatform.iosClientId,
        _ => null,
      };
      if (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS) {
        if (clientId == null || clientId.isEmpty) {
          throw StateError(
            'Google Sign-In is not configured for iOS. Run `flutterfire configure` and ensure `iosClientId` is present in `lib/firebase_options.dart`.',
          );
        }
      }
      await google.initialize(clientId: clientId);
      _googleInitialized = true;
    }
    final googleUser = await google.authenticate();
    final googleAuth = googleUser.authentication;
    final idToken = googleAuth.idToken;
    if (idToken == null || idToken.isEmpty) {
      throw StateError('Google Sign-In failed: missing id token.');
    }
    final credential = GoogleAuthProvider.credential(idToken: idToken);
    return _auth.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    if (_googleInitialized) {
      try {
        await GoogleSignIn.instance.disconnect();
      } catch (_) {}
    }
    await _auth.signOut();
  }
}
