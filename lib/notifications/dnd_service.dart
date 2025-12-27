import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DndService {
  static const MethodChannel _channel = MethodChannel('sixty_sixty_live/dnd');

  static const int _filterAll = 1;
  static const int _filterPriority = 2;

  int? _previousFilter;
  bool _didChange = false;

  bool get _isAndroid =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  Future<bool> hasPolicyAccess() async {
    if (!_isAndroid) return false;
    try {
      return await _channel.invokeMethod<bool>('hasPolicyAccess') ?? false;
    } on PlatformException catch (e) {
      debugPrint('DND access check failed: ${e.message}');
      return false;
    }
  }

  Future<bool> requestPolicyAccess() async {
    if (!_isAndroid) return false;
    try {
      return await _channel.invokeMethod<bool>('requestPolicyAccess') ?? false;
    } on PlatformException catch (e) {
      debugPrint('DND access request failed: ${e.message}');
      return false;
    }
  }

  Future<void> enableDndForSession() async {
    if (!_isAndroid || _didChange) return;
    final filter = await _getInterruptionFilter();
    if (filter == null) return;
    _previousFilter = filter;
    if (filter != _filterAll) {
      _resetTracking();
      return;
    }
    final hasAccess = await hasPolicyAccess();
    if (!hasAccess) return;
    try {
      await _setInterruptionFilter(_filterPriority);
      _didChange = true;
    } on PlatformException catch (e) {
      debugPrint('DND enable failed: ${e.message}');
      _resetTracking();
    }
  }

  Future<void> restoreDndAfterSession() async {
    if (!_isAndroid) return;
    if (!_didChange) {
      _resetTracking();
      return;
    }
    final previous = _previousFilter;
    _resetTracking();
    if (previous == null || previous != _filterAll) return;
    try {
      await _setInterruptionFilter(previous);
    } on PlatformException catch (e) {
      debugPrint('DND restore failed: ${e.message}');
    }
  }

  Future<int?> _getInterruptionFilter() async {
    if (!_isAndroid) return null;
    try {
      return await _channel.invokeMethod<int>('getInterruptionFilter');
    } on PlatformException catch (e) {
      debugPrint('DND filter read failed: ${e.message}');
      return null;
    }
  }

  Future<void> _setInterruptionFilter(int filter) async {
    if (!_isAndroid) return;
    await _channel.invokeMethod<void>('setInterruptionFilter', {
      'filter': filter,
    });
  }

  void _resetTracking() {
    _previousFilter = null;
    _didChange = false;
  }
}

final dndServiceProvider = Provider<DndService>((ref) => DndService());
