import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../session/timer_controller.dart';
import '../../storage/models/user_settings.dart';
import '../../storage/settings_repository.dart';
import '../widgets/breath_orb.dart';

class SessionScreen extends ConsumerStatefulWidget {
  const SessionScreen({super.key});

  @override
  ConsumerState<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends ConsumerState<SessionScreen> {
  ProviderSubscription<SessionTimerState>? _sessionListener;
  bool _allowPop = false;

  @override
  void initState() {
    super.initState();
    _sessionListener = ref.listenManual<SessionTimerState>(
      sessionTimerProvider,
      (previous, next) {
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
      }
    });
  }

  @override
  void dispose() {
    _sessionListener?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sessionTimerProvider);
    final settings = ref.watch(settingsProvider).valueOrNull;
    final mode = settings?.meditationCountMode ?? MeditationCountMode.cumulative;
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
}
