import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../notifications/dnd_service.dart';
import '../../session/timer_controller.dart';
import '../../storage/models/user_settings.dart';
import '../../storage/settings_repository.dart';
import '../widgets/breath_orb.dart';

class SessionScreen extends ConsumerStatefulWidget {
  const SessionScreen({super.key});

  @override
  ConsumerState<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends ConsumerState<SessionScreen>
    with WidgetsBindingObserver {
  ProviderSubscription<SessionTimerState>? _sessionListener;
  bool _allowPop = false;
  bool _dndPrompted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _sessionListener = ref.listenManual<SessionTimerState>(
      sessionTimerProvider,
      (previous, next) {
        if (previous?.status != next.status) {
          if (next.status == SessionStatus.running) {
            final allowPrompt =
                previous?.status == null ||
                previous?.status != SessionStatus.paused;
            unawaited(_maybeEnableDndForSession(allowPrompt: allowPrompt));
          } else if (next.status == SessionStatus.paused ||
              next.status == SessionStatus.completed ||
              next.status == SessionStatus.interrupted ||
              next.status == SessionStatus.idle) {
            if (next.status == SessionStatus.completed ||
                next.status == SessionStatus.interrupted ||
                next.status == SessionStatus.idle) {
              _dndPrompted = false;
            }
            unawaited(_restoreDndIfNeeded());
          }
        }
        if (previous?.status != next.status &&
            (next.status == SessionStatus.completed ||
                next.status == SessionStatus.interrupted)) {
          final record = next.record;
          if (mounted) {
            context.go('/completion', extra: record);
          }
        }
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final timerState = ref.read(sessionTimerProvider);
      if (timerState.status == SessionStatus.paused) {
        unawaited(ref.read(sessionTimerProvider.notifier).resume());
      } else if (timerState.status == SessionStatus.running) {
        unawaited(_maybeEnableDndForSession(allowPrompt: true));
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _sessionListener?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sessionTimerProvider);
    final settings = ref.watch(settingsProvider).valueOrNull;
    final mode =
        settings?.meditationCountMode ?? MeditationCountMode.cumulative;
    final showIosHint =
        _isIos && settings != null && !settings.iosShortcutsSetupDone;
    final remaining = state.remaining;
    final colorScheme = Theme.of(context).colorScheme;
    final canPop = mode == MeditationCountMode.cumulative || _allowPop;

    return PopScope(
      canPop: canPop,
      onPopInvoked: (didPop) =>
          unawaited(_handlePop(didPop: didPop, mode: mode)),
      child: Scaffold(
        appBar: AppBar(title: const Text('Do nothing')),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const BreathOrb(size: 120),
              const SizedBox(height: 24),
              Text(
                _formatDuration(remaining),
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Stay with it. Screen stays awake.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              if (showIosHint)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Tip: Enable Shortcuts Auto-DND for distraction-free sessions.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              GestureDetector(
                onLongPress: () =>
                    ref.read(sessionTimerProvider.notifier).endEarly(),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Center(child: Text('Long press to end')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handlePop({
    required bool didPop,
    required MeditationCountMode mode,
  }) async {
    if (mode == MeditationCountMode.cumulative) {
      if (didPop) {
        debugPrint('back_cumulative_pause');
        await ref.read(sessionTimerProvider.notifier).pause();
      }
      return;
    }

    if (didPop || !mounted) return;
    debugPrint('back_deepest_confirm');
    final shouldLeave = await _showDeepestConfirmDialog();
    if (shouldLeave != true || !mounted) return;
    await ref.read(sessionTimerProvider.notifier).resetSession();
    if (!mounted) return;
    setState(() => _allowPop = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.pop();
      }
    });
  }

  Future<bool?> _showDeepestConfirmDialog() {
    final colorScheme = Theme.of(context).colorScheme;
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deepest Sit mode'),
        content: const Text(
          "You're in Deepest Sit mode. Going back will restart this session "
          "and it won't count toward today's deepest sit.",
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(foregroundColor: colorScheme.error),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Go Back'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Continue Session'),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;
    final buffer = StringBuffer();
    if (hours > 0) {
      buffer.write(hours.toString().padLeft(2, '0'));
      buffer.write(':');
    }
    buffer.write(minutes.toString().padLeft(2, '0'));
    buffer.write(':');
    buffer.write(seconds.toString().padLeft(2, '0'));
    return buffer.toString();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final timerState = ref.read(sessionTimerProvider);
    if (timerState.status != SessionStatus.running) return;
    switch (state) {
      case AppLifecycleState.resumed:
        unawaited(_maybeEnableDndForSession(allowPrompt: false));
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        unawaited(_restoreDndIfNeeded());
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  bool get _isAndroid =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  bool get _isIos => !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

  Future<void> _maybeEnableDndForSession({required bool allowPrompt}) async {
    final settings = ref.read(settingsProvider).valueOrNull;
    if (settings == null || !settings.dndEnabled || !_isAndroid) return;
    final dndService = ref.read(dndServiceProvider);
    final hasAccess = await dndService.hasPolicyAccess();
    await _updateAndroidPolicyCache(hasAccess);
    if (!hasAccess) {
      if (allowPrompt && !_dndPrompted && mounted) {
        _dndPrompted = true;
        final open = await _showAndroidDndDialog();
        if (!mounted) return;
        if (open == true) {
          await dndService.requestPolicyAccess();
        }
      }
      return;
    }
    await dndService.enableDndForSession();
  }

  Future<void> _restoreDndIfNeeded() async {
    if (!_isAndroid) return;
    await ref.read(dndServiceProvider).restoreDndAfterSession();
  }

  Future<void> _updateAndroidPolicyCache(bool hasAccess) async {
    final settings = ref.read(settingsProvider).valueOrNull;
    if (settings == null) return;
    if (settings.androidPolicyAccessGrantedCached == hasAccess) return;
    final repo = ref.read(settingsRepositoryProvider);
    await repo.update((current) {
      current.androidPolicyAccessGrantedCached = hasAccess;
      return current;
    });
  }

  Future<bool?> _showAndroidDndDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enable Do Not Disturb'),
        content: const Text(
          'Allow 6060live to control Do Not Disturb during sessions. '
          'This requires Notification Policy access in system settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Not now'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }
}
