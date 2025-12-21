// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_record.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSessionRecordCollection on Isar {
  IsarCollection<SessionRecord> get sessionRecords => this.collection();
}

const SessionRecordSchema = CollectionSchema(
  name: r'SessionRecord',
  id: -4767949293416338608,
  properties: {
    r'actualDurationMinutes': PropertySchema(
      id: 0,
      name: r'actualDurationMinutes',
      type: IsarType.long,
    ),
    r'completed': PropertySchema(
      id: 1,
      name: r'completed',
      type: IsarType.bool,
    ),
    r'endTime': PropertySchema(
      id: 2,
      name: r'endTime',
      type: IsarType.dateTime,
    ),
    r'interrupted': PropertySchema(
      id: 3,
      name: r'interrupted',
      type: IsarType.bool,
    ),
    r'note': PropertySchema(
      id: 4,
      name: r'note',
      type: IsarType.string,
    ),
    r'plannedDurationMinutes': PropertySchema(
      id: 5,
      name: r'plannedDurationMinutes',
      type: IsarType.long,
    ),
    r'startTime': PropertySchema(
      id: 6,
      name: r'startTime',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _sessionRecordEstimateSize,
  serialize: _sessionRecordSerialize,
  deserialize: _sessionRecordDeserialize,
  deserializeProp: _sessionRecordDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _sessionRecordGetId,
  getLinks: _sessionRecordGetLinks,
  attach: _sessionRecordAttach,
  version: '3.1.0+1',
);

int _sessionRecordEstimateSize(
  SessionRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.note;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _sessionRecordSerialize(
  SessionRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.actualDurationMinutes);
  writer.writeBool(offsets[1], object.completed);
  writer.writeDateTime(offsets[2], object.endTime);
  writer.writeBool(offsets[3], object.interrupted);
  writer.writeString(offsets[4], object.note);
  writer.writeLong(offsets[5], object.plannedDurationMinutes);
  writer.writeDateTime(offsets[6], object.startTime);
}

SessionRecord _sessionRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SessionRecord();
  object.actualDurationMinutes = reader.readLong(offsets[0]);
  object.completed = reader.readBool(offsets[1]);
  object.endTime = reader.readDateTime(offsets[2]);
  object.id = id;
  object.interrupted = reader.readBool(offsets[3]);
  object.note = reader.readStringOrNull(offsets[4]);
  object.plannedDurationMinutes = reader.readLong(offsets[5]);
  object.startTime = reader.readDateTime(offsets[6]);
  return object;
}

P _sessionRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _sessionRecordGetId(SessionRecord object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _sessionRecordGetLinks(SessionRecord object) {
  return [];
}

void _sessionRecordAttach(
    IsarCollection<dynamic> col, Id id, SessionRecord object) {
  object.id = id;
}

extension SessionRecordQueryWhereSort
    on QueryBuilder<SessionRecord, SessionRecord, QWhere> {
  QueryBuilder<SessionRecord, SessionRecord, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SessionRecordQueryWhere
    on QueryBuilder<SessionRecord, SessionRecord, QWhereClause> {
  QueryBuilder<SessionRecord, SessionRecord, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SessionRecordQueryFilter
    on QueryBuilder<SessionRecord, SessionRecord, QFilterCondition> {
  QueryBuilder<SessionRecord, SessionRecord, QAfterFilterCondition>
      actualDurationMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'actualDurationMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QAfterFilterCondition>
      actualDurationMinutesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'actualDurationMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QAfterFilterCondition>
      actualDurationMinutesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'actualDurationMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QAfterFilterCondition>
      actualDurationMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'actualDurationMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QAfterFilterCondition>
      completedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completed',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QAfterFilterCondition>
      endTimeEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endTime',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QAfterFilterCondition>
      endTimeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'endTime',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QAfterFilterCondition>
      endTimeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'endTime',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QAfterFilterCondition>
      endTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'endTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QAfterFilterCondition>
      interruptedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'interrupted',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QAfterFilterCondition>
      noteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'note',
      ));
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QAfterFilterCondition>
      noteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'note',
      ));
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QAfterFilterCondition> noteEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QAfterFilterCondition>
      noteGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QAfterFilterCondition>
      noteLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QAfterFilterCondition> noteBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'note',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QAfterFilterCondition>
      noteStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QAfterFilterCondition>
      noteEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QAfterFilterCondition>
      noteContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QAfterFilterCondition> noteMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'note',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QAfterFilterCondition>
      noteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'note',
        value: '',
      ));
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QAfterFilterCondition>
      noteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'note',
        value: '',
      ));
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QAfterFilterCondition>
      plannedDurationMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'plannedDurationMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QAfterFilterCondition>
      plannedDurationMinutesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'plannedDurationMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QAfterFilterCondition>
      plannedDurationMinutesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'plannedDurationMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QAfterFilterCondition>
      plannedDurationMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'plannedDurationMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QAfterFilterCondition>
      startTimeEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startTime',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QAfterFilterCondition>
      startTimeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startTime',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QAfterFilterCondition>
      startTimeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startTime',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QAfterFilterCondition>
      startTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SessionRecordQueryObject
    on QueryBuilder<SessionRecord, SessionRecord, QFilterCondition> {}

