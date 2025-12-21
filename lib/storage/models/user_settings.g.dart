// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetUserSettingsCollection on Isar {
  IsarCollection<UserSettings> get userSettings => this.collection();
}

const UserSettingsSchema = CollectionSchema(
  name: r'UserSettings',
  id: 4939698790990493221,
  properties: {
    r'completionSoundEnabled': PropertySchema(
      id: 0,
      name: r'completionSoundEnabled',
      type: IsarType.bool,
    ),
    r'dailyGoalMinutes': PropertySchema(
      id: 1,
      name: r'dailyGoalMinutes',
      type: IsarType.long,
    ),
    r'defaultSessionDurationMinutes': PropertySchema(
      id: 2,
      name: r'defaultSessionDurationMinutes',
      type: IsarType.long,
    ),
    r'meditationCountMode': PropertySchema(
      id: 3,
      name: r'meditationCountMode',
      type: IsarType.string,
      enumMap: _UserSettingsmeditationCountModeEnumValueMap,
    ),
    r'onboardingCompleted': PropertySchema(
      id: 4,
      name: r'onboardingCompleted',
      type: IsarType.bool,
    ),
    r'preEndAlertEnabled': PropertySchema(
      id: 5,
      name: r'preEndAlertEnabled',
      type: IsarType.bool,
    ),
    r'reminderDays': PropertySchema(
      id: 6,
      name: r'reminderDays',
      type: IsarType.longList,
    ),
    r'reminderEnabled': PropertySchema(
      id: 7,
      name: r'reminderEnabled',
      type: IsarType.bool,
    ),
    r'reminderTime': PropertySchema(
      id: 8,
      name: r'reminderTime',
      type: IsarType.string,
    ),
    r'theme': PropertySchema(
      id: 9,
      name: r'theme',
      type: IsarType.string,
      enumMap: _UserSettingsthemeEnumValueMap,
    ),
    r'vibrationEnabled': PropertySchema(
      id: 10,
      name: r'vibrationEnabled',
      type: IsarType.bool,
    )
  },
  estimateSize: _userSettingsEstimateSize,
  serialize: _userSettingsSerialize,
  deserialize: _userSettingsDeserialize,
  deserializeProp: _userSettingsDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _userSettingsGetId,
  getLinks: _userSettingsGetLinks,
  attach: _userSettingsAttach,
  version: '3.1.0+1',
);

int _userSettingsEstimateSize(
  UserSettings object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.meditationCountMode.name.length * 3;
  bytesCount += 3 + object.reminderDays.length * 8;
  {
    final value = object.reminderTime;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.theme.name.length * 3;
  return bytesCount;
}

void _userSettingsSerialize(
  UserSettings object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.completionSoundEnabled);
  writer.writeLong(offsets[1], object.dailyGoalMinutes);
  writer.writeLong(offsets[2], object.defaultSessionDurationMinutes);
  writer.writeString(offsets[3], object.meditationCountMode.name);
  writer.writeBool(offsets[4], object.onboardingCompleted);
  writer.writeBool(offsets[5], object.preEndAlertEnabled);
  writer.writeLongList(offsets[6], object.reminderDays);
  writer.writeBool(offsets[7], object.reminderEnabled);
  writer.writeString(offsets[8], object.reminderTime);
  writer.writeString(offsets[9], object.theme.name);
  writer.writeBool(offsets[10], object.vibrationEnabled);
}

