import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/session_record.dart';
import 'models/user_settings.dart';

const _isarSchemaVersion = 2;
const _isarSchemaVersionKey = 'isar_schema_version';
const _isarInstanceKey = 'isar_instance_id';
const _isarNamePrefix = 'meditation_v$_isarSchemaVersion';

final isarProvider = ChangeNotifierProvider<IsarManager>(
  (ref) => throw UnimplementedError('Isar not initialized'),
);

class IsarManager extends ChangeNotifier {
  IsarManager(this._isar, this._directory);

  Isar _isar;
  final Directory _directory;
  Future<void>? _resetTask;

  Isar get isar => _isar;

  Future<void> reset() {
    _resetTask ??= _performReset().whenComplete(() {
      _resetTask = null;
    });
    return _resetTask!;
  }

  Future<void> _performReset() async {
    try {
      await _isar.close(deleteFromDisk: true);
    } catch (error, stackTrace) {
      debugPrint('Isar close failed during reset: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
    await _purgeIsarFiles(_directory);
    final name = await _rotateIsarName();
    _isar = await _openAndVerifyIsar(_directory, name);
    notifyListeners();
  }

  @override
  void dispose() {
    unawaited(_isar.close());
    super.dispose();
  }
}

Future<IsarManager> openIsarInstance() async {
  final dir = await _ensureIsarDirectory();
  final name = await _loadIsarName(dir);
  final isar = await _openAndVerifyIsar(dir, name);
  return IsarManager(isar, dir);
}

Future<Directory> _ensureIsarDirectory() async {
  final baseDir = await getApplicationSupportDirectory();
  final dir = Directory('${baseDir.path}/isar');
  if (!await dir.exists()) {
    await dir.create(recursive: true);
  }
  return dir;
}

Future<Isar> _openAndVerifyIsar(Directory dir, String name) async {
  Isar? isar;
  try {
    isar = await _openIsar(dir, name);
    await _verifyUserSettings(isar);
    return isar;
  } catch (error, stackTrace) {
    debugPrint('Isar open/verify failed, resetting local database: $error');
    debugPrintStack(stackTrace: stackTrace);
    if (isar != null) {
      await isar.close(deleteFromDisk: true);
    }
    await _purgeIsarFiles(dir);
    final rotatedName = await _rotateIsarName();
    return _openIsar(dir, rotatedName);
  }
}

Future<Isar> _openIsar(Directory dir, String name) {
  return Isar.open(
    [
      UserSettingsSchema,
      SessionRecordSchema,
    ],
    directory: dir.path,
    name: name,
  );
}

Future<void> _verifyUserSettings(Isar isar) async {
  await isar.userSettings.where().findAll();
}

Future<void> _purgeIsarFiles(Directory appDir) async {
  try {
    if (!await appDir.exists()) return;
    final entries = appDir.listSync();
    for (final entry in entries) {
      try {
        if (entry is File) {
          await entry.delete();
        } else if (entry is Directory) {
          await entry.delete(recursive: true);
        }
      } catch (_) {
        // best effort
      }
    }
  } catch (_) {
    // ignore purge failures
  }
}

Future<String> _loadIsarName(Directory dir) async {
  final prefs = await SharedPreferences.getInstance();
  final storedVersion = prefs.getInt(_isarSchemaVersionKey);
  var instanceId = prefs.getString(_isarInstanceKey);

  if (storedVersion != _isarSchemaVersion || instanceId == null) {
    await _purgeLegacyIsarDirs();
    await _purgeIsarFiles(dir);
    instanceId = _generateInstanceId();
    await prefs.setInt(_isarSchemaVersionKey, _isarSchemaVersion);
    await prefs.setString(_isarInstanceKey, instanceId);
  }

  return '$_isarNamePrefix-$instanceId';
}

Future<String> _rotateIsarName() async {
  final prefs = await SharedPreferences.getInstance();
  final instanceId = _generateInstanceId();
  await prefs.setInt(_isarSchemaVersionKey, _isarSchemaVersion);
  await prefs.setString(_isarInstanceKey, instanceId);
  return '$_isarNamePrefix-$instanceId';
}

String _generateInstanceId() {
  final now = DateTime.now().microsecondsSinceEpoch;
  final rand = Random().nextInt(1 << 32);
  return '$now-$rand';
}

Future<void> _purgeLegacyIsarDirs() async {
  try {
    final supportDir = await getApplicationSupportDirectory();
    final documentsDir = await getApplicationDocumentsDirectory();
    final tempDir = await getTemporaryDirectory();
    final dirs = [
      Directory('${supportDir.path}/isar'),
      Directory('${documentsDir.path}/isar'),
      Directory('${tempDir.path}/isar'),
    ];
    for (final dir in dirs) {
      await _purgeIsarFiles(dir);
    }
  } catch (_) {
    // ignore purge failures
  }
}
