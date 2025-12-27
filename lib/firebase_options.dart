import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Firebase options manually generated from project live66-live66.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('Web is not supported by this Firebase config.');
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return ios;
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      case TargetPlatform.fuchsia:
        throw UnsupportedError(
          'Firebase is not configured for ${defaultTargetPlatform.name}.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAVs5ujYBaLokTN5LKlCMItKgejOM-11gg',
    appId: '1:138963476502:android:504de4f59a0b238c2dd537',
    messagingSenderId: '138963476502',
    projectId: 'live66-live66',
    storageBucket: 'live66-live66.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDYk21McBqLUSSkdY21MrXfOEd3jMh1pZQ',
    appId: '1:138963476502:ios:98883adac10d31cb2dd537',
    messagingSenderId: '138963476502',
    projectId: 'live66-live66',
    storageBucket: 'live66-live66.firebasestorage.app',
    iosClientId:
        '138963476502-53og1b5scs8ktkkakqm80dipa4fl2h0q.apps.googleusercontent.com',
    iosBundleId: 'live.sixtyxsix.sixtySixtyLive',
  );
}