UserSettings _userSettingsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = UserSettings();
  object.completionSoundEnabled = reader.readBool(offsets[0]);
  object.dailyGoalMinutes = reader.readLong(offsets[1]);
  object.defaultSessionDurationMinutes = reader.readLong(offsets[2]);
  object.id = id;
  object.meditationCountMode = _UserSettingsmeditationCountModeValueEnumMap[
          reader.readStringOrNull(offsets[3])] ??
      MeditationCountMode.cumulative;
  object.onboardingCompleted = reader.readBool(offsets[4]);
  object.preEndAlertEnabled = reader.readBool(offsets[5]);
  object.reminderDays = reader.readLongList(offsets[6]) ?? [];
  object.reminderEnabled = reader.readBool(offsets[7]);
  object.reminderTime = reader.readStringOrNull(offsets[8]);
  object.theme =
      _UserSettingsthemeValueEnumMap[reader.readStringOrNull(offsets[9])] ??
          AppThemePreference.dark;
  object.vibrationEnabled = reader.readBool(offsets[10]);
  return object;
}

P _userSettingsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (_UserSettingsmeditationCountModeValueEnumMap[
              reader.readStringOrNull(offset)] ??
          MeditationCountMode.cumulative) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readLongList(offset) ?? []) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (_UserSettingsthemeValueEnumMap[reader.readStringOrNull(offset)] ??
          AppThemePreference.dark) as P;
    case 10:
      return (reader.readBool(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _UserSettingsmeditationCountModeEnumValueMap = {
  r'cumulative': r'cumulative',
  r'deepest': r'deepest',
};
const _UserSettingsmeditationCountModeValueEnumMap = {
  r'cumulative': MeditationCountMode.cumulative,
  r'deepest': MeditationCountMode.deepest,
};
const _UserSettingsthemeEnumValueMap = {
  r'dark': r'dark',
  r'light': r'light',
};
const _UserSettingsthemeValueEnumMap = {
  r'dark': AppThemePreference.dark,
  r'light': AppThemePreference.light,
};

Id _userSettingsGetId(UserSettings object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _userSettingsGetLinks(UserSettings object) {
  return [];
}

void _userSettingsAttach(
    IsarCollection<dynamic> col, Id id, UserSettings object) {
  object.id = id;
}

extension UserSettingsQueryWhereSort
    on QueryBuilder<UserSettings, UserSettings, QWhere> {
  QueryBuilder<UserSettings, UserSettings, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension UserSettingsQueryWhere
    on QueryBuilder<UserSettings, UserSettings, QWhereClause> {
  QueryBuilder<UserSettings, UserSettings, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<UserSettings, UserSettings, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterWhereClause> idBetween(
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

extension UserSettingsQueryFilter
    on QueryBuilder<UserSettings, UserSettings, QFilterCondition> {
  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      completionSoundEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completionSoundEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      dailyGoalMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dailyGoalMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      dailyGoalMinutesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dailyGoalMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      dailyGoalMinutesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dailyGoalMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      dailyGoalMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dailyGoalMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      defaultSessionDurationMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'defaultSessionDurationMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      defaultSessionDurationMinutesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'defaultSessionDurationMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      defaultSessionDurationMinutesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'defaultSessionDurationMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      defaultSessionDurationMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'defaultSessionDurationMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition> idBetween(
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

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      meditationCountModeEqualTo(
    MeditationCountMode value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'meditationCountMode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      meditationCountModeGreaterThan(
    MeditationCountMode value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'meditationCountMode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      meditationCountModeLessThan(
    MeditationCountMode value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'meditationCountMode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      meditationCountModeBetween(
    MeditationCountMode lower,
    MeditationCountMode upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'meditationCountMode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      meditationCountModeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'meditationCountMode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      meditationCountModeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'meditationCountMode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      meditationCountModeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'meditationCountMode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      meditationCountModeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'meditationCountMode',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      meditationCountModeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'meditationCountMode',
        value: '',
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      meditationCountModeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'meditationCountMode',
        value: '',
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      onboardingCompletedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'onboardingCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      preEndAlertEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'preEndAlertEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      reminderDaysElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reminderDays',
        value: value,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      reminderDaysElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reminderDays',
        value: value,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      reminderDaysElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reminderDays',
        value: value,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      reminderDaysElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reminderDays',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      reminderDaysLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'reminderDays',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      reminderDaysIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'reminderDays',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      reminderDaysIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'reminderDays',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      reminderDaysLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'reminderDays',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      reminderDaysLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'reminderDays',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      reminderDaysLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'reminderDays',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      reminderEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reminderEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      reminderTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'reminderTime',
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      reminderTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'reminderTime',
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      reminderTimeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reminderTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      reminderTimeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reminderTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      reminderTimeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reminderTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      reminderTimeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reminderTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      reminderTimeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'reminderTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      reminderTimeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'reminderTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      reminderTimeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'reminderTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      reminderTimeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'reminderTime',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      reminderTimeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reminderTime',
        value: '',
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      reminderTimeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'reminderTime',
        value: '',
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition> themeEqualTo(
    AppThemePreference value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'theme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      themeGreaterThan(
    AppThemePreference value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'theme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition> themeLessThan(
    AppThemePreference value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'theme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition> themeBetween(
    AppThemePreference lower,
    AppThemePreference upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'theme',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      themeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'theme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition> themeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'theme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition> themeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'theme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition> themeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'theme',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      themeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'theme',
        value: '',
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      themeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'theme',
        value: '',
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      vibrationEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vibrationEnabled',
        value: value,
      ));
    });
  }
}

extension UserSettingsQueryObject
    on QueryBuilder<UserSettings, UserSettings, QFilterCondition> {}

extension UserSettingsQueryLinks
    on QueryBuilder<UserSettings, UserSettings, QFilterCondition> {}

extension UserSettingsQuerySortBy
    on QueryBuilder<UserSettings, UserSettings, QSortBy> {
  QueryBuilder<UserSettings, UserSettings, QAfterSortBy>
      sortByCompletionSoundEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completionSoundEnabled', Sort.asc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy>
      sortByCompletionSoundEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completionSoundEnabled', Sort.desc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy>
      sortByDailyGoalMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyGoalMinutes', Sort.asc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy>
      sortByDailyGoalMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyGoalMinutes', Sort.desc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy>
      sortByDefaultSessionDurationMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultSessionDurationMinutes', Sort.asc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy>
      sortByDefaultSessionDurationMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultSessionDurationMinutes', Sort.desc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy>
      sortByMeditationCountMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'meditationCountMode', Sort.asc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy>
      sortByMeditationCountModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'meditationCountMode', Sort.desc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy>
      sortByOnboardingCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onboardingCompleted', Sort.asc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy>
      sortByOnboardingCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onboardingCompleted', Sort.desc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy>
      sortByPreEndAlertEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preEndAlertEnabled', Sort.asc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy>
      sortByPreEndAlertEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preEndAlertEnabled', Sort.desc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy>
      sortByReminderEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderEnabled', Sort.asc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy>
      sortByReminderEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderEnabled', Sort.desc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy> sortByReminderTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderTime', Sort.asc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy>
      sortByReminderTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderTime', Sort.desc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy> sortByTheme() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'theme', Sort.asc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy> sortByThemeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'theme', Sort.desc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy>
      sortByVibrationEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vibrationEnabled', Sort.asc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy>
      sortByVibrationEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vibrationEnabled', Sort.desc);
    });
  }
}

extension UserSettingsQuerySortThenBy
    on QueryBuilder<UserSettings, UserSettings, QSortThenBy> {
  QueryBuilder<UserSettings, UserSettings, QAfterSortBy>
      thenByCompletionSoundEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completionSoundEnabled', Sort.asc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy>
      thenByCompletionSoundEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completionSoundEnabled', Sort.desc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy>
      thenByDailyGoalMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyGoalMinutes', Sort.asc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy>
      thenByDailyGoalMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyGoalMinutes', Sort.desc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy>
      thenByDefaultSessionDurationMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultSessionDurationMinutes', Sort.asc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy>
      thenByDefaultSessionDurationMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultSessionDurationMinutes', Sort.desc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy>
      thenByMeditationCountMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'meditationCountMode', Sort.asc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy>
      thenByMeditationCountModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'meditationCountMode', Sort.desc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy>
      thenByOnboardingCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onboardingCompleted', Sort.asc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy>
      thenByOnboardingCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onboardingCompleted', Sort.desc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy>
      thenByPreEndAlertEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preEndAlertEnabled', Sort.asc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy>
      thenByPreEndAlertEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preEndAlertEnabled', Sort.desc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy>
      thenByReminderEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderEnabled', Sort.asc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy>
      thenByReminderEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderEnabled', Sort.desc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy> thenByReminderTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderTime', Sort.asc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy>
      thenByReminderTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderTime', Sort.desc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy> thenByTheme() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'theme', Sort.asc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy> thenByThemeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'theme', Sort.desc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy>
      thenByVibrationEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vibrationEnabled', Sort.asc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy>
      thenByVibrationEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vibrationEnabled', Sort.desc);
    });
  }
}

