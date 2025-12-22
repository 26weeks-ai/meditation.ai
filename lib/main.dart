import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import 'app.dart';
import 'firebase_options.dart';
import 'notifications/notification_service.dart';
import 'storage/isar_service.dart';

class AppProviderObserver extends ProviderObserver {
  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    debugPrint('Provider error: ${provider.name ?? provider.runtimeType}');
    debugPrint('$error');
    debugPrintStack(stackTrace: stackTrace);
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tzdata.initializeTimeZones();
  try {
    final timeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone.identifier));
  } catch (e, st) {
    debugPrint('Timezone init failed: $e');
    debugPrintStack(stackTrace: st);
  }
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final isarManager = await openIsarInstance();
  final notifications = await NotificationService.initialize();

  runApp(
    ProviderScope(
      observers: [AppProviderObserver()],
      overrides: [
        isarProvider.overrideWith((ref) => isarManager),
        notificationServiceProvider.overrideWithValue(notifications),
      ],
      child: const App(),
    ),
  );
}
