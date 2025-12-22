# Repository Guidelines

## Project Structure & Module Organization
- `lib/` — Dart source (app entrypoints in `lib/main.dart`, `lib/app.dart`, routing in `lib/app_router.dart`).
- `lib/auth/`, `lib/session/`, `lib/storage/`, `lib/notifications/`, `lib/theme/`, `lib/ui/screens/` — feature modules.
- `assets/` — bundled assets (brand kit in `assets/brand/`; see `assets/brand/README.md`).
- `android/`, `ios/` — platform wrappers and native configs.
- `tools/` — helper scripts (e.g., `tools/brand/gen_brand_assets.py`).

## Build, Test, and Development Commands
- `flutter pub get` — install dependencies.
- `flutter run -d ios` / `flutter run -d android` — run on simulator/device.
- `flutter analyze` — static analysis (lints configured in `analysis_options.yaml`).
- `dart format .` — format Dart code.
- `flutter test` — run unit/widget tests (add tests under `test/`).
- `flutter pub run build_runner build --delete-conflicting-outputs` — regenerate Isar code after editing `lib/storage/models/*.dart`.
- Release: `flutter build ios --release`, `flutter build apk --release`, `flutter build appbundle`.

## Coding Style & Naming Conventions
- Use `dart format` output as the source of truth (Dart defaults: 2-space indentation, 80-column wrapping).
- Keep `flutter analyze` clean; prefer small widgets/functions and `const` where practical.
- Naming: files `lower_snake_case.dart`, types `UpperCamelCase`, members `lowerCamelCase`, Riverpod providers `somethingProvider` (e.g., `authStateProvider`).
- Don’t hand-edit generated files like `lib/storage/models/*.g.dart`; regenerate via `build_runner`.

## Testing Guidelines
- Prefer fast unit tests for timer/streak logic (`lib/session/`) and repository behavior (`lib/storage/`).
- Test files should be named `*_test.dart` and live in `test/`.

## Commit & Pull Request Guidelines
- Commit messages in this repo are short, descriptive phrases (e.g., “updating logo black-green”); keep them concise and action-oriented.
- PRs should include: what changed + why, how to test (commands/devices), and screenshots/screen recordings for UI changes.
- Call out any required local config changes (Firebase, notifications, Isar migrations).

## Security & Configuration Tips
- Guest mode runs without Firebase, but Apple/Google sign-in requires `flutterfire configure --project <id>` (generates `lib/firebase_options.dart` and platform config files).
- Feature flags are wired via `--dart-define` (see `lib/config/app_config.dart`, e.g. `--dart-define=HIDE_MULTI_TIME=false`).
- Never commit Firebase secrets (`GoogleService-Info.plist`, `google-services.json`)—they’re gitignored.