extension UserSettingsQueryWhereDistinct
    on QueryBuilder<UserSettings, UserSettings, QDistinct> {
  QueryBuilder<UserSettings, UserSettings, QDistinct>
      distinctByCompletionSoundEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completionSoundEnabled');
    });
  }

  QueryBuilder<UserSettings, UserSettings, QDistinct>
      distinctByDailyGoalMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dailyGoalMinutes');
    });
  }

  QueryBuilder<UserSettings, UserSettings, QDistinct>
      distinctByDefaultSessionDurationMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'defaultSessionDurationMinutes');
    });
  }

  QueryBuilder<UserSettings, UserSettings, QDistinct>
      distinctByMeditationCountMode({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'meditationCountMode',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QDistinct>
      distinctByOnboardingCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'onboardingCompleted');
    });
  }

  QueryBuilder<UserSettings, UserSettings, QDistinct>
      distinctByPreEndAlertEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'preEndAlertEnabled');
    });
  }

  QueryBuilder<UserSettings, UserSettings, QDistinct> distinctByReminderDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reminderDays');
    });
  }

  QueryBuilder<UserSettings, UserSettings, QDistinct>
      distinctByReminderEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reminderEnabled');
    });
  }

  QueryBuilder<UserSettings, UserSettings, QDistinct> distinctByReminderTime(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reminderTime', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QDistinct> distinctByTheme(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'theme', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QDistinct>
      distinctByVibrationEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'vibrationEnabled');
    });
  }
}

