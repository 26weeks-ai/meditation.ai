# 60x60.live — Flutter (iOS-first, Android-ready)

Minimal “do nothing” meditation timer inspired by Naval’s 60 minutes for 60 days. Offline-first: all sessions, streaks, schedules, and settings stay on-device. Firebase Auth is used only for login (Apple + Google).

## Stack
- Flutter (stable 3.38) + Dart 3.10
- State: Riverpod 2.6
- Local DB: Isar
- Local notifications: flutter_local_notifications + timezone
- Auth: firebase_auth, google_sign_in, sign_in_with_apple
- Utilities: wakelock_plus, shared_preferences, share_plus, path_provider, intl

## Project layout
- `lib/app.dart`, `lib/app_router.dart` — theme + navigation
- `lib/auth/` — Firebase auth helpers/controllers
- `lib/storage/` — Isar models/repositories
- `lib/session/` — timer engine + streak calculator
- `lib/notifications/` — local notification setup/scheduling
- `lib/ui/screens/` — Splash, Login, Onboarding, Home, Session, Completion, History, Settings

## Firebase setup (required before running)
1) Create Firebase project and iOS/Android apps with these IDs (from `flutter create --org live.sixtyxsix --project-name sixty_sixty_live`):
   - iOS bundle id: `live.sixtyxsix.sixtySixtyLive`
   - Android app id: `live.sixtyxsix.sixty_sixty_live`
2) Run `flutterfire configure --project <your-project-id>` in the repo. This overwrites `lib/firebase_options.dart` and drops `GoogleService-Info.plist` (iOS) and `google-services.json` (Android) into platform folders.
3) iOS Google Sign-In: ensure `CFBundleURLTypes` in `ios/Runner/Info.plist` contains the reversed client ID from `GoogleService-Info.plist`. `flutterfire configure` normally adds it—verify if sign-in fails.
4) Enable Sign in with Apple in the Firebase console and turn on the “Sign in with Apple” capability in Xcode for the Runner target.

## Running
```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs   # only needed if you change Isar models

# iOS simulator
flutter run -d ios

# Android (emulator/device)
flutter run -d android
```

## Notifications (local only)
- Permission prompt is requested from Settings/Onboarding when reminders are enabled.
- Daily reminder: configurable time + weekdays; uses local scheduled notifications (no backend).
- Session alerts: optional 5-min pre-end + completion alert respect sound/vibration toggles.
- Android manifest already includes `POST_NOTIFICATIONS`, `VIBRATE`, `WAKE_LOCK`.

## Features implemented
- Auth gating with Apple and Google; logout supported.
- Onboarding: set daily goal, default session length, optional daily reminder.
- Home: start session (preset/custom durations), view today progress and streak.
- Session: minimal countdown, breathing pulse, screen stays awake, long-press to end.
- Completion: shows duration + streak snapshot.
- History: list with 7/30/all filters.
- Settings: goals, defaults, reminder schedule, pre-end/completion/vibration toggles, theme switch, share progress text, distraction shield tips.
- Offline/local-first data via Isar; streaks computed locally.

## Building for release
- iOS: open `ios/Runner.xcworkspace` → set signing team → `flutter build ios --release`.
- Android: update `android/key.properties` + signing configs, then `flutter build apk --release` or `flutter build appbundle`.

## App icon (manual swap)
- New monochrome assets live in `assets/blackandwhite/`.
- iOS: replace the images in `ios/Runner/Assets.xcassets/AppIcon.appiconset` with resized variants from `assets/blackandwhite/app_icon_1024.png`.
- Android: replace the `android/app/src/main/res/mipmap-*` launcher icons with resized variants from `assets/blackandwhite/app_icon_1024.png`.
- If you later add `flutter_launcher_icons`, point it at `assets/blackandwhite/app_icon_1024.png` and run `flutter pub run flutter_launcher_icons`.

## Notes
- `lib/firebase_options.dart` is a placeholder until `flutterfire configure` runs.
- All meditation data stays local; no Firestore/Realtime DB/Storage used.
- If you change models in `lib/storage/models`, rerun build_runner to regenerate Isar schemas.