extension SessionRecordQueryLinks
    on QueryBuilder<SessionRecord, SessionRecord, QFilterCondition> {}

extension SessionRecordQuerySortBy
    on QueryBuilder<SessionRecord, SessionRecord, QSortBy> {
  QueryBuilder<SessionRecord, SessionRecord, QAfterSortBy>
      sortByActualDurationMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actualDurationMinutes', Sort.asc);
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QAfterSortBy>
      sortByActualDurationMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actualDurationMinutes', Sort.desc);
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QAfterSortBy> sortByCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completed', Sort.asc);
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QAfterSortBy>
      sortByCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completed', Sort.desc);
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QAfterSortBy> sortByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.asc);
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QAfterSortBy> sortByEndTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.desc);
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QAfterSortBy> sortByInterrupted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'interrupted', Sort.asc);
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QAfterSortBy>
      sortByInterruptedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'interrupted', Sort.desc);
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QAfterSortBy> sortByNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.asc);
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QAfterSortBy> sortByNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.desc);
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QAfterSortBy>
      sortByPlannedDurationMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedDurationMinutes', Sort.asc);
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QAfterSortBy>
      sortByPlannedDurationMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedDurationMinutes', Sort.desc);
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QAfterSortBy> sortByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.asc);
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QAfterSortBy>
      sortByStartTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.desc);
    });
  }
}

extension SessionRecordQuerySortThenBy
    on QueryBuilder<SessionRecord, SessionRecord, QSortThenBy> {
  QueryBuilder<SessionRecord, SessionRecord, QAfterSortBy>
      thenByActualDurationMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actualDurationMinutes', Sort.asc);
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QAfterSortBy>
      thenByActualDurationMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actualDurationMinutes', Sort.desc);
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QAfterSortBy> thenByCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completed', Sort.asc);
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QAfterSortBy>
      thenByCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completed', Sort.desc);
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QAfterSortBy> thenByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.asc);
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QAfterSortBy> thenByEndTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.desc);
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QAfterSortBy> thenByInterrupted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'interrupted', Sort.asc);
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QAfterSortBy>
      thenByInterruptedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'interrupted', Sort.desc);
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QAfterSortBy> thenByNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.asc);
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QAfterSortBy> thenByNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.desc);
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QAfterSortBy>
      thenByPlannedDurationMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedDurationMinutes', Sort.asc);
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QAfterSortBy>
      thenByPlannedDurationMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedDurationMinutes', Sort.desc);
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QAfterSortBy> thenByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.asc);
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QAfterSortBy>
      thenByStartTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.desc);
    });
  }
}

extension SessionRecordQueryWhereDistinct
    on QueryBuilder<SessionRecord, SessionRecord, QDistinct> {
  QueryBuilder<SessionRecord, SessionRecord, QDistinct>
      distinctByActualDurationMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'actualDurationMinutes');
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QDistinct> distinctByCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completed');
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QDistinct> distinctByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endTime');
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QDistinct>
      distinctByInterrupted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'interrupted');
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QDistinct> distinctByNote(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'note', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QDistinct>
      distinctByPlannedDurationMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'plannedDurationMinutes');
    });
  }

  QueryBuilder<SessionRecord, SessionRecord, QDistinct> distinctByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startTime');
    });
  }
}

extension SessionRecordQueryProperty
    on QueryBuilder<SessionRecord, SessionRecord, QQueryProperty> {
  QueryBuilder<SessionRecord, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SessionRecord, int, QQueryOperations>
      actualDurationMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'actualDurationMinutes');
    });
  }

  QueryBuilder<SessionRecord, bool, QQueryOperations> completedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completed');
    });
  }

  QueryBuilder<SessionRecord, DateTime, QQueryOperations> endTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endTime');
    });
  }

  QueryBuilder<SessionRecord, bool, QQueryOperations> interruptedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'interrupted');
    });
  }

  QueryBuilder<SessionRecord, String?, QQueryOperations> noteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'note');
    });
  }

  QueryBuilder<SessionRecord, int, QQueryOperations>
      plannedDurationMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'plannedDurationMinutes');
    });
  }

  QueryBuilder<SessionRecord, DateTime, QQueryOperations> startTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startTime');
    });
  }
}