extension UserSettingsQueryProperty
    on QueryBuilder<UserSettings, UserSettings, QQueryProperty> {
  QueryBuilder<UserSettings, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<UserSettings, bool, QQueryOperations>
      completionSoundEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completionSoundEnabled');
    });
  }

  QueryBuilder<UserSettings, int, QQueryOperations> dailyGoalMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dailyGoalMinutes');
    });
  }

  QueryBuilder<UserSettings, int, QQueryOperations>
      defaultSessionDurationMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'defaultSessionDurationMinutes');
    });
  }

  QueryBuilder<UserSettings, MeditationCountMode, QQueryOperations>
      meditationCountModeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'meditationCountMode');
    });
  }

  QueryBuilder<UserSettings, bool, QQueryOperations>
      onboardingCompletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'onboardingCompleted');
    });
  }

  QueryBuilder<UserSettings, bool, QQueryOperations>
      preEndAlertEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'preEndAlertEnabled');
    });
  }

  QueryBuilder<UserSettings, List<int>, QQueryOperations>
      reminderDaysProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reminderDays');
    });
  }

  QueryBuilder<UserSettings, bool, QQueryOperations> reminderEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reminderEnabled');
    });
  }

  QueryBuilder<UserSettings, String?, QQueryOperations> reminderTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reminderTime');
    });
  }

  QueryBuilder<UserSettings, AppThemePreference, QQueryOperations>
      themeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'theme');
    });
  }

  QueryBuilder<UserSettings, bool, QQueryOperations>
      vibrationEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'vibrationEnabled');
    });
  }
}
