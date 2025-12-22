import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import 'isar_service.dart';
import 'models/session_record.dart';

class SessionRepository {
  SessionRepository(this._isarManager);

  final IsarManager _isarManager;

  Isar get _isar => _isarManager.isar;

  Future<int> insert(SessionRecord record) async {
    return _isar.writeTxn(() => _isar.sessionRecords.put(record));
  }

  Future<void> update(SessionRecord record) async {
    await _isar.writeTxn(() => _isar.sessionRecords.put(record));
  }

  Stream<List<SessionRecord>> watchAll() {
    return _isar.sessionRecords.where().sortByStartTimeDesc().watch(
      fireImmediately: true,
    );
  }

  Future<List<SessionRecord>> fetchAll() {
    return _isar.sessionRecords.where().sortByStartTimeDesc().findAll();
  }
}

final sessionRepositoryProvider = Provider<SessionRepository>(
  (ref) => SessionRepository(ref.watch(isarProvider)),
);

final sessionHistoryProvider = StreamProvider<List<SessionRecord>>(
  (ref) => ref.watch(sessionRepositoryProvider).watchAll(),
);
