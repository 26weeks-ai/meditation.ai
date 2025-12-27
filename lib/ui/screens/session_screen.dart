import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../session/timer_controller.dart';
import '../widgets/breath_orb.dart';

class SessionScreen extends ConsumerStatefulWidget {
  const SessionScreen({super.key});

  @override
  ConsumerState<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends ConsumerState<SessionScreen> {
  ProviderSubscription<SessionTimerState>? _sessionListener;

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
  }

  @override
  void dispose() {
    _sessionListener?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sessionTimerProvider);
    final remaining = state.remaining;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
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
