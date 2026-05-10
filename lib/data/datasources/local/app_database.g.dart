// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SchoolsTableTable extends SchoolsTable
    with TableInfo<$SchoolsTableTable, SchoolDto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SchoolsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dailySessionsMeta =
      const VerificationMeta('dailySessions');
  @override
  late final GeneratedColumn<int> dailySessions = GeneratedColumn<int>(
      'daily_sessions', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _workDaysMeta =
      const VerificationMeta('workDays');
  @override
  late final GeneratedColumnWithTypeConverter<List<WorkDay>, String> workDays =
      GeneratedColumn<String>('work_days', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<List<WorkDay>>($SchoolsTableTable.$converterworkDays);
  static const VerificationMeta _firstSessionTimeMeta =
      const VerificationMeta('firstSessionTime');
  @override
  late final GeneratedColumn<int> firstSessionTime = GeneratedColumn<int>(
      'first_session_time', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _sessionDurationMeta =
      const VerificationMeta('sessionDuration');
  @override
  late final GeneratedColumn<int> sessionDuration = GeneratedColumn<int>(
      'session_duration', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _academicYearMeta =
      const VerificationMeta('academicYear');
  @override
  late final GeneratedColumn<String> academicYear = GeneratedColumn<String>(
      'academic_year', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        address,
        phone,
        email,
        dailySessions,
        workDays,
        firstSessionTime,
        sessionDuration,
        academicYear
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'schools_table';
  @override
  VerificationContext validateIntegrity(Insertable<SchoolDto> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    } else if (isInserting) {
      context.missing(_phoneMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('daily_sessions')) {
      context.handle(
          _dailySessionsMeta,
          dailySessions.isAcceptableOrUnknown(
              data['daily_sessions']!, _dailySessionsMeta));
    } else if (isInserting) {
      context.missing(_dailySessionsMeta);
    }
    context.handle(_workDaysMeta, const VerificationResult.success());
    if (data.containsKey('first_session_time')) {
      context.handle(
          _firstSessionTimeMeta,
          firstSessionTime.isAcceptableOrUnknown(
              data['first_session_time']!, _firstSessionTimeMeta));
    } else if (isInserting) {
      context.missing(_firstSessionTimeMeta);
    }
    if (data.containsKey('session_duration')) {
      context.handle(
          _sessionDurationMeta,
          sessionDuration.isAcceptableOrUnknown(
              data['session_duration']!, _sessionDurationMeta));
    } else if (isInserting) {
      context.missing(_sessionDurationMeta);
    }
    if (data.containsKey('academic_year')) {
      context.handle(
          _academicYearMeta,
          academicYear.isAcceptableOrUnknown(
              data['academic_year']!, _academicYearMeta));
    } else if (isInserting) {
      context.missing(_academicYearMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SchoolDto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SchoolDto(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address'])!,
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email'])!,
      dailySessions: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}daily_sessions'])!,
      workDays: $SchoolsTableTable.$converterworkDays.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}work_days'])!),
      firstSessionTime: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}first_session_time'])!,
      sessionDuration: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}session_duration'])!,
      academicYear: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}academic_year'])!,
    );
  }

  @override
  $SchoolsTableTable createAlias(String alias) {
    return $SchoolsTableTable(attachedDatabase, alias);
  }

  static TypeConverter<List<WorkDay>, String> $converterworkDays =
      const WorkDayListConverter();
}

class SchoolDto extends DataClass implements Insertable<SchoolDto> {
  final String id;
  final String name;
  final String address;
  final String phone;
  final String email;
  final int dailySessions;
  final List<WorkDay> workDays;
  final int firstSessionTime;
  final int sessionDuration;
  final String academicYear;
  const SchoolDto(
      {required this.id,
      required this.name,
      required this.address,
      required this.phone,
      required this.email,
      required this.dailySessions,
      required this.workDays,
      required this.firstSessionTime,
      required this.sessionDuration,
      required this.academicYear});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['address'] = Variable<String>(address);
    map['phone'] = Variable<String>(phone);
    map['email'] = Variable<String>(email);
    map['daily_sessions'] = Variable<int>(dailySessions);
    {
      map['work_days'] = Variable<String>(
          $SchoolsTableTable.$converterworkDays.toSql(workDays));
    }
    map['first_session_time'] = Variable<int>(firstSessionTime);
    map['session_duration'] = Variable<int>(sessionDuration);
    map['academic_year'] = Variable<String>(academicYear);
    return map;
  }

  SchoolsTableCompanion toCompanion(bool nullToAbsent) {
    return SchoolsTableCompanion(
      id: Value(id),
      name: Value(name),
      address: Value(address),
      phone: Value(phone),
      email: Value(email),
      dailySessions: Value(dailySessions),
      workDays: Value(workDays),
      firstSessionTime: Value(firstSessionTime),
      sessionDuration: Value(sessionDuration),
      academicYear: Value(academicYear),
    );
  }

  factory SchoolDto.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SchoolDto(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      address: serializer.fromJson<String>(json['address']),
      phone: serializer.fromJson<String>(json['phone']),
      email: serializer.fromJson<String>(json['email']),
      dailySessions: serializer.fromJson<int>(json['dailySessions']),
      workDays: serializer.fromJson<List<WorkDay>>(json['workDays']),
      firstSessionTime: serializer.fromJson<int>(json['firstSessionTime']),
      sessionDuration: serializer.fromJson<int>(json['sessionDuration']),
      academicYear: serializer.fromJson<String>(json['academicYear']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'address': serializer.toJson<String>(address),
      'phone': serializer.toJson<String>(phone),
      'email': serializer.toJson<String>(email),
      'dailySessions': serializer.toJson<int>(dailySessions),
      'workDays': serializer.toJson<List<WorkDay>>(workDays),
      'firstSessionTime': serializer.toJson<int>(firstSessionTime),
      'sessionDuration': serializer.toJson<int>(sessionDuration),
      'academicYear': serializer.toJson<String>(academicYear),
    };
  }

  SchoolDto copyWith(
          {String? id,
          String? name,
          String? address,
          String? phone,
          String? email,
          int? dailySessions,
          List<WorkDay>? workDays,
          int? firstSessionTime,
          int? sessionDuration,
          String? academicYear}) =>
      SchoolDto(
        id: id ?? this.id,
        name: name ?? this.name,
        address: address ?? this.address,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        dailySessions: dailySessions ?? this.dailySessions,
        workDays: workDays ?? this.workDays,
        firstSessionTime: firstSessionTime ?? this.firstSessionTime,
        sessionDuration: sessionDuration ?? this.sessionDuration,
        academicYear: academicYear ?? this.academicYear,
      );
  SchoolDto copyWithCompanion(SchoolsTableCompanion data) {
    return SchoolDto(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      address: data.address.present ? data.address.value : this.address,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      dailySessions: data.dailySessions.present
          ? data.dailySessions.value
          : this.dailySessions,
      workDays: data.workDays.present ? data.workDays.value : this.workDays,
      firstSessionTime: data.firstSessionTime.present
          ? data.firstSessionTime.value
          : this.firstSessionTime,
      sessionDuration: data.sessionDuration.present
          ? data.sessionDuration.value
          : this.sessionDuration,
      academicYear: data.academicYear.present
          ? data.academicYear.value
          : this.academicYear,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SchoolDto(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('dailySessions: $dailySessions, ')
          ..write('workDays: $workDays, ')
          ..write('firstSessionTime: $firstSessionTime, ')
          ..write('sessionDuration: $sessionDuration, ')
          ..write('academicYear: $academicYear')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, address, phone, email,
      dailySessions, workDays, firstSessionTime, sessionDuration, academicYear);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SchoolDto &&
          other.id == this.id &&
          other.name == this.name &&
          other.address == this.address &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.dailySessions == this.dailySessions &&
          other.workDays == this.workDays &&
          other.firstSessionTime == this.firstSessionTime &&
          other.sessionDuration == this.sessionDuration &&
          other.academicYear == this.academicYear);
}

class SchoolsTableCompanion extends UpdateCompanion<SchoolDto> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> address;
  final Value<String> phone;
  final Value<String> email;
  final Value<int> dailySessions;
  final Value<List<WorkDay>> workDays;
  final Value<int> firstSessionTime;
  final Value<int> sessionDuration;
  final Value<String> academicYear;
  final Value<int> rowid;
  const SchoolsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.address = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.dailySessions = const Value.absent(),
    this.workDays = const Value.absent(),
    this.firstSessionTime = const Value.absent(),
    this.sessionDuration = const Value.absent(),
    this.academicYear = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SchoolsTableCompanion.insert({
    required String id,
    required String name,
    required String address,
    required String phone,
    required String email,
    required int dailySessions,
    required List<WorkDay> workDays,
    required int firstSessionTime,
    required int sessionDuration,
    required String academicYear,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        address = Value(address),
        phone = Value(phone),
        email = Value(email),
        dailySessions = Value(dailySessions),
        workDays = Value(workDays),
        firstSessionTime = Value(firstSessionTime),
        sessionDuration = Value(sessionDuration),
        academicYear = Value(academicYear);
  static Insertable<SchoolDto> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? address,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<int>? dailySessions,
    Expression<String>? workDays,
    Expression<int>? firstSessionTime,
    Expression<int>? sessionDuration,
    Expression<String>? academicYear,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (address != null) 'address': address,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (dailySessions != null) 'daily_sessions': dailySessions,
      if (workDays != null) 'work_days': workDays,
      if (firstSessionTime != null) 'first_session_time': firstSessionTime,
      if (sessionDuration != null) 'session_duration': sessionDuration,
      if (academicYear != null) 'academic_year': academicYear,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SchoolsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? address,
      Value<String>? phone,
      Value<String>? email,
      Value<int>? dailySessions,
      Value<List<WorkDay>>? workDays,
      Value<int>? firstSessionTime,
      Value<int>? sessionDuration,
      Value<String>? academicYear,
      Value<int>? rowid}) {
    return SchoolsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      dailySessions: dailySessions ?? this.dailySessions,
      workDays: workDays ?? this.workDays,
      firstSessionTime: firstSessionTime ?? this.firstSessionTime,
      sessionDuration: sessionDuration ?? this.sessionDuration,
      academicYear: academicYear ?? this.academicYear,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (dailySessions.present) {
      map['daily_sessions'] = Variable<int>(dailySessions.value);
    }
    if (workDays.present) {
      map['work_days'] = Variable<String>(
          $SchoolsTableTable.$converterworkDays.toSql(workDays.value));
    }
    if (firstSessionTime.present) {
      map['first_session_time'] = Variable<int>(firstSessionTime.value);
    }
    if (sessionDuration.present) {
      map['session_duration'] = Variable<int>(sessionDuration.value);
    }
    if (academicYear.present) {
      map['academic_year'] = Variable<String>(academicYear.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SchoolsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('dailySessions: $dailySessions, ')
          ..write('workDays: $workDays, ')
          ..write('firstSessionTime: $firstSessionTime, ')
          ..write('sessionDuration: $sessionDuration, ')
          ..write('academicYear: $academicYear, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TeachersTableTable extends TeachersTable
    with TableInfo<$TeachersTableTable, TeacherDto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TeachersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fullNameMeta =
      const VerificationMeta('fullName');
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
      'full_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _qualificationMeta =
      const VerificationMeta('qualification');
  @override
  late final GeneratedColumn<String> qualification = GeneratedColumn<String>(
      'qualification', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _specializationMeta =
      const VerificationMeta('specialization');
  @override
  late final GeneratedColumn<String> specialization = GeneratedColumn<String>(
      'specialization', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _maxWeeklyHoursMeta =
      const VerificationMeta('maxWeeklyHours');
  @override
  late final GeneratedColumn<int> maxWeeklyHours = GeneratedColumn<int>(
      'max_weekly_hours', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _maxDailyHoursMeta =
      const VerificationMeta('maxDailyHours');
  @override
  late final GeneratedColumn<int> maxDailyHours = GeneratedColumn<int>(
      'max_daily_hours', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _unavailablePeriodsMeta =
      const VerificationMeta('unavailablePeriods');
  @override
  late final GeneratedColumnWithTypeConverter<Map<WorkDay, List<int>>, String>
      unavailablePeriods = GeneratedColumn<String>(
              'unavailable_periods', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<Map<WorkDay, List<int>>>(
              $TeachersTableTable.$converterunavailablePeriods);
  static const VerificationMeta _subjectIdsMeta =
      const VerificationMeta('subjectIds');
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> subjectIds =
      GeneratedColumn<String>('subject_ids', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<List<String>>(
              $TeachersTableTable.$convertersubjectIds);
  static const VerificationMeta _classIdsMeta =
      const VerificationMeta('classIds');
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> classIds =
      GeneratedColumn<String>('class_ids', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<List<String>>($TeachersTableTable.$converterclassIds);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumnWithTypeConverter<TeacherType, int> type =
      GeneratedColumn<int>('type', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<TeacherType>($TeachersTableTable.$convertertype);
  static const VerificationMeta _workDaysMeta =
      const VerificationMeta('workDays');
  @override
  late final GeneratedColumnWithTypeConverter<List<WorkDay>, String> workDays =
      GeneratedColumn<String>('work_days', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: const Constant('[]'))
          .withConverter<List<WorkDay>>($TeachersTableTable.$converterworkDays);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        fullName,
        qualification,
        specialization,
        phone,
        email,
        maxWeeklyHours,
        maxDailyHours,
        unavailablePeriods,
        subjectIds,
        classIds,
        type,
        workDays
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'teachers_table';
  @override
  VerificationContext validateIntegrity(Insertable<TeacherDto> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('full_name')) {
      context.handle(_fullNameMeta,
          fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta));
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('qualification')) {
      context.handle(
          _qualificationMeta,
          qualification.isAcceptableOrUnknown(
              data['qualification']!, _qualificationMeta));
    }
    if (data.containsKey('specialization')) {
      context.handle(
          _specializationMeta,
          specialization.isAcceptableOrUnknown(
              data['specialization']!, _specializationMeta));
    } else if (isInserting) {
      context.missing(_specializationMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    } else if (isInserting) {
      context.missing(_phoneMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('max_weekly_hours')) {
      context.handle(
          _maxWeeklyHoursMeta,
          maxWeeklyHours.isAcceptableOrUnknown(
              data['max_weekly_hours']!, _maxWeeklyHoursMeta));
    } else if (isInserting) {
      context.missing(_maxWeeklyHoursMeta);
    }
    if (data.containsKey('max_daily_hours')) {
      context.handle(
          _maxDailyHoursMeta,
          maxDailyHours.isAcceptableOrUnknown(
              data['max_daily_hours']!, _maxDailyHoursMeta));
    } else if (isInserting) {
      context.missing(_maxDailyHoursMeta);
    }
    context.handle(_unavailablePeriodsMeta, const VerificationResult.success());
    context.handle(_subjectIdsMeta, const VerificationResult.success());
    context.handle(_classIdsMeta, const VerificationResult.success());
    context.handle(_typeMeta, const VerificationResult.success());
    context.handle(_workDaysMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TeacherDto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TeacherDto(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      fullName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}full_name'])!,
      qualification: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}qualification']),
      specialization: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}specialization'])!,
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      maxWeeklyHours: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}max_weekly_hours'])!,
      maxDailyHours: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}max_daily_hours'])!,
      unavailablePeriods: $TeachersTableTable.$converterunavailablePeriods
          .fromSql(attachedDatabase.typeMapping.read(DriftSqlType.string,
              data['${effectivePrefix}unavailable_periods'])!),
      subjectIds: $TeachersTableTable.$convertersubjectIds.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}subject_ids'])!),
      classIds: $TeachersTableTable.$converterclassIds.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}class_ids'])!),
      type: $TeachersTableTable.$convertertype.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}type'])!),
      workDays: $TeachersTableTable.$converterworkDays.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}work_days'])!),
    );
  }

  @override
  $TeachersTableTable createAlias(String alias) {
    return $TeachersTableTable(attachedDatabase, alias);
  }

  static TypeConverter<Map<WorkDay, List<int>>, String>
      $converterunavailablePeriods = const IntListMapConverter();
  static TypeConverter<List<String>, String> $convertersubjectIds =
      const StringListConverter();
  static TypeConverter<List<String>, String> $converterclassIds =
      const StringListConverter();
  static JsonTypeConverter2<TeacherType, int, int> $convertertype =
      const EnumIndexConverter<TeacherType>(TeacherType.values);
  static TypeConverter<List<WorkDay>, String> $converterworkDays =
      const WorkDayListConverter();
}

class TeacherDto extends DataClass implements Insertable<TeacherDto> {
  final String id;
  final String fullName;
  final String? qualification;
  final String specialization;
  final String phone;
  final String? email;
  final int maxWeeklyHours;
  final int maxDailyHours;
  final Map<WorkDay, List<int>> unavailablePeriods;
  final List<String> subjectIds;
  final List<String> classIds;
  final TeacherType type;
  final List<WorkDay> workDays;
  const TeacherDto(
      {required this.id,
      required this.fullName,
      this.qualification,
      required this.specialization,
      required this.phone,
      this.email,
      required this.maxWeeklyHours,
      required this.maxDailyHours,
      required this.unavailablePeriods,
      required this.subjectIds,
      required this.classIds,
      required this.type,
      required this.workDays});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['full_name'] = Variable<String>(fullName);
    if (!nullToAbsent || qualification != null) {
      map['qualification'] = Variable<String>(qualification);
    }
    map['specialization'] = Variable<String>(specialization);
    map['phone'] = Variable<String>(phone);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    map['max_weekly_hours'] = Variable<int>(maxWeeklyHours);
    map['max_daily_hours'] = Variable<int>(maxDailyHours);
    {
      map['unavailable_periods'] = Variable<String>($TeachersTableTable
          .$converterunavailablePeriods
          .toSql(unavailablePeriods));
    }
    {
      map['subject_ids'] = Variable<String>(
          $TeachersTableTable.$convertersubjectIds.toSql(subjectIds));
    }
    {
      map['class_ids'] = Variable<String>(
          $TeachersTableTable.$converterclassIds.toSql(classIds));
    }
    {
      map['type'] =
          Variable<int>($TeachersTableTable.$convertertype.toSql(type));
    }
    {
      map['work_days'] = Variable<String>(
          $TeachersTableTable.$converterworkDays.toSql(workDays));
    }
    return map;
  }

  TeachersTableCompanion toCompanion(bool nullToAbsent) {
    return TeachersTableCompanion(
      id: Value(id),
      fullName: Value(fullName),
      qualification: qualification == null && nullToAbsent
          ? const Value.absent()
          : Value(qualification),
      specialization: Value(specialization),
      phone: Value(phone),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      maxWeeklyHours: Value(maxWeeklyHours),
      maxDailyHours: Value(maxDailyHours),
      unavailablePeriods: Value(unavailablePeriods),
      subjectIds: Value(subjectIds),
      classIds: Value(classIds),
      type: Value(type),
      workDays: Value(workDays),
    );
  }

  factory TeacherDto.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TeacherDto(
      id: serializer.fromJson<String>(json['id']),
      fullName: serializer.fromJson<String>(json['fullName']),
      qualification: serializer.fromJson<String?>(json['qualification']),
      specialization: serializer.fromJson<String>(json['specialization']),
      phone: serializer.fromJson<String>(json['phone']),
      email: serializer.fromJson<String?>(json['email']),
      maxWeeklyHours: serializer.fromJson<int>(json['maxWeeklyHours']),
      maxDailyHours: serializer.fromJson<int>(json['maxDailyHours']),
      unavailablePeriods: serializer
          .fromJson<Map<WorkDay, List<int>>>(json['unavailablePeriods']),
      subjectIds: serializer.fromJson<List<String>>(json['subjectIds']),
      classIds: serializer.fromJson<List<String>>(json['classIds']),
      type: $TeachersTableTable.$convertertype
          .fromJson(serializer.fromJson<int>(json['type'])),
      workDays: serializer.fromJson<List<WorkDay>>(json['workDays']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'fullName': serializer.toJson<String>(fullName),
      'qualification': serializer.toJson<String?>(qualification),
      'specialization': serializer.toJson<String>(specialization),
      'phone': serializer.toJson<String>(phone),
      'email': serializer.toJson<String?>(email),
      'maxWeeklyHours': serializer.toJson<int>(maxWeeklyHours),
      'maxDailyHours': serializer.toJson<int>(maxDailyHours),
      'unavailablePeriods':
          serializer.toJson<Map<WorkDay, List<int>>>(unavailablePeriods),
      'subjectIds': serializer.toJson<List<String>>(subjectIds),
      'classIds': serializer.toJson<List<String>>(classIds),
      'type': serializer
          .toJson<int>($TeachersTableTable.$convertertype.toJson(type)),
      'workDays': serializer.toJson<List<WorkDay>>(workDays),
    };
  }

  TeacherDto copyWith(
          {String? id,
          String? fullName,
          Value<String?> qualification = const Value.absent(),
          String? specialization,
          String? phone,
          Value<String?> email = const Value.absent(),
          int? maxWeeklyHours,
          int? maxDailyHours,
          Map<WorkDay, List<int>>? unavailablePeriods,
          List<String>? subjectIds,
          List<String>? classIds,
          TeacherType? type,
          List<WorkDay>? workDays}) =>
      TeacherDto(
        id: id ?? this.id,
        fullName: fullName ?? this.fullName,
        qualification:
            qualification.present ? qualification.value : this.qualification,
        specialization: specialization ?? this.specialization,
        phone: phone ?? this.phone,
        email: email.present ? email.value : this.email,
        maxWeeklyHours: maxWeeklyHours ?? this.maxWeeklyHours,
        maxDailyHours: maxDailyHours ?? this.maxDailyHours,
        unavailablePeriods: unavailablePeriods ?? this.unavailablePeriods,
        subjectIds: subjectIds ?? this.subjectIds,
        classIds: classIds ?? this.classIds,
        type: type ?? this.type,
        workDays: workDays ?? this.workDays,
      );
  TeacherDto copyWithCompanion(TeachersTableCompanion data) {
    return TeacherDto(
      id: data.id.present ? data.id.value : this.id,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      qualification: data.qualification.present
          ? data.qualification.value
          : this.qualification,
      specialization: data.specialization.present
          ? data.specialization.value
          : this.specialization,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      maxWeeklyHours: data.maxWeeklyHours.present
          ? data.maxWeeklyHours.value
          : this.maxWeeklyHours,
      maxDailyHours: data.maxDailyHours.present
          ? data.maxDailyHours.value
          : this.maxDailyHours,
      unavailablePeriods: data.unavailablePeriods.present
          ? data.unavailablePeriods.value
          : this.unavailablePeriods,
      subjectIds:
          data.subjectIds.present ? data.subjectIds.value : this.subjectIds,
      classIds: data.classIds.present ? data.classIds.value : this.classIds,
      type: data.type.present ? data.type.value : this.type,
      workDays: data.workDays.present ? data.workDays.value : this.workDays,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TeacherDto(')
          ..write('id: $id, ')
          ..write('fullName: $fullName, ')
          ..write('qualification: $qualification, ')
          ..write('specialization: $specialization, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('maxWeeklyHours: $maxWeeklyHours, ')
          ..write('maxDailyHours: $maxDailyHours, ')
          ..write('unavailablePeriods: $unavailablePeriods, ')
          ..write('subjectIds: $subjectIds, ')
          ..write('classIds: $classIds, ')
          ..write('type: $type, ')
          ..write('workDays: $workDays')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      fullName,
      qualification,
      specialization,
      phone,
      email,
      maxWeeklyHours,
      maxDailyHours,
      unavailablePeriods,
      subjectIds,
      classIds,
      type,
      workDays);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TeacherDto &&
          other.id == this.id &&
          other.fullName == this.fullName &&
          other.qualification == this.qualification &&
          other.specialization == this.specialization &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.maxWeeklyHours == this.maxWeeklyHours &&
          other.maxDailyHours == this.maxDailyHours &&
          other.unavailablePeriods == this.unavailablePeriods &&
          other.subjectIds == this.subjectIds &&
          other.classIds == this.classIds &&
          other.type == this.type &&
          other.workDays == this.workDays);
}

class TeachersTableCompanion extends UpdateCompanion<TeacherDto> {
  final Value<String> id;
  final Value<String> fullName;
  final Value<String?> qualification;
  final Value<String> specialization;
  final Value<String> phone;
  final Value<String?> email;
  final Value<int> maxWeeklyHours;
  final Value<int> maxDailyHours;
  final Value<Map<WorkDay, List<int>>> unavailablePeriods;
  final Value<List<String>> subjectIds;
  final Value<List<String>> classIds;
  final Value<TeacherType> type;
  final Value<List<WorkDay>> workDays;
  final Value<int> rowid;
  const TeachersTableCompanion({
    this.id = const Value.absent(),
    this.fullName = const Value.absent(),
    this.qualification = const Value.absent(),
    this.specialization = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.maxWeeklyHours = const Value.absent(),
    this.maxDailyHours = const Value.absent(),
    this.unavailablePeriods = const Value.absent(),
    this.subjectIds = const Value.absent(),
    this.classIds = const Value.absent(),
    this.type = const Value.absent(),
    this.workDays = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TeachersTableCompanion.insert({
    required String id,
    required String fullName,
    this.qualification = const Value.absent(),
    required String specialization,
    required String phone,
    this.email = const Value.absent(),
    required int maxWeeklyHours,
    required int maxDailyHours,
    required Map<WorkDay, List<int>> unavailablePeriods,
    required List<String> subjectIds,
    required List<String> classIds,
    required TeacherType type,
    this.workDays = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        fullName = Value(fullName),
        specialization = Value(specialization),
        phone = Value(phone),
        maxWeeklyHours = Value(maxWeeklyHours),
        maxDailyHours = Value(maxDailyHours),
        unavailablePeriods = Value(unavailablePeriods),
        subjectIds = Value(subjectIds),
        classIds = Value(classIds),
        type = Value(type);
  static Insertable<TeacherDto> custom({
    Expression<String>? id,
    Expression<String>? fullName,
    Expression<String>? qualification,
    Expression<String>? specialization,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<int>? maxWeeklyHours,
    Expression<int>? maxDailyHours,
    Expression<String>? unavailablePeriods,
    Expression<String>? subjectIds,
    Expression<String>? classIds,
    Expression<int>? type,
    Expression<String>? workDays,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fullName != null) 'full_name': fullName,
      if (qualification != null) 'qualification': qualification,
      if (specialization != null) 'specialization': specialization,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (maxWeeklyHours != null) 'max_weekly_hours': maxWeeklyHours,
      if (maxDailyHours != null) 'max_daily_hours': maxDailyHours,
      if (unavailablePeriods != null) 'unavailable_periods': unavailablePeriods,
      if (subjectIds != null) 'subject_ids': subjectIds,
      if (classIds != null) 'class_ids': classIds,
      if (type != null) 'type': type,
      if (workDays != null) 'work_days': workDays,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TeachersTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? fullName,
      Value<String?>? qualification,
      Value<String>? specialization,
      Value<String>? phone,
      Value<String?>? email,
      Value<int>? maxWeeklyHours,
      Value<int>? maxDailyHours,
      Value<Map<WorkDay, List<int>>>? unavailablePeriods,
      Value<List<String>>? subjectIds,
      Value<List<String>>? classIds,
      Value<TeacherType>? type,
      Value<List<WorkDay>>? workDays,
      Value<int>? rowid}) {
    return TeachersTableCompanion(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      qualification: qualification ?? this.qualification,
      specialization: specialization ?? this.specialization,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      maxWeeklyHours: maxWeeklyHours ?? this.maxWeeklyHours,
      maxDailyHours: maxDailyHours ?? this.maxDailyHours,
      unavailablePeriods: unavailablePeriods ?? this.unavailablePeriods,
      subjectIds: subjectIds ?? this.subjectIds,
      classIds: classIds ?? this.classIds,
      type: type ?? this.type,
      workDays: workDays ?? this.workDays,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (qualification.present) {
      map['qualification'] = Variable<String>(qualification.value);
    }
    if (specialization.present) {
      map['specialization'] = Variable<String>(specialization.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (maxWeeklyHours.present) {
      map['max_weekly_hours'] = Variable<int>(maxWeeklyHours.value);
    }
    if (maxDailyHours.present) {
      map['max_daily_hours'] = Variable<int>(maxDailyHours.value);
    }
    if (unavailablePeriods.present) {
      map['unavailable_periods'] = Variable<String>($TeachersTableTable
          .$converterunavailablePeriods
          .toSql(unavailablePeriods.value));
    }
    if (subjectIds.present) {
      map['subject_ids'] = Variable<String>(
          $TeachersTableTable.$convertersubjectIds.toSql(subjectIds.value));
    }
    if (classIds.present) {
      map['class_ids'] = Variable<String>(
          $TeachersTableTable.$converterclassIds.toSql(classIds.value));
    }
    if (type.present) {
      map['type'] =
          Variable<int>($TeachersTableTable.$convertertype.toSql(type.value));
    }
    if (workDays.present) {
      map['work_days'] = Variable<String>(
          $TeachersTableTable.$converterworkDays.toSql(workDays.value));
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TeachersTableCompanion(')
          ..write('id: $id, ')
          ..write('fullName: $fullName, ')
          ..write('qualification: $qualification, ')
          ..write('specialization: $specialization, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('maxWeeklyHours: $maxWeeklyHours, ')
          ..write('maxDailyHours: $maxDailyHours, ')
          ..write('unavailablePeriods: $unavailablePeriods, ')
          ..write('subjectIds: $subjectIds, ')
          ..write('classIds: $classIds, ')
          ..write('type: $type, ')
          ..write('workDays: $workDays, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SubjectsTableTable extends SubjectsTable
    with TableInfo<$SubjectsTableTable, SubjectDto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubjectsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _priorityMeta =
      const VerificationMeta('priority');
  @override
  late final GeneratedColumnWithTypeConverter<SubjectPriority, int> priority =
      GeneratedColumn<int>('priority', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<SubjectPriority>(
              $SubjectsTableTable.$converterpriority);
  static const VerificationMeta _weeklyHoursMeta =
      const VerificationMeta('weeklyHours');
  @override
  late final GeneratedColumn<int> weeklyHours = GeneratedColumn<int>(
      'weekly_hours', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _classPeriodsMeta =
      const VerificationMeta('classPeriods');
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, int>, String>
      classPeriods = GeneratedColumn<String>(
              'class_periods', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: const Constant('{}'))
          .withConverter<Map<String, int>>(
              $SubjectsTableTable.$converterclassPeriods);
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
      'color', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _requiresLabMeta =
      const VerificationMeta('requiresLab');
  @override
  late final GeneratedColumn<bool> requiresLab = GeneratedColumn<bool>(
      'requires_lab', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("requires_lab" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _requiresProjectorMeta =
      const VerificationMeta('requiresProjector');
  @override
  late final GeneratedColumn<bool> requiresProjector = GeneratedColumn<bool>(
      'requires_projector', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("requires_projector" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _qualifiedTeacherIdsMeta =
      const VerificationMeta('qualifiedTeacherIds');
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String>
      qualifiedTeacherIds = GeneratedColumn<String>(
              'qualified_teacher_ids', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<List<String>>(
              $SubjectsTableTable.$converterqualifiedTeacherIds);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        code,
        priority,
        weeklyHours,
        classPeriods,
        color,
        requiresLab,
        requiresProjector,
        qualifiedTeacherIds
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subjects_table';
  @override
  VerificationContext validateIntegrity(Insertable<SubjectDto> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    }
    context.handle(_priorityMeta, const VerificationResult.success());
    if (data.containsKey('weekly_hours')) {
      context.handle(
          _weeklyHoursMeta,
          weeklyHours.isAcceptableOrUnknown(
              data['weekly_hours']!, _weeklyHoursMeta));
    }
    context.handle(_classPeriodsMeta, const VerificationResult.success());
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('requires_lab')) {
      context.handle(
          _requiresLabMeta,
          requiresLab.isAcceptableOrUnknown(
              data['requires_lab']!, _requiresLabMeta));
    }
    if (data.containsKey('requires_projector')) {
      context.handle(
          _requiresProjectorMeta,
          requiresProjector.isAcceptableOrUnknown(
              data['requires_projector']!, _requiresProjectorMeta));
    }
    context.handle(
        _qualifiedTeacherIdsMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SubjectDto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SubjectDto(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code']),
      priority: $SubjectsTableTable.$converterpriority.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}priority'])!),
      weeklyHours: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}weekly_hours'])!,
      classPeriods: $SubjectsTableTable.$converterclassPeriods.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}class_periods'])!),
      color: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}color'])!,
      requiresLab: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}requires_lab'])!,
      requiresProjector: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}requires_projector'])!,
      qualifiedTeacherIds: $SubjectsTableTable.$converterqualifiedTeacherIds
          .fromSql(attachedDatabase.typeMapping.read(DriftSqlType.string,
              data['${effectivePrefix}qualified_teacher_ids'])!),
    );
  }

  @override
  $SubjectsTableTable createAlias(String alias) {
    return $SubjectsTableTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SubjectPriority, int, int> $converterpriority =
      const EnumIndexConverter<SubjectPriority>(SubjectPriority.values);
  static TypeConverter<Map<String, int>, String> $converterclassPeriods =
      const StringIntMapConverter();
  static TypeConverter<List<String>, String> $converterqualifiedTeacherIds =
      const StringListConverter();
}

class SubjectDto extends DataClass implements Insertable<SubjectDto> {
  final String id;
  final String name;
  final String? code;
  final SubjectPriority priority;
  final int weeklyHours;
  final Map<String, int> classPeriods;
  final int color;
  final bool requiresLab;
  final bool requiresProjector;
  final List<String> qualifiedTeacherIds;
  const SubjectDto(
      {required this.id,
      required this.name,
      this.code,
      required this.priority,
      required this.weeklyHours,
      required this.classPeriods,
      required this.color,
      required this.requiresLab,
      required this.requiresProjector,
      required this.qualifiedTeacherIds});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || code != null) {
      map['code'] = Variable<String>(code);
    }
    {
      map['priority'] =
          Variable<int>($SubjectsTableTable.$converterpriority.toSql(priority));
    }
    map['weekly_hours'] = Variable<int>(weeklyHours);
    {
      map['class_periods'] = Variable<String>(
          $SubjectsTableTable.$converterclassPeriods.toSql(classPeriods));
    }
    map['color'] = Variable<int>(color);
    map['requires_lab'] = Variable<bool>(requiresLab);
    map['requires_projector'] = Variable<bool>(requiresProjector);
    {
      map['qualified_teacher_ids'] = Variable<String>($SubjectsTableTable
          .$converterqualifiedTeacherIds
          .toSql(qualifiedTeacherIds));
    }
    return map;
  }

  SubjectsTableCompanion toCompanion(bool nullToAbsent) {
    return SubjectsTableCompanion(
      id: Value(id),
      name: Value(name),
      code: code == null && nullToAbsent ? const Value.absent() : Value(code),
      priority: Value(priority),
      weeklyHours: Value(weeklyHours),
      classPeriods: Value(classPeriods),
      color: Value(color),
      requiresLab: Value(requiresLab),
      requiresProjector: Value(requiresProjector),
      qualifiedTeacherIds: Value(qualifiedTeacherIds),
    );
  }

  factory SubjectDto.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SubjectDto(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      code: serializer.fromJson<String?>(json['code']),
      priority: $SubjectsTableTable.$converterpriority
          .fromJson(serializer.fromJson<int>(json['priority'])),
      weeklyHours: serializer.fromJson<int>(json['weeklyHours']),
      classPeriods: serializer.fromJson<Map<String, int>>(json['classPeriods']),
      color: serializer.fromJson<int>(json['color']),
      requiresLab: serializer.fromJson<bool>(json['requiresLab']),
      requiresProjector: serializer.fromJson<bool>(json['requiresProjector']),
      qualifiedTeacherIds:
          serializer.fromJson<List<String>>(json['qualifiedTeacherIds']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'code': serializer.toJson<String?>(code),
      'priority': serializer
          .toJson<int>($SubjectsTableTable.$converterpriority.toJson(priority)),
      'weeklyHours': serializer.toJson<int>(weeklyHours),
      'classPeriods': serializer.toJson<Map<String, int>>(classPeriods),
      'color': serializer.toJson<int>(color),
      'requiresLab': serializer.toJson<bool>(requiresLab),
      'requiresProjector': serializer.toJson<bool>(requiresProjector),
      'qualifiedTeacherIds':
          serializer.toJson<List<String>>(qualifiedTeacherIds),
    };
  }

  SubjectDto copyWith(
          {String? id,
          String? name,
          Value<String?> code = const Value.absent(),
          SubjectPriority? priority,
          int? weeklyHours,
          Map<String, int>? classPeriods,
          int? color,
          bool? requiresLab,
          bool? requiresProjector,
          List<String>? qualifiedTeacherIds}) =>
      SubjectDto(
        id: id ?? this.id,
        name: name ?? this.name,
        code: code.present ? code.value : this.code,
        priority: priority ?? this.priority,
        weeklyHours: weeklyHours ?? this.weeklyHours,
        classPeriods: classPeriods ?? this.classPeriods,
        color: color ?? this.color,
        requiresLab: requiresLab ?? this.requiresLab,
        requiresProjector: requiresProjector ?? this.requiresProjector,
        qualifiedTeacherIds: qualifiedTeacherIds ?? this.qualifiedTeacherIds,
      );
  SubjectDto copyWithCompanion(SubjectsTableCompanion data) {
    return SubjectDto(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      code: data.code.present ? data.code.value : this.code,
      priority: data.priority.present ? data.priority.value : this.priority,
      weeklyHours:
          data.weeklyHours.present ? data.weeklyHours.value : this.weeklyHours,
      classPeriods: data.classPeriods.present
          ? data.classPeriods.value
          : this.classPeriods,
      color: data.color.present ? data.color.value : this.color,
      requiresLab:
          data.requiresLab.present ? data.requiresLab.value : this.requiresLab,
      requiresProjector: data.requiresProjector.present
          ? data.requiresProjector.value
          : this.requiresProjector,
      qualifiedTeacherIds: data.qualifiedTeacherIds.present
          ? data.qualifiedTeacherIds.value
          : this.qualifiedTeacherIds,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SubjectDto(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('code: $code, ')
          ..write('priority: $priority, ')
          ..write('weeklyHours: $weeklyHours, ')
          ..write('classPeriods: $classPeriods, ')
          ..write('color: $color, ')
          ..write('requiresLab: $requiresLab, ')
          ..write('requiresProjector: $requiresProjector, ')
          ..write('qualifiedTeacherIds: $qualifiedTeacherIds')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, code, priority, weeklyHours,
      classPeriods, color, requiresLab, requiresProjector, qualifiedTeacherIds);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubjectDto &&
          other.id == this.id &&
          other.name == this.name &&
          other.code == this.code &&
          other.priority == this.priority &&
          other.weeklyHours == this.weeklyHours &&
          other.classPeriods == this.classPeriods &&
          other.color == this.color &&
          other.requiresLab == this.requiresLab &&
          other.requiresProjector == this.requiresProjector &&
          other.qualifiedTeacherIds == this.qualifiedTeacherIds);
}

class SubjectsTableCompanion extends UpdateCompanion<SubjectDto> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> code;
  final Value<SubjectPriority> priority;
  final Value<int> weeklyHours;
  final Value<Map<String, int>> classPeriods;
  final Value<int> color;
  final Value<bool> requiresLab;
  final Value<bool> requiresProjector;
  final Value<List<String>> qualifiedTeacherIds;
  final Value<int> rowid;
  const SubjectsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.code = const Value.absent(),
    this.priority = const Value.absent(),
    this.weeklyHours = const Value.absent(),
    this.classPeriods = const Value.absent(),
    this.color = const Value.absent(),
    this.requiresLab = const Value.absent(),
    this.requiresProjector = const Value.absent(),
    this.qualifiedTeacherIds = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SubjectsTableCompanion.insert({
    required String id,
    required String name,
    this.code = const Value.absent(),
    required SubjectPriority priority,
    this.weeklyHours = const Value.absent(),
    this.classPeriods = const Value.absent(),
    required int color,
    this.requiresLab = const Value.absent(),
    this.requiresProjector = const Value.absent(),
    required List<String> qualifiedTeacherIds,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        priority = Value(priority),
        color = Value(color),
        qualifiedTeacherIds = Value(qualifiedTeacherIds);
  static Insertable<SubjectDto> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? code,
    Expression<int>? priority,
    Expression<int>? weeklyHours,
    Expression<String>? classPeriods,
    Expression<int>? color,
    Expression<bool>? requiresLab,
    Expression<bool>? requiresProjector,
    Expression<String>? qualifiedTeacherIds,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (code != null) 'code': code,
      if (priority != null) 'priority': priority,
      if (weeklyHours != null) 'weekly_hours': weeklyHours,
      if (classPeriods != null) 'class_periods': classPeriods,
      if (color != null) 'color': color,
      if (requiresLab != null) 'requires_lab': requiresLab,
      if (requiresProjector != null) 'requires_projector': requiresProjector,
      if (qualifiedTeacherIds != null)
        'qualified_teacher_ids': qualifiedTeacherIds,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SubjectsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? code,
      Value<SubjectPriority>? priority,
      Value<int>? weeklyHours,
      Value<Map<String, int>>? classPeriods,
      Value<int>? color,
      Value<bool>? requiresLab,
      Value<bool>? requiresProjector,
      Value<List<String>>? qualifiedTeacherIds,
      Value<int>? rowid}) {
    return SubjectsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      priority: priority ?? this.priority,
      weeklyHours: weeklyHours ?? this.weeklyHours,
      classPeriods: classPeriods ?? this.classPeriods,
      color: color ?? this.color,
      requiresLab: requiresLab ?? this.requiresLab,
      requiresProjector: requiresProjector ?? this.requiresProjector,
      qualifiedTeacherIds: qualifiedTeacherIds ?? this.qualifiedTeacherIds,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(
          $SubjectsTableTable.$converterpriority.toSql(priority.value));
    }
    if (weeklyHours.present) {
      map['weekly_hours'] = Variable<int>(weeklyHours.value);
    }
    if (classPeriods.present) {
      map['class_periods'] = Variable<String>(
          $SubjectsTableTable.$converterclassPeriods.toSql(classPeriods.value));
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (requiresLab.present) {
      map['requires_lab'] = Variable<bool>(requiresLab.value);
    }
    if (requiresProjector.present) {
      map['requires_projector'] = Variable<bool>(requiresProjector.value);
    }
    if (qualifiedTeacherIds.present) {
      map['qualified_teacher_ids'] = Variable<String>($SubjectsTableTable
          .$converterqualifiedTeacherIds
          .toSql(qualifiedTeacherIds.value));
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubjectsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('code: $code, ')
          ..write('priority: $priority, ')
          ..write('weeklyHours: $weeklyHours, ')
          ..write('classPeriods: $classPeriods, ')
          ..write('color: $color, ')
          ..write('requiresLab: $requiresLab, ')
          ..write('requiresProjector: $requiresProjector, ')
          ..write('qualifiedTeacherIds: $qualifiedTeacherIds, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ClassroomsTableTable extends ClassroomsTable
    with TableInfo<$ClassroomsTableTable, ClassroomDto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClassroomsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sectionMeta =
      const VerificationMeta('section');
  @override
  late final GeneratedColumn<String> section = GeneratedColumn<String>(
      'section', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _studentCountMeta =
      const VerificationMeta('studentCount');
  @override
  late final GeneratedColumn<int> studentCount = GeneratedColumn<int>(
      'student_count', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _roomNumberMeta =
      const VerificationMeta('roomNumber');
  @override
  late final GeneratedColumn<String> roomNumber = GeneratedColumn<String>(
      'room_number', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumnWithTypeConverter<ClassLevel, int> level =
      GeneratedColumn<int>('level', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<ClassLevel>($ClassroomsTableTable.$converterlevel);
  static const VerificationMeta _supervisorIdMeta =
      const VerificationMeta('supervisorId');
  @override
  late final GeneratedColumn<String> supervisorId = GeneratedColumn<String>(
      'supervisor_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _subjectIdsMeta =
      const VerificationMeta('subjectIds');
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> subjectIds =
      GeneratedColumn<String>('subject_ids', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: const Constant('[]'))
          .withConverter<List<String>>(
              $ClassroomsTableTable.$convertersubjectIds);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        section,
        studentCount,
        roomNumber,
        level,
        supervisorId,
        subjectIds
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'classrooms_table';
  @override
  VerificationContext validateIntegrity(Insertable<ClassroomDto> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('section')) {
      context.handle(_sectionMeta,
          section.isAcceptableOrUnknown(data['section']!, _sectionMeta));
    } else if (isInserting) {
      context.missing(_sectionMeta);
    }
    if (data.containsKey('student_count')) {
      context.handle(
          _studentCountMeta,
          studentCount.isAcceptableOrUnknown(
              data['student_count']!, _studentCountMeta));
    } else if (isInserting) {
      context.missing(_studentCountMeta);
    }
    if (data.containsKey('room_number')) {
      context.handle(
          _roomNumberMeta,
          roomNumber.isAcceptableOrUnknown(
              data['room_number']!, _roomNumberMeta));
    } else if (isInserting) {
      context.missing(_roomNumberMeta);
    }
    context.handle(_levelMeta, const VerificationResult.success());
    if (data.containsKey('supervisor_id')) {
      context.handle(
          _supervisorIdMeta,
          supervisorId.isAcceptableOrUnknown(
              data['supervisor_id']!, _supervisorIdMeta));
    }
    context.handle(_subjectIdsMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ClassroomDto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ClassroomDto(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      section: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}section'])!,
      studentCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}student_count'])!,
      roomNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}room_number'])!,
      level: $ClassroomsTableTable.$converterlevel.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}level'])!),
      supervisorId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}supervisor_id']),
      subjectIds: $ClassroomsTableTable.$convertersubjectIds.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}subject_ids'])!),
    );
  }

  @override
  $ClassroomsTableTable createAlias(String alias) {
    return $ClassroomsTableTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ClassLevel, int, int> $converterlevel =
      const EnumIndexConverter<ClassLevel>(ClassLevel.values);
  static TypeConverter<List<String>, String> $convertersubjectIds =
      const StringListConverter();
}

class ClassroomDto extends DataClass implements Insertable<ClassroomDto> {
  final String id;
  final String name;
  final String section;
  final int studentCount;
  final String roomNumber;
  final ClassLevel level;
  final String? supervisorId;
  final List<String> subjectIds;
  const ClassroomDto(
      {required this.id,
      required this.name,
      required this.section,
      required this.studentCount,
      required this.roomNumber,
      required this.level,
      this.supervisorId,
      required this.subjectIds});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['section'] = Variable<String>(section);
    map['student_count'] = Variable<int>(studentCount);
    map['room_number'] = Variable<String>(roomNumber);
    {
      map['level'] =
          Variable<int>($ClassroomsTableTable.$converterlevel.toSql(level));
    }
    if (!nullToAbsent || supervisorId != null) {
      map['supervisor_id'] = Variable<String>(supervisorId);
    }
    {
      map['subject_ids'] = Variable<String>(
          $ClassroomsTableTable.$convertersubjectIds.toSql(subjectIds));
    }
    return map;
  }

  ClassroomsTableCompanion toCompanion(bool nullToAbsent) {
    return ClassroomsTableCompanion(
      id: Value(id),
      name: Value(name),
      section: Value(section),
      studentCount: Value(studentCount),
      roomNumber: Value(roomNumber),
      level: Value(level),
      supervisorId: supervisorId == null && nullToAbsent
          ? const Value.absent()
          : Value(supervisorId),
      subjectIds: Value(subjectIds),
    );
  }

  factory ClassroomDto.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ClassroomDto(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      section: serializer.fromJson<String>(json['section']),
      studentCount: serializer.fromJson<int>(json['studentCount']),
      roomNumber: serializer.fromJson<String>(json['roomNumber']),
      level: $ClassroomsTableTable.$converterlevel
          .fromJson(serializer.fromJson<int>(json['level'])),
      supervisorId: serializer.fromJson<String?>(json['supervisorId']),
      subjectIds: serializer.fromJson<List<String>>(json['subjectIds']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'section': serializer.toJson<String>(section),
      'studentCount': serializer.toJson<int>(studentCount),
      'roomNumber': serializer.toJson<String>(roomNumber),
      'level': serializer
          .toJson<int>($ClassroomsTableTable.$converterlevel.toJson(level)),
      'supervisorId': serializer.toJson<String?>(supervisorId),
      'subjectIds': serializer.toJson<List<String>>(subjectIds),
    };
  }

  ClassroomDto copyWith(
          {String? id,
          String? name,
          String? section,
          int? studentCount,
          String? roomNumber,
          ClassLevel? level,
          Value<String?> supervisorId = const Value.absent(),
          List<String>? subjectIds}) =>
      ClassroomDto(
        id: id ?? this.id,
        name: name ?? this.name,
        section: section ?? this.section,
        studentCount: studentCount ?? this.studentCount,
        roomNumber: roomNumber ?? this.roomNumber,
        level: level ?? this.level,
        supervisorId:
            supervisorId.present ? supervisorId.value : this.supervisorId,
        subjectIds: subjectIds ?? this.subjectIds,
      );
  ClassroomDto copyWithCompanion(ClassroomsTableCompanion data) {
    return ClassroomDto(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      section: data.section.present ? data.section.value : this.section,
      studentCount: data.studentCount.present
          ? data.studentCount.value
          : this.studentCount,
      roomNumber:
          data.roomNumber.present ? data.roomNumber.value : this.roomNumber,
      level: data.level.present ? data.level.value : this.level,
      supervisorId: data.supervisorId.present
          ? data.supervisorId.value
          : this.supervisorId,
      subjectIds:
          data.subjectIds.present ? data.subjectIds.value : this.subjectIds,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ClassroomDto(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('section: $section, ')
          ..write('studentCount: $studentCount, ')
          ..write('roomNumber: $roomNumber, ')
          ..write('level: $level, ')
          ..write('supervisorId: $supervisorId, ')
          ..write('subjectIds: $subjectIds')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, section, studentCount, roomNumber,
      level, supervisorId, subjectIds);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClassroomDto &&
          other.id == this.id &&
          other.name == this.name &&
          other.section == this.section &&
          other.studentCount == this.studentCount &&
          other.roomNumber == this.roomNumber &&
          other.level == this.level &&
          other.supervisorId == this.supervisorId &&
          other.subjectIds == this.subjectIds);
}

class ClassroomsTableCompanion extends UpdateCompanion<ClassroomDto> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> section;
  final Value<int> studentCount;
  final Value<String> roomNumber;
  final Value<ClassLevel> level;
  final Value<String?> supervisorId;
  final Value<List<String>> subjectIds;
  final Value<int> rowid;
  const ClassroomsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.section = const Value.absent(),
    this.studentCount = const Value.absent(),
    this.roomNumber = const Value.absent(),
    this.level = const Value.absent(),
    this.supervisorId = const Value.absent(),
    this.subjectIds = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ClassroomsTableCompanion.insert({
    required String id,
    required String name,
    required String section,
    required int studentCount,
    required String roomNumber,
    required ClassLevel level,
    this.supervisorId = const Value.absent(),
    this.subjectIds = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        section = Value(section),
        studentCount = Value(studentCount),
        roomNumber = Value(roomNumber),
        level = Value(level);
  static Insertable<ClassroomDto> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? section,
    Expression<int>? studentCount,
    Expression<String>? roomNumber,
    Expression<int>? level,
    Expression<String>? supervisorId,
    Expression<String>? subjectIds,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (section != null) 'section': section,
      if (studentCount != null) 'student_count': studentCount,
      if (roomNumber != null) 'room_number': roomNumber,
      if (level != null) 'level': level,
      if (supervisorId != null) 'supervisor_id': supervisorId,
      if (subjectIds != null) 'subject_ids': subjectIds,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ClassroomsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? section,
      Value<int>? studentCount,
      Value<String>? roomNumber,
      Value<ClassLevel>? level,
      Value<String?>? supervisorId,
      Value<List<String>>? subjectIds,
      Value<int>? rowid}) {
    return ClassroomsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      section: section ?? this.section,
      studentCount: studentCount ?? this.studentCount,
      roomNumber: roomNumber ?? this.roomNumber,
      level: level ?? this.level,
      supervisorId: supervisorId ?? this.supervisorId,
      subjectIds: subjectIds ?? this.subjectIds,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (section.present) {
      map['section'] = Variable<String>(section.value);
    }
    if (studentCount.present) {
      map['student_count'] = Variable<int>(studentCount.value);
    }
    if (roomNumber.present) {
      map['room_number'] = Variable<String>(roomNumber.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(
          $ClassroomsTableTable.$converterlevel.toSql(level.value));
    }
    if (supervisorId.present) {
      map['supervisor_id'] = Variable<String>(supervisorId.value);
    }
    if (subjectIds.present) {
      map['subject_ids'] = Variable<String>(
          $ClassroomsTableTable.$convertersubjectIds.toSql(subjectIds.value));
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClassroomsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('section: $section, ')
          ..write('studentCount: $studentCount, ')
          ..write('roomNumber: $roomNumber, ')
          ..write('level: $level, ')
          ..write('supervisorId: $supervisorId, ')
          ..write('subjectIds: $subjectIds, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SchedulesTableTable extends SchedulesTable
    with TableInfo<$SchedulesTableTable, ScheduleDto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SchedulesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _creationDateMeta =
      const VerificationMeta('creationDate');
  @override
  late final GeneratedColumn<DateTime> creationDate = GeneratedColumn<DateTime>(
      'creation_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _endDateMeta =
      const VerificationMeta('endDate');
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
      'end_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _schoolIdMeta =
      const VerificationMeta('schoolId');
  @override
  late final GeneratedColumn<String> schoolId = GeneratedColumn<String>(
      'school_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES schools_table (id)'));
  static const VerificationMeta _creatorIdMeta =
      const VerificationMeta('creatorId');
  @override
  late final GeneratedColumn<String> creatorId = GeneratedColumn<String>(
      'creator_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumnWithTypeConverter<ScheduleStatus, int> status =
      GeneratedColumn<int>('status', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<ScheduleStatus>($SchedulesTableTable.$converterstatus);
  static const VerificationMeta _metadataMeta =
      const VerificationMeta('metadata');
  @override
  late final GeneratedColumn<String> metadata = GeneratedColumn<String>(
      'metadata', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        creationDate,
        startDate,
        endDate,
        schoolId,
        creatorId,
        status,
        metadata
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'schedules_table';
  @override
  VerificationContext validateIntegrity(Insertable<ScheduleDto> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('creation_date')) {
      context.handle(
          _creationDateMeta,
          creationDate.isAcceptableOrUnknown(
              data['creation_date']!, _creationDateMeta));
    } else if (isInserting) {
      context.missing(_creationDateMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(_endDateMeta,
          endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta));
    } else if (isInserting) {
      context.missing(_endDateMeta);
    }
    if (data.containsKey('school_id')) {
      context.handle(_schoolIdMeta,
          schoolId.isAcceptableOrUnknown(data['school_id']!, _schoolIdMeta));
    } else if (isInserting) {
      context.missing(_schoolIdMeta);
    }
    if (data.containsKey('creator_id')) {
      context.handle(_creatorIdMeta,
          creatorId.isAcceptableOrUnknown(data['creator_id']!, _creatorIdMeta));
    } else if (isInserting) {
      context.missing(_creatorIdMeta);
    }
    context.handle(_statusMeta, const VerificationResult.success());
    if (data.containsKey('metadata')) {
      context.handle(_metadataMeta,
          metadata.isAcceptableOrUnknown(data['metadata']!, _metadataMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ScheduleDto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScheduleDto(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      creationDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}creation_date'])!,
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date'])!,
      endDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_date'])!,
      schoolId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}school_id'])!,
      creatorId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}creator_id'])!,
      status: $SchedulesTableTable.$converterstatus.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}status'])!),
      metadata: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}metadata']),
    );
  }

  @override
  $SchedulesTableTable createAlias(String alias) {
    return $SchedulesTableTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ScheduleStatus, int, int> $converterstatus =
      const EnumIndexConverter<ScheduleStatus>(ScheduleStatus.values);
}

class ScheduleDto extends DataClass implements Insertable<ScheduleDto> {
  final String id;
  final String name;
  final DateTime creationDate;
  final DateTime startDate;
  final DateTime endDate;
  final String schoolId;
  final String creatorId;
  final ScheduleStatus status;
  final String? metadata;
  const ScheduleDto(
      {required this.id,
      required this.name,
      required this.creationDate,
      required this.startDate,
      required this.endDate,
      required this.schoolId,
      required this.creatorId,
      required this.status,
      this.metadata});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['creation_date'] = Variable<DateTime>(creationDate);
    map['start_date'] = Variable<DateTime>(startDate);
    map['end_date'] = Variable<DateTime>(endDate);
    map['school_id'] = Variable<String>(schoolId);
    map['creator_id'] = Variable<String>(creatorId);
    {
      map['status'] =
          Variable<int>($SchedulesTableTable.$converterstatus.toSql(status));
    }
    if (!nullToAbsent || metadata != null) {
      map['metadata'] = Variable<String>(metadata);
    }
    return map;
  }

  SchedulesTableCompanion toCompanion(bool nullToAbsent) {
    return SchedulesTableCompanion(
      id: Value(id),
      name: Value(name),
      creationDate: Value(creationDate),
      startDate: Value(startDate),
      endDate: Value(endDate),
      schoolId: Value(schoolId),
      creatorId: Value(creatorId),
      status: Value(status),
      metadata: metadata == null && nullToAbsent
          ? const Value.absent()
          : Value(metadata),
    );
  }

  factory ScheduleDto.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScheduleDto(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      creationDate: serializer.fromJson<DateTime>(json['creationDate']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
      schoolId: serializer.fromJson<String>(json['schoolId']),
      creatorId: serializer.fromJson<String>(json['creatorId']),
      status: $SchedulesTableTable.$converterstatus
          .fromJson(serializer.fromJson<int>(json['status'])),
      metadata: serializer.fromJson<String?>(json['metadata']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'creationDate': serializer.toJson<DateTime>(creationDate),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime>(endDate),
      'schoolId': serializer.toJson<String>(schoolId),
      'creatorId': serializer.toJson<String>(creatorId),
      'status': serializer
          .toJson<int>($SchedulesTableTable.$converterstatus.toJson(status)),
      'metadata': serializer.toJson<String?>(metadata),
    };
  }

  ScheduleDto copyWith(
          {String? id,
          String? name,
          DateTime? creationDate,
          DateTime? startDate,
          DateTime? endDate,
          String? schoolId,
          String? creatorId,
          ScheduleStatus? status,
          Value<String?> metadata = const Value.absent()}) =>
      ScheduleDto(
        id: id ?? this.id,
        name: name ?? this.name,
        creationDate: creationDate ?? this.creationDate,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        schoolId: schoolId ?? this.schoolId,
        creatorId: creatorId ?? this.creatorId,
        status: status ?? this.status,
        metadata: metadata.present ? metadata.value : this.metadata,
      );
  ScheduleDto copyWithCompanion(SchedulesTableCompanion data) {
    return ScheduleDto(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      creationDate: data.creationDate.present
          ? data.creationDate.value
          : this.creationDate,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      schoolId: data.schoolId.present ? data.schoolId.value : this.schoolId,
      creatorId: data.creatorId.present ? data.creatorId.value : this.creatorId,
      status: data.status.present ? data.status.value : this.status,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScheduleDto(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('creationDate: $creationDate, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('schoolId: $schoolId, ')
          ..write('creatorId: $creatorId, ')
          ..write('status: $status, ')
          ..write('metadata: $metadata')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, creationDate, startDate, endDate,
      schoolId, creatorId, status, metadata);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScheduleDto &&
          other.id == this.id &&
          other.name == this.name &&
          other.creationDate == this.creationDate &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.schoolId == this.schoolId &&
          other.creatorId == this.creatorId &&
          other.status == this.status &&
          other.metadata == this.metadata);
}

class SchedulesTableCompanion extends UpdateCompanion<ScheduleDto> {
  final Value<String> id;
  final Value<String> name;
  final Value<DateTime> creationDate;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  final Value<String> schoolId;
  final Value<String> creatorId;
  final Value<ScheduleStatus> status;
  final Value<String?> metadata;
  final Value<int> rowid;
  const SchedulesTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.creationDate = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.schoolId = const Value.absent(),
    this.creatorId = const Value.absent(),
    this.status = const Value.absent(),
    this.metadata = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SchedulesTableCompanion.insert({
    required String id,
    required String name,
    required DateTime creationDate,
    required DateTime startDate,
    required DateTime endDate,
    required String schoolId,
    required String creatorId,
    required ScheduleStatus status,
    this.metadata = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        creationDate = Value(creationDate),
        startDate = Value(startDate),
        endDate = Value(endDate),
        schoolId = Value(schoolId),
        creatorId = Value(creatorId),
        status = Value(status);
  static Insertable<ScheduleDto> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<DateTime>? creationDate,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<String>? schoolId,
    Expression<String>? creatorId,
    Expression<int>? status,
    Expression<String>? metadata,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (creationDate != null) 'creation_date': creationDate,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (schoolId != null) 'school_id': schoolId,
      if (creatorId != null) 'creator_id': creatorId,
      if (status != null) 'status': status,
      if (metadata != null) 'metadata': metadata,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SchedulesTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<DateTime>? creationDate,
      Value<DateTime>? startDate,
      Value<DateTime>? endDate,
      Value<String>? schoolId,
      Value<String>? creatorId,
      Value<ScheduleStatus>? status,
      Value<String?>? metadata,
      Value<int>? rowid}) {
    return SchedulesTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      creationDate: creationDate ?? this.creationDate,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      schoolId: schoolId ?? this.schoolId,
      creatorId: creatorId ?? this.creatorId,
      status: status ?? this.status,
      metadata: metadata ?? this.metadata,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (creationDate.present) {
      map['creation_date'] = Variable<DateTime>(creationDate.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (schoolId.present) {
      map['school_id'] = Variable<String>(schoolId.value);
    }
    if (creatorId.present) {
      map['creator_id'] = Variable<String>(creatorId.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(
          $SchedulesTableTable.$converterstatus.toSql(status.value));
    }
    if (metadata.present) {
      map['metadata'] = Variable<String>(metadata.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SchedulesTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('creationDate: $creationDate, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('schoolId: $schoolId, ')
          ..write('creatorId: $creatorId, ')
          ..write('status: $status, ')
          ..write('metadata: $metadata, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SessionsTableTable extends SessionsTable
    with TableInfo<$SessionsTableTable, SessionDto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumnWithTypeConverter<WorkDay, int> day =
      GeneratedColumn<int>('day', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<WorkDay>($SessionsTableTable.$converterday);
  static const VerificationMeta _sessionNumberMeta =
      const VerificationMeta('sessionNumber');
  @override
  late final GeneratedColumn<int> sessionNumber = GeneratedColumn<int>(
      'session_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _classIdMeta =
      const VerificationMeta('classId');
  @override
  late final GeneratedColumn<String> classId = GeneratedColumn<String>(
      'class_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES classrooms_table (id)'));
  static const VerificationMeta _teacherIdMeta =
      const VerificationMeta('teacherId');
  @override
  late final GeneratedColumn<String> teacherId = GeneratedColumn<String>(
      'teacher_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES teachers_table (id)'));
  static const VerificationMeta _subjectIdMeta =
      const VerificationMeta('subjectId');
  @override
  late final GeneratedColumn<String> subjectId = GeneratedColumn<String>(
      'subject_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES subjects_table (id)'));
  static const VerificationMeta _roomIdMeta = const VerificationMeta('roomId');
  @override
  late final GeneratedColumn<String> roomId = GeneratedColumn<String>(
      'room_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumnWithTypeConverter<SessionStatus, int> status =
      GeneratedColumn<int>('status', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<SessionStatus>($SessionsTableTable.$converterstatus);
  static const VerificationMeta _actualDateMeta =
      const VerificationMeta('actualDate');
  @override
  late final GeneratedColumn<DateTime> actualDate = GeneratedColumn<DateTime>(
      'actual_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _scheduleIdMeta =
      const VerificationMeta('scheduleId');
  @override
  late final GeneratedColumn<String> scheduleId = GeneratedColumn<String>(
      'schedule_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES schedules_table (id)'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        day,
        sessionNumber,
        classId,
        teacherId,
        subjectId,
        roomId,
        status,
        actualDate,
        notes,
        scheduleId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sessions_table';
  @override
  VerificationContext validateIntegrity(Insertable<SessionDto> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    context.handle(_dayMeta, const VerificationResult.success());
    if (data.containsKey('session_number')) {
      context.handle(
          _sessionNumberMeta,
          sessionNumber.isAcceptableOrUnknown(
              data['session_number']!, _sessionNumberMeta));
    } else if (isInserting) {
      context.missing(_sessionNumberMeta);
    }
    if (data.containsKey('class_id')) {
      context.handle(_classIdMeta,
          classId.isAcceptableOrUnknown(data['class_id']!, _classIdMeta));
    } else if (isInserting) {
      context.missing(_classIdMeta);
    }
    if (data.containsKey('teacher_id')) {
      context.handle(_teacherIdMeta,
          teacherId.isAcceptableOrUnknown(data['teacher_id']!, _teacherIdMeta));
    } else if (isInserting) {
      context.missing(_teacherIdMeta);
    }
    if (data.containsKey('subject_id')) {
      context.handle(_subjectIdMeta,
          subjectId.isAcceptableOrUnknown(data['subject_id']!, _subjectIdMeta));
    } else if (isInserting) {
      context.missing(_subjectIdMeta);
    }
    if (data.containsKey('room_id')) {
      context.handle(_roomIdMeta,
          roomId.isAcceptableOrUnknown(data['room_id']!, _roomIdMeta));
    } else if (isInserting) {
      context.missing(_roomIdMeta);
    }
    context.handle(_statusMeta, const VerificationResult.success());
    if (data.containsKey('actual_date')) {
      context.handle(
          _actualDateMeta,
          actualDate.isAcceptableOrUnknown(
              data['actual_date']!, _actualDateMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('schedule_id')) {
      context.handle(
          _scheduleIdMeta,
          scheduleId.isAcceptableOrUnknown(
              data['schedule_id']!, _scheduleIdMeta));
    } else if (isInserting) {
      context.missing(_scheduleIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {scheduleId, teacherId, day, sessionNumber},
        {scheduleId, classId, day, sessionNumber},
      ];
  @override
  SessionDto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessionDto(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      day: $SessionsTableTable.$converterday.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}day'])!),
      sessionNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}session_number'])!,
      classId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}class_id'])!,
      teacherId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}teacher_id'])!,
      subjectId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}subject_id'])!,
      roomId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}room_id'])!,
      status: $SessionsTableTable.$converterstatus.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}status'])!),
      actualDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}actual_date']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      scheduleId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}schedule_id'])!,
    );
  }

  @override
  $SessionsTableTable createAlias(String alias) {
    return $SessionsTableTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<WorkDay, int, int> $converterday =
      const EnumIndexConverter<WorkDay>(WorkDay.values);
  static JsonTypeConverter2<SessionStatus, int, int> $converterstatus =
      const EnumIndexConverter<SessionStatus>(SessionStatus.values);
}

class SessionDto extends DataClass implements Insertable<SessionDto> {
  final String id;
  final WorkDay day;
  final int sessionNumber;
  final String classId;
  final String teacherId;
  final String subjectId;
  final String roomId;
  final SessionStatus status;
  final DateTime? actualDate;
  final String? notes;
  final String scheduleId;
  const SessionDto(
      {required this.id,
      required this.day,
      required this.sessionNumber,
      required this.classId,
      required this.teacherId,
      required this.subjectId,
      required this.roomId,
      required this.status,
      this.actualDate,
      this.notes,
      required this.scheduleId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    {
      map['day'] = Variable<int>($SessionsTableTable.$converterday.toSql(day));
    }
    map['session_number'] = Variable<int>(sessionNumber);
    map['class_id'] = Variable<String>(classId);
    map['teacher_id'] = Variable<String>(teacherId);
    map['subject_id'] = Variable<String>(subjectId);
    map['room_id'] = Variable<String>(roomId);
    {
      map['status'] =
          Variable<int>($SessionsTableTable.$converterstatus.toSql(status));
    }
    if (!nullToAbsent || actualDate != null) {
      map['actual_date'] = Variable<DateTime>(actualDate);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['schedule_id'] = Variable<String>(scheduleId);
    return map;
  }

  SessionsTableCompanion toCompanion(bool nullToAbsent) {
    return SessionsTableCompanion(
      id: Value(id),
      day: Value(day),
      sessionNumber: Value(sessionNumber),
      classId: Value(classId),
      teacherId: Value(teacherId),
      subjectId: Value(subjectId),
      roomId: Value(roomId),
      status: Value(status),
      actualDate: actualDate == null && nullToAbsent
          ? const Value.absent()
          : Value(actualDate),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      scheduleId: Value(scheduleId),
    );
  }

  factory SessionDto.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessionDto(
      id: serializer.fromJson<String>(json['id']),
      day: $SessionsTableTable.$converterday
          .fromJson(serializer.fromJson<int>(json['day'])),
      sessionNumber: serializer.fromJson<int>(json['sessionNumber']),
      classId: serializer.fromJson<String>(json['classId']),
      teacherId: serializer.fromJson<String>(json['teacherId']),
      subjectId: serializer.fromJson<String>(json['subjectId']),
      roomId: serializer.fromJson<String>(json['roomId']),
      status: $SessionsTableTable.$converterstatus
          .fromJson(serializer.fromJson<int>(json['status'])),
      actualDate: serializer.fromJson<DateTime?>(json['actualDate']),
      notes: serializer.fromJson<String?>(json['notes']),
      scheduleId: serializer.fromJson<String>(json['scheduleId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'day':
          serializer.toJson<int>($SessionsTableTable.$converterday.toJson(day)),
      'sessionNumber': serializer.toJson<int>(sessionNumber),
      'classId': serializer.toJson<String>(classId),
      'teacherId': serializer.toJson<String>(teacherId),
      'subjectId': serializer.toJson<String>(subjectId),
      'roomId': serializer.toJson<String>(roomId),
      'status': serializer
          .toJson<int>($SessionsTableTable.$converterstatus.toJson(status)),
      'actualDate': serializer.toJson<DateTime?>(actualDate),
      'notes': serializer.toJson<String?>(notes),
      'scheduleId': serializer.toJson<String>(scheduleId),
    };
  }

  SessionDto copyWith(
          {String? id,
          WorkDay? day,
          int? sessionNumber,
          String? classId,
          String? teacherId,
          String? subjectId,
          String? roomId,
          SessionStatus? status,
          Value<DateTime?> actualDate = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          String? scheduleId}) =>
      SessionDto(
        id: id ?? this.id,
        day: day ?? this.day,
        sessionNumber: sessionNumber ?? this.sessionNumber,
        classId: classId ?? this.classId,
        teacherId: teacherId ?? this.teacherId,
        subjectId: subjectId ?? this.subjectId,
        roomId: roomId ?? this.roomId,
        status: status ?? this.status,
        actualDate: actualDate.present ? actualDate.value : this.actualDate,
        notes: notes.present ? notes.value : this.notes,
        scheduleId: scheduleId ?? this.scheduleId,
      );
  SessionDto copyWithCompanion(SessionsTableCompanion data) {
    return SessionDto(
      id: data.id.present ? data.id.value : this.id,
      day: data.day.present ? data.day.value : this.day,
      sessionNumber: data.sessionNumber.present
          ? data.sessionNumber.value
          : this.sessionNumber,
      classId: data.classId.present ? data.classId.value : this.classId,
      teacherId: data.teacherId.present ? data.teacherId.value : this.teacherId,
      subjectId: data.subjectId.present ? data.subjectId.value : this.subjectId,
      roomId: data.roomId.present ? data.roomId.value : this.roomId,
      status: data.status.present ? data.status.value : this.status,
      actualDate:
          data.actualDate.present ? data.actualDate.value : this.actualDate,
      notes: data.notes.present ? data.notes.value : this.notes,
      scheduleId:
          data.scheduleId.present ? data.scheduleId.value : this.scheduleId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessionDto(')
          ..write('id: $id, ')
          ..write('day: $day, ')
          ..write('sessionNumber: $sessionNumber, ')
          ..write('classId: $classId, ')
          ..write('teacherId: $teacherId, ')
          ..write('subjectId: $subjectId, ')
          ..write('roomId: $roomId, ')
          ..write('status: $status, ')
          ..write('actualDate: $actualDate, ')
          ..write('notes: $notes, ')
          ..write('scheduleId: $scheduleId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, day, sessionNumber, classId, teacherId,
      subjectId, roomId, status, actualDate, notes, scheduleId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessionDto &&
          other.id == this.id &&
          other.day == this.day &&
          other.sessionNumber == this.sessionNumber &&
          other.classId == this.classId &&
          other.teacherId == this.teacherId &&
          other.subjectId == this.subjectId &&
          other.roomId == this.roomId &&
          other.status == this.status &&
          other.actualDate == this.actualDate &&
          other.notes == this.notes &&
          other.scheduleId == this.scheduleId);
}

class SessionsTableCompanion extends UpdateCompanion<SessionDto> {
  final Value<String> id;
  final Value<WorkDay> day;
  final Value<int> sessionNumber;
  final Value<String> classId;
  final Value<String> teacherId;
  final Value<String> subjectId;
  final Value<String> roomId;
  final Value<SessionStatus> status;
  final Value<DateTime?> actualDate;
  final Value<String?> notes;
  final Value<String> scheduleId;
  final Value<int> rowid;
  const SessionsTableCompanion({
    this.id = const Value.absent(),
    this.day = const Value.absent(),
    this.sessionNumber = const Value.absent(),
    this.classId = const Value.absent(),
    this.teacherId = const Value.absent(),
    this.subjectId = const Value.absent(),
    this.roomId = const Value.absent(),
    this.status = const Value.absent(),
    this.actualDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.scheduleId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SessionsTableCompanion.insert({
    required String id,
    required WorkDay day,
    required int sessionNumber,
    required String classId,
    required String teacherId,
    required String subjectId,
    required String roomId,
    required SessionStatus status,
    this.actualDate = const Value.absent(),
    this.notes = const Value.absent(),
    required String scheduleId,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        day = Value(day),
        sessionNumber = Value(sessionNumber),
        classId = Value(classId),
        teacherId = Value(teacherId),
        subjectId = Value(subjectId),
        roomId = Value(roomId),
        status = Value(status),
        scheduleId = Value(scheduleId);
  static Insertable<SessionDto> custom({
    Expression<String>? id,
    Expression<int>? day,
    Expression<int>? sessionNumber,
    Expression<String>? classId,
    Expression<String>? teacherId,
    Expression<String>? subjectId,
    Expression<String>? roomId,
    Expression<int>? status,
    Expression<DateTime>? actualDate,
    Expression<String>? notes,
    Expression<String>? scheduleId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (day != null) 'day': day,
      if (sessionNumber != null) 'session_number': sessionNumber,
      if (classId != null) 'class_id': classId,
      if (teacherId != null) 'teacher_id': teacherId,
      if (subjectId != null) 'subject_id': subjectId,
      if (roomId != null) 'room_id': roomId,
      if (status != null) 'status': status,
      if (actualDate != null) 'actual_date': actualDate,
      if (notes != null) 'notes': notes,
      if (scheduleId != null) 'schedule_id': scheduleId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SessionsTableCompanion copyWith(
      {Value<String>? id,
      Value<WorkDay>? day,
      Value<int>? sessionNumber,
      Value<String>? classId,
      Value<String>? teacherId,
      Value<String>? subjectId,
      Value<String>? roomId,
      Value<SessionStatus>? status,
      Value<DateTime?>? actualDate,
      Value<String?>? notes,
      Value<String>? scheduleId,
      Value<int>? rowid}) {
    return SessionsTableCompanion(
      id: id ?? this.id,
      day: day ?? this.day,
      sessionNumber: sessionNumber ?? this.sessionNumber,
      classId: classId ?? this.classId,
      teacherId: teacherId ?? this.teacherId,
      subjectId: subjectId ?? this.subjectId,
      roomId: roomId ?? this.roomId,
      status: status ?? this.status,
      actualDate: actualDate ?? this.actualDate,
      notes: notes ?? this.notes,
      scheduleId: scheduleId ?? this.scheduleId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (day.present) {
      map['day'] =
          Variable<int>($SessionsTableTable.$converterday.toSql(day.value));
    }
    if (sessionNumber.present) {
      map['session_number'] = Variable<int>(sessionNumber.value);
    }
    if (classId.present) {
      map['class_id'] = Variable<String>(classId.value);
    }
    if (teacherId.present) {
      map['teacher_id'] = Variable<String>(teacherId.value);
    }
    if (subjectId.present) {
      map['subject_id'] = Variable<String>(subjectId.value);
    }
    if (roomId.present) {
      map['room_id'] = Variable<String>(roomId.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(
          $SessionsTableTable.$converterstatus.toSql(status.value));
    }
    if (actualDate.present) {
      map['actual_date'] = Variable<DateTime>(actualDate.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (scheduleId.present) {
      map['schedule_id'] = Variable<String>(scheduleId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionsTableCompanion(')
          ..write('id: $id, ')
          ..write('day: $day, ')
          ..write('sessionNumber: $sessionNumber, ')
          ..write('classId: $classId, ')
          ..write('teacherId: $teacherId, ')
          ..write('subjectId: $subjectId, ')
          ..write('roomId: $roomId, ')
          ..write('status: $status, ')
          ..write('actualDate: $actualDate, ')
          ..write('notes: $notes, ')
          ..write('scheduleId: $scheduleId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SchoolsTableTable schoolsTable = $SchoolsTableTable(this);
  late final $TeachersTableTable teachersTable = $TeachersTableTable(this);
  late final $SubjectsTableTable subjectsTable = $SubjectsTableTable(this);
  late final $ClassroomsTableTable classroomsTable =
      $ClassroomsTableTable(this);
  late final $SchedulesTableTable schedulesTable = $SchedulesTableTable(this);
  late final $SessionsTableTable sessionsTable = $SessionsTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        schoolsTable,
        teachersTable,
        subjectsTable,
        classroomsTable,
        schedulesTable,
        sessionsTable
      ];
}

typedef $$SchoolsTableTableCreateCompanionBuilder = SchoolsTableCompanion
    Function({
  required String id,
  required String name,
  required String address,
  required String phone,
  required String email,
  required int dailySessions,
  required List<WorkDay> workDays,
  required int firstSessionTime,
  required int sessionDuration,
  required String academicYear,
  Value<int> rowid,
});
typedef $$SchoolsTableTableUpdateCompanionBuilder = SchoolsTableCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<String> address,
  Value<String> phone,
  Value<String> email,
  Value<int> dailySessions,
  Value<List<WorkDay>> workDays,
  Value<int> firstSessionTime,
  Value<int> sessionDuration,
  Value<String> academicYear,
  Value<int> rowid,
});

final class $$SchoolsTableTableReferences
    extends BaseReferences<_$AppDatabase, $SchoolsTableTable, SchoolDto> {
  $$SchoolsTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SchedulesTableTable, List<ScheduleDto>>
      _schedulesTableRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.schedulesTable,
              aliasName: $_aliasNameGenerator(
                  db.schoolsTable.id, db.schedulesTable.schoolId));

  $$SchedulesTableTableProcessedTableManager get schedulesTableRefs {
    final manager = $$SchedulesTableTableTableManager($_db, $_db.schedulesTable)
        .filter((f) => f.schoolId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_schedulesTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$SchoolsTableTableFilterComposer
    extends Composer<_$AppDatabase, $SchoolsTableTable> {
  $$SchoolsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get dailySessions => $composableBuilder(
      column: $table.dailySessions, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<List<WorkDay>, List<WorkDay>, String>
      get workDays => $composableBuilder(
          column: $table.workDays,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<int> get firstSessionTime => $composableBuilder(
      column: $table.firstSessionTime,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sessionDuration => $composableBuilder(
      column: $table.sessionDuration,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get academicYear => $composableBuilder(
      column: $table.academicYear, builder: (column) => ColumnFilters(column));

  Expression<bool> schedulesTableRefs(
      Expression<bool> Function($$SchedulesTableTableFilterComposer f) f) {
    final $$SchedulesTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.schedulesTable,
        getReferencedColumn: (t) => t.schoolId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SchedulesTableTableFilterComposer(
              $db: $db,
              $table: $db.schedulesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SchoolsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SchoolsTableTable> {
  $$SchoolsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get dailySessions => $composableBuilder(
      column: $table.dailySessions,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get workDays => $composableBuilder(
      column: $table.workDays, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get firstSessionTime => $composableBuilder(
      column: $table.firstSessionTime,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sessionDuration => $composableBuilder(
      column: $table.sessionDuration,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get academicYear => $composableBuilder(
      column: $table.academicYear,
      builder: (column) => ColumnOrderings(column));
}

class $$SchoolsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SchoolsTableTable> {
  $$SchoolsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<int> get dailySessions => $composableBuilder(
      column: $table.dailySessions, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<WorkDay>, String> get workDays =>
      $composableBuilder(column: $table.workDays, builder: (column) => column);

  GeneratedColumn<int> get firstSessionTime => $composableBuilder(
      column: $table.firstSessionTime, builder: (column) => column);

  GeneratedColumn<int> get sessionDuration => $composableBuilder(
      column: $table.sessionDuration, builder: (column) => column);

  GeneratedColumn<String> get academicYear => $composableBuilder(
      column: $table.academicYear, builder: (column) => column);

  Expression<T> schedulesTableRefs<T extends Object>(
      Expression<T> Function($$SchedulesTableTableAnnotationComposer a) f) {
    final $$SchedulesTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.schedulesTable,
        getReferencedColumn: (t) => t.schoolId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SchedulesTableTableAnnotationComposer(
              $db: $db,
              $table: $db.schedulesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SchoolsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SchoolsTableTable,
    SchoolDto,
    $$SchoolsTableTableFilterComposer,
    $$SchoolsTableTableOrderingComposer,
    $$SchoolsTableTableAnnotationComposer,
    $$SchoolsTableTableCreateCompanionBuilder,
    $$SchoolsTableTableUpdateCompanionBuilder,
    (SchoolDto, $$SchoolsTableTableReferences),
    SchoolDto,
    PrefetchHooks Function({bool schedulesTableRefs})> {
  $$SchoolsTableTableTableManager(_$AppDatabase db, $SchoolsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SchoolsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SchoolsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SchoolsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> address = const Value.absent(),
            Value<String> phone = const Value.absent(),
            Value<String> email = const Value.absent(),
            Value<int> dailySessions = const Value.absent(),
            Value<List<WorkDay>> workDays = const Value.absent(),
            Value<int> firstSessionTime = const Value.absent(),
            Value<int> sessionDuration = const Value.absent(),
            Value<String> academicYear = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SchoolsTableCompanion(
            id: id,
            name: name,
            address: address,
            phone: phone,
            email: email,
            dailySessions: dailySessions,
            workDays: workDays,
            firstSessionTime: firstSessionTime,
            sessionDuration: sessionDuration,
            academicYear: academicYear,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String address,
            required String phone,
            required String email,
            required int dailySessions,
            required List<WorkDay> workDays,
            required int firstSessionTime,
            required int sessionDuration,
            required String academicYear,
            Value<int> rowid = const Value.absent(),
          }) =>
              SchoolsTableCompanion.insert(
            id: id,
            name: name,
            address: address,
            phone: phone,
            email: email,
            dailySessions: dailySessions,
            workDays: workDays,
            firstSessionTime: firstSessionTime,
            sessionDuration: sessionDuration,
            academicYear: academicYear,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$SchoolsTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({schedulesTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (schedulesTableRefs) db.schedulesTable
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (schedulesTableRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$SchoolsTableTableReferences
                            ._schedulesTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SchoolsTableTableReferences(db, table, p0)
                                .schedulesTableRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.schoolId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$SchoolsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SchoolsTableTable,
    SchoolDto,
    $$SchoolsTableTableFilterComposer,
    $$SchoolsTableTableOrderingComposer,
    $$SchoolsTableTableAnnotationComposer,
    $$SchoolsTableTableCreateCompanionBuilder,
    $$SchoolsTableTableUpdateCompanionBuilder,
    (SchoolDto, $$SchoolsTableTableReferences),
    SchoolDto,
    PrefetchHooks Function({bool schedulesTableRefs})>;
typedef $$TeachersTableTableCreateCompanionBuilder = TeachersTableCompanion
    Function({
  required String id,
  required String fullName,
  Value<String?> qualification,
  required String specialization,
  required String phone,
  Value<String?> email,
  required int maxWeeklyHours,
  required int maxDailyHours,
  required Map<WorkDay, List<int>> unavailablePeriods,
  required List<String> subjectIds,
  required List<String> classIds,
  required TeacherType type,
  Value<List<WorkDay>> workDays,
  Value<int> rowid,
});
typedef $$TeachersTableTableUpdateCompanionBuilder = TeachersTableCompanion
    Function({
  Value<String> id,
  Value<String> fullName,
  Value<String?> qualification,
  Value<String> specialization,
  Value<String> phone,
  Value<String?> email,
  Value<int> maxWeeklyHours,
  Value<int> maxDailyHours,
  Value<Map<WorkDay, List<int>>> unavailablePeriods,
  Value<List<String>> subjectIds,
  Value<List<String>> classIds,
  Value<TeacherType> type,
  Value<List<WorkDay>> workDays,
  Value<int> rowid,
});

final class $$TeachersTableTableReferences
    extends BaseReferences<_$AppDatabase, $TeachersTableTable, TeacherDto> {
  $$TeachersTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SessionsTableTable, List<SessionDto>>
      _sessionsTableRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.sessionsTable,
              aliasName: $_aliasNameGenerator(
                  db.teachersTable.id, db.sessionsTable.teacherId));

  $$SessionsTableTableProcessedTableManager get sessionsTableRefs {
    final manager = $$SessionsTableTableTableManager($_db, $_db.sessionsTable)
        .filter((f) => f.teacherId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_sessionsTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$TeachersTableTableFilterComposer
    extends Composer<_$AppDatabase, $TeachersTableTable> {
  $$TeachersTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fullName => $composableBuilder(
      column: $table.fullName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get qualification => $composableBuilder(
      column: $table.qualification, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get specialization => $composableBuilder(
      column: $table.specialization,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get maxWeeklyHours => $composableBuilder(
      column: $table.maxWeeklyHours,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get maxDailyHours => $composableBuilder(
      column: $table.maxDailyHours, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<Map<WorkDay, List<int>>,
          Map<WorkDay, List<int>>, String>
      get unavailablePeriods => $composableBuilder(
          column: $table.unavailablePeriods,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
      get subjectIds => $composableBuilder(
          column: $table.subjectIds,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
      get classIds => $composableBuilder(
          column: $table.classIds,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<TeacherType, TeacherType, int> get type =>
      $composableBuilder(
          column: $table.type,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<List<WorkDay>, List<WorkDay>, String>
      get workDays => $composableBuilder(
          column: $table.workDays,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  Expression<bool> sessionsTableRefs(
      Expression<bool> Function($$SessionsTableTableFilterComposer f) f) {
    final $$SessionsTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.sessionsTable,
        getReferencedColumn: (t) => t.teacherId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SessionsTableTableFilterComposer(
              $db: $db,
              $table: $db.sessionsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TeachersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TeachersTableTable> {
  $$TeachersTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fullName => $composableBuilder(
      column: $table.fullName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get qualification => $composableBuilder(
      column: $table.qualification,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get specialization => $composableBuilder(
      column: $table.specialization,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get maxWeeklyHours => $composableBuilder(
      column: $table.maxWeeklyHours,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get maxDailyHours => $composableBuilder(
      column: $table.maxDailyHours,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unavailablePeriods => $composableBuilder(
      column: $table.unavailablePeriods,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get subjectIds => $composableBuilder(
      column: $table.subjectIds, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get classIds => $composableBuilder(
      column: $table.classIds, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get workDays => $composableBuilder(
      column: $table.workDays, builder: (column) => ColumnOrderings(column));
}

class $$TeachersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TeachersTableTable> {
  $$TeachersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get qualification => $composableBuilder(
      column: $table.qualification, builder: (column) => column);

  GeneratedColumn<String> get specialization => $composableBuilder(
      column: $table.specialization, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<int> get maxWeeklyHours => $composableBuilder(
      column: $table.maxWeeklyHours, builder: (column) => column);

  GeneratedColumn<int> get maxDailyHours => $composableBuilder(
      column: $table.maxDailyHours, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<WorkDay, List<int>>, String>
      get unavailablePeriods => $composableBuilder(
          column: $table.unavailablePeriods, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get subjectIds =>
      $composableBuilder(
          column: $table.subjectIds, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get classIds =>
      $composableBuilder(column: $table.classIds, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TeacherType, int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<WorkDay>, String> get workDays =>
      $composableBuilder(column: $table.workDays, builder: (column) => column);

  Expression<T> sessionsTableRefs<T extends Object>(
      Expression<T> Function($$SessionsTableTableAnnotationComposer a) f) {
    final $$SessionsTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.sessionsTable,
        getReferencedColumn: (t) => t.teacherId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SessionsTableTableAnnotationComposer(
              $db: $db,
              $table: $db.sessionsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TeachersTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TeachersTableTable,
    TeacherDto,
    $$TeachersTableTableFilterComposer,
    $$TeachersTableTableOrderingComposer,
    $$TeachersTableTableAnnotationComposer,
    $$TeachersTableTableCreateCompanionBuilder,
    $$TeachersTableTableUpdateCompanionBuilder,
    (TeacherDto, $$TeachersTableTableReferences),
    TeacherDto,
    PrefetchHooks Function({bool sessionsTableRefs})> {
  $$TeachersTableTableTableManager(_$AppDatabase db, $TeachersTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TeachersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TeachersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TeachersTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> fullName = const Value.absent(),
            Value<String?> qualification = const Value.absent(),
            Value<String> specialization = const Value.absent(),
            Value<String> phone = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<int> maxWeeklyHours = const Value.absent(),
            Value<int> maxDailyHours = const Value.absent(),
            Value<Map<WorkDay, List<int>>> unavailablePeriods =
                const Value.absent(),
            Value<List<String>> subjectIds = const Value.absent(),
            Value<List<String>> classIds = const Value.absent(),
            Value<TeacherType> type = const Value.absent(),
            Value<List<WorkDay>> workDays = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TeachersTableCompanion(
            id: id,
            fullName: fullName,
            qualification: qualification,
            specialization: specialization,
            phone: phone,
            email: email,
            maxWeeklyHours: maxWeeklyHours,
            maxDailyHours: maxDailyHours,
            unavailablePeriods: unavailablePeriods,
            subjectIds: subjectIds,
            classIds: classIds,
            type: type,
            workDays: workDays,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String fullName,
            Value<String?> qualification = const Value.absent(),
            required String specialization,
            required String phone,
            Value<String?> email = const Value.absent(),
            required int maxWeeklyHours,
            required int maxDailyHours,
            required Map<WorkDay, List<int>> unavailablePeriods,
            required List<String> subjectIds,
            required List<String> classIds,
            required TeacherType type,
            Value<List<WorkDay>> workDays = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TeachersTableCompanion.insert(
            id: id,
            fullName: fullName,
            qualification: qualification,
            specialization: specialization,
            phone: phone,
            email: email,
            maxWeeklyHours: maxWeeklyHours,
            maxDailyHours: maxDailyHours,
            unavailablePeriods: unavailablePeriods,
            subjectIds: subjectIds,
            classIds: classIds,
            type: type,
            workDays: workDays,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$TeachersTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({sessionsTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (sessionsTableRefs) db.sessionsTable
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (sessionsTableRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$TeachersTableTableReferences
                            ._sessionsTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$TeachersTableTableReferences(db, table, p0)
                                .sessionsTableRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.teacherId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$TeachersTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TeachersTableTable,
    TeacherDto,
    $$TeachersTableTableFilterComposer,
    $$TeachersTableTableOrderingComposer,
    $$TeachersTableTableAnnotationComposer,
    $$TeachersTableTableCreateCompanionBuilder,
    $$TeachersTableTableUpdateCompanionBuilder,
    (TeacherDto, $$TeachersTableTableReferences),
    TeacherDto,
    PrefetchHooks Function({bool sessionsTableRefs})>;
typedef $$SubjectsTableTableCreateCompanionBuilder = SubjectsTableCompanion
    Function({
  required String id,
  required String name,
  Value<String?> code,
  required SubjectPriority priority,
  Value<int> weeklyHours,
  Value<Map<String, int>> classPeriods,
  required int color,
  Value<bool> requiresLab,
  Value<bool> requiresProjector,
  required List<String> qualifiedTeacherIds,
  Value<int> rowid,
});
typedef $$SubjectsTableTableUpdateCompanionBuilder = SubjectsTableCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<String?> code,
  Value<SubjectPriority> priority,
  Value<int> weeklyHours,
  Value<Map<String, int>> classPeriods,
  Value<int> color,
  Value<bool> requiresLab,
  Value<bool> requiresProjector,
  Value<List<String>> qualifiedTeacherIds,
  Value<int> rowid,
});

final class $$SubjectsTableTableReferences
    extends BaseReferences<_$AppDatabase, $SubjectsTableTable, SubjectDto> {
  $$SubjectsTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SessionsTableTable, List<SessionDto>>
      _sessionsTableRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.sessionsTable,
              aliasName: $_aliasNameGenerator(
                  db.subjectsTable.id, db.sessionsTable.subjectId));

  $$SessionsTableTableProcessedTableManager get sessionsTableRefs {
    final manager = $$SessionsTableTableTableManager($_db, $_db.sessionsTable)
        .filter((f) => f.subjectId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_sessionsTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$SubjectsTableTableFilterComposer
    extends Composer<_$AppDatabase, $SubjectsTableTable> {
  $$SubjectsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<SubjectPriority, SubjectPriority, int>
      get priority => $composableBuilder(
          column: $table.priority,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<int> get weeklyHours => $composableBuilder(
      column: $table.weeklyHours, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<Map<String, int>, Map<String, int>, String>
      get classPeriods => $composableBuilder(
          column: $table.classPeriods,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<int> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get requiresLab => $composableBuilder(
      column: $table.requiresLab, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get requiresProjector => $composableBuilder(
      column: $table.requiresProjector,
      builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
      get qualifiedTeacherIds => $composableBuilder(
          column: $table.qualifiedTeacherIds,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  Expression<bool> sessionsTableRefs(
      Expression<bool> Function($$SessionsTableTableFilterComposer f) f) {
    final $$SessionsTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.sessionsTable,
        getReferencedColumn: (t) => t.subjectId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SessionsTableTableFilterComposer(
              $db: $db,
              $table: $db.sessionsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SubjectsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SubjectsTableTable> {
  $$SubjectsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get weeklyHours => $composableBuilder(
      column: $table.weeklyHours, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get classPeriods => $composableBuilder(
      column: $table.classPeriods,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get requiresLab => $composableBuilder(
      column: $table.requiresLab, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get requiresProjector => $composableBuilder(
      column: $table.requiresProjector,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get qualifiedTeacherIds => $composableBuilder(
      column: $table.qualifiedTeacherIds,
      builder: (column) => ColumnOrderings(column));
}

class $$SubjectsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubjectsTableTable> {
  $$SubjectsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SubjectPriority, int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<int> get weeklyHours => $composableBuilder(
      column: $table.weeklyHours, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, int>, String> get classPeriods =>
      $composableBuilder(
          column: $table.classPeriods, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<bool> get requiresLab => $composableBuilder(
      column: $table.requiresLab, builder: (column) => column);

  GeneratedColumn<bool> get requiresProjector => $composableBuilder(
      column: $table.requiresProjector, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String>
      get qualifiedTeacherIds => $composableBuilder(
          column: $table.qualifiedTeacherIds, builder: (column) => column);

  Expression<T> sessionsTableRefs<T extends Object>(
      Expression<T> Function($$SessionsTableTableAnnotationComposer a) f) {
    final $$SessionsTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.sessionsTable,
        getReferencedColumn: (t) => t.subjectId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SessionsTableTableAnnotationComposer(
              $db: $db,
              $table: $db.sessionsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SubjectsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SubjectsTableTable,
    SubjectDto,
    $$SubjectsTableTableFilterComposer,
    $$SubjectsTableTableOrderingComposer,
    $$SubjectsTableTableAnnotationComposer,
    $$SubjectsTableTableCreateCompanionBuilder,
    $$SubjectsTableTableUpdateCompanionBuilder,
    (SubjectDto, $$SubjectsTableTableReferences),
    SubjectDto,
    PrefetchHooks Function({bool sessionsTableRefs})> {
  $$SubjectsTableTableTableManager(_$AppDatabase db, $SubjectsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubjectsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubjectsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubjectsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> code = const Value.absent(),
            Value<SubjectPriority> priority = const Value.absent(),
            Value<int> weeklyHours = const Value.absent(),
            Value<Map<String, int>> classPeriods = const Value.absent(),
            Value<int> color = const Value.absent(),
            Value<bool> requiresLab = const Value.absent(),
            Value<bool> requiresProjector = const Value.absent(),
            Value<List<String>> qualifiedTeacherIds = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SubjectsTableCompanion(
            id: id,
            name: name,
            code: code,
            priority: priority,
            weeklyHours: weeklyHours,
            classPeriods: classPeriods,
            color: color,
            requiresLab: requiresLab,
            requiresProjector: requiresProjector,
            qualifiedTeacherIds: qualifiedTeacherIds,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String?> code = const Value.absent(),
            required SubjectPriority priority,
            Value<int> weeklyHours = const Value.absent(),
            Value<Map<String, int>> classPeriods = const Value.absent(),
            required int color,
            Value<bool> requiresLab = const Value.absent(),
            Value<bool> requiresProjector = const Value.absent(),
            required List<String> qualifiedTeacherIds,
            Value<int> rowid = const Value.absent(),
          }) =>
              SubjectsTableCompanion.insert(
            id: id,
            name: name,
            code: code,
            priority: priority,
            weeklyHours: weeklyHours,
            classPeriods: classPeriods,
            color: color,
            requiresLab: requiresLab,
            requiresProjector: requiresProjector,
            qualifiedTeacherIds: qualifiedTeacherIds,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$SubjectsTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({sessionsTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (sessionsTableRefs) db.sessionsTable
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (sessionsTableRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$SubjectsTableTableReferences
                            ._sessionsTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SubjectsTableTableReferences(db, table, p0)
                                .sessionsTableRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.subjectId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$SubjectsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SubjectsTableTable,
    SubjectDto,
    $$SubjectsTableTableFilterComposer,
    $$SubjectsTableTableOrderingComposer,
    $$SubjectsTableTableAnnotationComposer,
    $$SubjectsTableTableCreateCompanionBuilder,
    $$SubjectsTableTableUpdateCompanionBuilder,
    (SubjectDto, $$SubjectsTableTableReferences),
    SubjectDto,
    PrefetchHooks Function({bool sessionsTableRefs})>;
typedef $$ClassroomsTableTableCreateCompanionBuilder = ClassroomsTableCompanion
    Function({
  required String id,
  required String name,
  required String section,
  required int studentCount,
  required String roomNumber,
  required ClassLevel level,
  Value<String?> supervisorId,
  Value<List<String>> subjectIds,
  Value<int> rowid,
});
typedef $$ClassroomsTableTableUpdateCompanionBuilder = ClassroomsTableCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<String> section,
  Value<int> studentCount,
  Value<String> roomNumber,
  Value<ClassLevel> level,
  Value<String?> supervisorId,
  Value<List<String>> subjectIds,
  Value<int> rowid,
});

final class $$ClassroomsTableTableReferences
    extends BaseReferences<_$AppDatabase, $ClassroomsTableTable, ClassroomDto> {
  $$ClassroomsTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SessionsTableTable, List<SessionDto>>
      _sessionsTableRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.sessionsTable,
              aliasName: $_aliasNameGenerator(
                  db.classroomsTable.id, db.sessionsTable.classId));

  $$SessionsTableTableProcessedTableManager get sessionsTableRefs {
    final manager = $$SessionsTableTableTableManager($_db, $_db.sessionsTable)
        .filter((f) => f.classId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_sessionsTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ClassroomsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ClassroomsTableTable> {
  $$ClassroomsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get section => $composableBuilder(
      column: $table.section, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get studentCount => $composableBuilder(
      column: $table.studentCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get roomNumber => $composableBuilder(
      column: $table.roomNumber, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<ClassLevel, ClassLevel, int> get level =>
      $composableBuilder(
          column: $table.level,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get supervisorId => $composableBuilder(
      column: $table.supervisorId, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
      get subjectIds => $composableBuilder(
          column: $table.subjectIds,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  Expression<bool> sessionsTableRefs(
      Expression<bool> Function($$SessionsTableTableFilterComposer f) f) {
    final $$SessionsTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.sessionsTable,
        getReferencedColumn: (t) => t.classId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SessionsTableTableFilterComposer(
              $db: $db,
              $table: $db.sessionsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ClassroomsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ClassroomsTableTable> {
  $$ClassroomsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get section => $composableBuilder(
      column: $table.section, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get studentCount => $composableBuilder(
      column: $table.studentCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get roomNumber => $composableBuilder(
      column: $table.roomNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get supervisorId => $composableBuilder(
      column: $table.supervisorId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get subjectIds => $composableBuilder(
      column: $table.subjectIds, builder: (column) => ColumnOrderings(column));
}

class $$ClassroomsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClassroomsTableTable> {
  $$ClassroomsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get section =>
      $composableBuilder(column: $table.section, builder: (column) => column);

  GeneratedColumn<int> get studentCount => $composableBuilder(
      column: $table.studentCount, builder: (column) => column);

  GeneratedColumn<String> get roomNumber => $composableBuilder(
      column: $table.roomNumber, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ClassLevel, int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get supervisorId => $composableBuilder(
      column: $table.supervisorId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get subjectIds =>
      $composableBuilder(
          column: $table.subjectIds, builder: (column) => column);

  Expression<T> sessionsTableRefs<T extends Object>(
      Expression<T> Function($$SessionsTableTableAnnotationComposer a) f) {
    final $$SessionsTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.sessionsTable,
        getReferencedColumn: (t) => t.classId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SessionsTableTableAnnotationComposer(
              $db: $db,
              $table: $db.sessionsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ClassroomsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ClassroomsTableTable,
    ClassroomDto,
    $$ClassroomsTableTableFilterComposer,
    $$ClassroomsTableTableOrderingComposer,
    $$ClassroomsTableTableAnnotationComposer,
    $$ClassroomsTableTableCreateCompanionBuilder,
    $$ClassroomsTableTableUpdateCompanionBuilder,
    (ClassroomDto, $$ClassroomsTableTableReferences),
    ClassroomDto,
    PrefetchHooks Function({bool sessionsTableRefs})> {
  $$ClassroomsTableTableTableManager(
      _$AppDatabase db, $ClassroomsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClassroomsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClassroomsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClassroomsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> section = const Value.absent(),
            Value<int> studentCount = const Value.absent(),
            Value<String> roomNumber = const Value.absent(),
            Value<ClassLevel> level = const Value.absent(),
            Value<String?> supervisorId = const Value.absent(),
            Value<List<String>> subjectIds = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ClassroomsTableCompanion(
            id: id,
            name: name,
            section: section,
            studentCount: studentCount,
            roomNumber: roomNumber,
            level: level,
            supervisorId: supervisorId,
            subjectIds: subjectIds,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String section,
            required int studentCount,
            required String roomNumber,
            required ClassLevel level,
            Value<String?> supervisorId = const Value.absent(),
            Value<List<String>> subjectIds = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ClassroomsTableCompanion.insert(
            id: id,
            name: name,
            section: section,
            studentCount: studentCount,
            roomNumber: roomNumber,
            level: level,
            supervisorId: supervisorId,
            subjectIds: subjectIds,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ClassroomsTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({sessionsTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (sessionsTableRefs) db.sessionsTable
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (sessionsTableRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$ClassroomsTableTableReferences
                            ._sessionsTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ClassroomsTableTableReferences(db, table, p0)
                                .sessionsTableRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.classId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ClassroomsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ClassroomsTableTable,
    ClassroomDto,
    $$ClassroomsTableTableFilterComposer,
    $$ClassroomsTableTableOrderingComposer,
    $$ClassroomsTableTableAnnotationComposer,
    $$ClassroomsTableTableCreateCompanionBuilder,
    $$ClassroomsTableTableUpdateCompanionBuilder,
    (ClassroomDto, $$ClassroomsTableTableReferences),
    ClassroomDto,
    PrefetchHooks Function({bool sessionsTableRefs})>;
typedef $$SchedulesTableTableCreateCompanionBuilder = SchedulesTableCompanion
    Function({
  required String id,
  required String name,
  required DateTime creationDate,
  required DateTime startDate,
  required DateTime endDate,
  required String schoolId,
  required String creatorId,
  required ScheduleStatus status,
  Value<String?> metadata,
  Value<int> rowid,
});
typedef $$SchedulesTableTableUpdateCompanionBuilder = SchedulesTableCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<DateTime> creationDate,
  Value<DateTime> startDate,
  Value<DateTime> endDate,
  Value<String> schoolId,
  Value<String> creatorId,
  Value<ScheduleStatus> status,
  Value<String?> metadata,
  Value<int> rowid,
});

final class $$SchedulesTableTableReferences
    extends BaseReferences<_$AppDatabase, $SchedulesTableTable, ScheduleDto> {
  $$SchedulesTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $SchoolsTableTable _schoolIdTable(_$AppDatabase db) =>
      db.schoolsTable.createAlias(
          $_aliasNameGenerator(db.schedulesTable.schoolId, db.schoolsTable.id));

  $$SchoolsTableTableProcessedTableManager get schoolId {
    final manager = $$SchoolsTableTableTableManager($_db, $_db.schoolsTable)
        .filter((f) => f.id($_item.schoolId));
    final item = $_typedResult.readTableOrNull(_schoolIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$SessionsTableTable, List<SessionDto>>
      _sessionsTableRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.sessionsTable,
              aliasName: $_aliasNameGenerator(
                  db.schedulesTable.id, db.sessionsTable.scheduleId));

  $$SessionsTableTableProcessedTableManager get sessionsTableRefs {
    final manager = $$SessionsTableTableTableManager($_db, $_db.sessionsTable)
        .filter((f) => f.scheduleId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_sessionsTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$SchedulesTableTableFilterComposer
    extends Composer<_$AppDatabase, $SchedulesTableTable> {
  $$SchedulesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get creationDate => $composableBuilder(
      column: $table.creationDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get creatorId => $composableBuilder(
      column: $table.creatorId, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<ScheduleStatus, ScheduleStatus, int>
      get status => $composableBuilder(
          column: $table.status,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get metadata => $composableBuilder(
      column: $table.metadata, builder: (column) => ColumnFilters(column));

  $$SchoolsTableTableFilterComposer get schoolId {
    final $$SchoolsTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.schoolId,
        referencedTable: $db.schoolsTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SchoolsTableTableFilterComposer(
              $db: $db,
              $table: $db.schoolsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> sessionsTableRefs(
      Expression<bool> Function($$SessionsTableTableFilterComposer f) f) {
    final $$SessionsTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.sessionsTable,
        getReferencedColumn: (t) => t.scheduleId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SessionsTableTableFilterComposer(
              $db: $db,
              $table: $db.sessionsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SchedulesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SchedulesTableTable> {
  $$SchedulesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get creationDate => $composableBuilder(
      column: $table.creationDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get creatorId => $composableBuilder(
      column: $table.creatorId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get metadata => $composableBuilder(
      column: $table.metadata, builder: (column) => ColumnOrderings(column));

  $$SchoolsTableTableOrderingComposer get schoolId {
    final $$SchoolsTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.schoolId,
        referencedTable: $db.schoolsTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SchoolsTableTableOrderingComposer(
              $db: $db,
              $table: $db.schoolsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SchedulesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SchedulesTableTable> {
  $$SchedulesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get creationDate => $composableBuilder(
      column: $table.creationDate, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<String> get creatorId =>
      $composableBuilder(column: $table.creatorId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ScheduleStatus, int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get metadata =>
      $composableBuilder(column: $table.metadata, builder: (column) => column);

  $$SchoolsTableTableAnnotationComposer get schoolId {
    final $$SchoolsTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.schoolId,
        referencedTable: $db.schoolsTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SchoolsTableTableAnnotationComposer(
              $db: $db,
              $table: $db.schoolsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> sessionsTableRefs<T extends Object>(
      Expression<T> Function($$SessionsTableTableAnnotationComposer a) f) {
    final $$SessionsTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.sessionsTable,
        getReferencedColumn: (t) => t.scheduleId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SessionsTableTableAnnotationComposer(
              $db: $db,
              $table: $db.sessionsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SchedulesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SchedulesTableTable,
    ScheduleDto,
    $$SchedulesTableTableFilterComposer,
    $$SchedulesTableTableOrderingComposer,
    $$SchedulesTableTableAnnotationComposer,
    $$SchedulesTableTableCreateCompanionBuilder,
    $$SchedulesTableTableUpdateCompanionBuilder,
    (ScheduleDto, $$SchedulesTableTableReferences),
    ScheduleDto,
    PrefetchHooks Function({bool schoolId, bool sessionsTableRefs})> {
  $$SchedulesTableTableTableManager(
      _$AppDatabase db, $SchedulesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SchedulesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SchedulesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SchedulesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<DateTime> creationDate = const Value.absent(),
            Value<DateTime> startDate = const Value.absent(),
            Value<DateTime> endDate = const Value.absent(),
            Value<String> schoolId = const Value.absent(),
            Value<String> creatorId = const Value.absent(),
            Value<ScheduleStatus> status = const Value.absent(),
            Value<String?> metadata = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SchedulesTableCompanion(
            id: id,
            name: name,
            creationDate: creationDate,
            startDate: startDate,
            endDate: endDate,
            schoolId: schoolId,
            creatorId: creatorId,
            status: status,
            metadata: metadata,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required DateTime creationDate,
            required DateTime startDate,
            required DateTime endDate,
            required String schoolId,
            required String creatorId,
            required ScheduleStatus status,
            Value<String?> metadata = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SchedulesTableCompanion.insert(
            id: id,
            name: name,
            creationDate: creationDate,
            startDate: startDate,
            endDate: endDate,
            schoolId: schoolId,
            creatorId: creatorId,
            status: status,
            metadata: metadata,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$SchedulesTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {schoolId = false, sessionsTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (sessionsTableRefs) db.sessionsTable
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (schoolId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.schoolId,
                    referencedTable:
                        $$SchedulesTableTableReferences._schoolIdTable(db),
                    referencedColumn:
                        $$SchedulesTableTableReferences._schoolIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (sessionsTableRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$SchedulesTableTableReferences
                            ._sessionsTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SchedulesTableTableReferences(db, table, p0)
                                .sessionsTableRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.scheduleId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$SchedulesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SchedulesTableTable,
    ScheduleDto,
    $$SchedulesTableTableFilterComposer,
    $$SchedulesTableTableOrderingComposer,
    $$SchedulesTableTableAnnotationComposer,
    $$SchedulesTableTableCreateCompanionBuilder,
    $$SchedulesTableTableUpdateCompanionBuilder,
    (ScheduleDto, $$SchedulesTableTableReferences),
    ScheduleDto,
    PrefetchHooks Function({bool schoolId, bool sessionsTableRefs})>;
typedef $$SessionsTableTableCreateCompanionBuilder = SessionsTableCompanion
    Function({
  required String id,
  required WorkDay day,
  required int sessionNumber,
  required String classId,
  required String teacherId,
  required String subjectId,
  required String roomId,
  required SessionStatus status,
  Value<DateTime?> actualDate,
  Value<String?> notes,
  required String scheduleId,
  Value<int> rowid,
});
typedef $$SessionsTableTableUpdateCompanionBuilder = SessionsTableCompanion
    Function({
  Value<String> id,
  Value<WorkDay> day,
  Value<int> sessionNumber,
  Value<String> classId,
  Value<String> teacherId,
  Value<String> subjectId,
  Value<String> roomId,
  Value<SessionStatus> status,
  Value<DateTime?> actualDate,
  Value<String?> notes,
  Value<String> scheduleId,
  Value<int> rowid,
});

final class $$SessionsTableTableReferences
    extends BaseReferences<_$AppDatabase, $SessionsTableTable, SessionDto> {
  $$SessionsTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ClassroomsTableTable _classIdTable(_$AppDatabase db) =>
      db.classroomsTable.createAlias($_aliasNameGenerator(
          db.sessionsTable.classId, db.classroomsTable.id));

  $$ClassroomsTableTableProcessedTableManager get classId {
    final manager =
        $$ClassroomsTableTableTableManager($_db, $_db.classroomsTable)
            .filter((f) => f.id($_item.classId));
    final item = $_typedResult.readTableOrNull(_classIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $TeachersTableTable _teacherIdTable(_$AppDatabase db) =>
      db.teachersTable.createAlias($_aliasNameGenerator(
          db.sessionsTable.teacherId, db.teachersTable.id));

  $$TeachersTableTableProcessedTableManager get teacherId {
    final manager = $$TeachersTableTableTableManager($_db, $_db.teachersTable)
        .filter((f) => f.id($_item.teacherId));
    final item = $_typedResult.readTableOrNull(_teacherIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $SubjectsTableTable _subjectIdTable(_$AppDatabase db) =>
      db.subjectsTable.createAlias($_aliasNameGenerator(
          db.sessionsTable.subjectId, db.subjectsTable.id));

  $$SubjectsTableTableProcessedTableManager get subjectId {
    final manager = $$SubjectsTableTableTableManager($_db, $_db.subjectsTable)
        .filter((f) => f.id($_item.subjectId));
    final item = $_typedResult.readTableOrNull(_subjectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $SchedulesTableTable _scheduleIdTable(_$AppDatabase db) =>
      db.schedulesTable.createAlias($_aliasNameGenerator(
          db.sessionsTable.scheduleId, db.schedulesTable.id));

  $$SchedulesTableTableProcessedTableManager get scheduleId {
    final manager = $$SchedulesTableTableTableManager($_db, $_db.schedulesTable)
        .filter((f) => f.id($_item.scheduleId));
    final item = $_typedResult.readTableOrNull(_scheduleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$SessionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $SessionsTableTable> {
  $$SessionsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<WorkDay, WorkDay, int> get day =>
      $composableBuilder(
          column: $table.day,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<int> get sessionNumber => $composableBuilder(
      column: $table.sessionNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get roomId => $composableBuilder(
      column: $table.roomId, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<SessionStatus, SessionStatus, int>
      get status => $composableBuilder(
          column: $table.status,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<DateTime> get actualDate => $composableBuilder(
      column: $table.actualDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  $$ClassroomsTableTableFilterComposer get classId {
    final $$ClassroomsTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.classId,
        referencedTable: $db.classroomsTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ClassroomsTableTableFilterComposer(
              $db: $db,
              $table: $db.classroomsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$TeachersTableTableFilterComposer get teacherId {
    final $$TeachersTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.teacherId,
        referencedTable: $db.teachersTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TeachersTableTableFilterComposer(
              $db: $db,
              $table: $db.teachersTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$SubjectsTableTableFilterComposer get subjectId {
    final $$SubjectsTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.subjectId,
        referencedTable: $db.subjectsTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SubjectsTableTableFilterComposer(
              $db: $db,
              $table: $db.subjectsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$SchedulesTableTableFilterComposer get scheduleId {
    final $$SchedulesTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.scheduleId,
        referencedTable: $db.schedulesTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SchedulesTableTableFilterComposer(
              $db: $db,
              $table: $db.schedulesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SessionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionsTableTable> {
  $$SessionsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get day => $composableBuilder(
      column: $table.day, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sessionNumber => $composableBuilder(
      column: $table.sessionNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get roomId => $composableBuilder(
      column: $table.roomId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get actualDate => $composableBuilder(
      column: $table.actualDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  $$ClassroomsTableTableOrderingComposer get classId {
    final $$ClassroomsTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.classId,
        referencedTable: $db.classroomsTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ClassroomsTableTableOrderingComposer(
              $db: $db,
              $table: $db.classroomsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$TeachersTableTableOrderingComposer get teacherId {
    final $$TeachersTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.teacherId,
        referencedTable: $db.teachersTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TeachersTableTableOrderingComposer(
              $db: $db,
              $table: $db.teachersTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$SubjectsTableTableOrderingComposer get subjectId {
    final $$SubjectsTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.subjectId,
        referencedTable: $db.subjectsTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SubjectsTableTableOrderingComposer(
              $db: $db,
              $table: $db.subjectsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$SchedulesTableTableOrderingComposer get scheduleId {
    final $$SchedulesTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.scheduleId,
        referencedTable: $db.schedulesTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SchedulesTableTableOrderingComposer(
              $db: $db,
              $table: $db.schedulesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SessionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionsTableTable> {
  $$SessionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<WorkDay, int> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumn<int> get sessionNumber => $composableBuilder(
      column: $table.sessionNumber, builder: (column) => column);

  GeneratedColumn<String> get roomId =>
      $composableBuilder(column: $table.roomId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SessionStatus, int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get actualDate => $composableBuilder(
      column: $table.actualDate, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$ClassroomsTableTableAnnotationComposer get classId {
    final $$ClassroomsTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.classId,
        referencedTable: $db.classroomsTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ClassroomsTableTableAnnotationComposer(
              $db: $db,
              $table: $db.classroomsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$TeachersTableTableAnnotationComposer get teacherId {
    final $$TeachersTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.teacherId,
        referencedTable: $db.teachersTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TeachersTableTableAnnotationComposer(
              $db: $db,
              $table: $db.teachersTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$SubjectsTableTableAnnotationComposer get subjectId {
    final $$SubjectsTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.subjectId,
        referencedTable: $db.subjectsTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SubjectsTableTableAnnotationComposer(
              $db: $db,
              $table: $db.subjectsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$SchedulesTableTableAnnotationComposer get scheduleId {
    final $$SchedulesTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.scheduleId,
        referencedTable: $db.schedulesTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SchedulesTableTableAnnotationComposer(
              $db: $db,
              $table: $db.schedulesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SessionsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SessionsTableTable,
    SessionDto,
    $$SessionsTableTableFilterComposer,
    $$SessionsTableTableOrderingComposer,
    $$SessionsTableTableAnnotationComposer,
    $$SessionsTableTableCreateCompanionBuilder,
    $$SessionsTableTableUpdateCompanionBuilder,
    (SessionDto, $$SessionsTableTableReferences),
    SessionDto,
    PrefetchHooks Function(
        {bool classId, bool teacherId, bool subjectId, bool scheduleId})> {
  $$SessionsTableTableTableManager(_$AppDatabase db, $SessionsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<WorkDay> day = const Value.absent(),
            Value<int> sessionNumber = const Value.absent(),
            Value<String> classId = const Value.absent(),
            Value<String> teacherId = const Value.absent(),
            Value<String> subjectId = const Value.absent(),
            Value<String> roomId = const Value.absent(),
            Value<SessionStatus> status = const Value.absent(),
            Value<DateTime?> actualDate = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String> scheduleId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SessionsTableCompanion(
            id: id,
            day: day,
            sessionNumber: sessionNumber,
            classId: classId,
            teacherId: teacherId,
            subjectId: subjectId,
            roomId: roomId,
            status: status,
            actualDate: actualDate,
            notes: notes,
            scheduleId: scheduleId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required WorkDay day,
            required int sessionNumber,
            required String classId,
            required String teacherId,
            required String subjectId,
            required String roomId,
            required SessionStatus status,
            Value<DateTime?> actualDate = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            required String scheduleId,
            Value<int> rowid = const Value.absent(),
          }) =>
              SessionsTableCompanion.insert(
            id: id,
            day: day,
            sessionNumber: sessionNumber,
            classId: classId,
            teacherId: teacherId,
            subjectId: subjectId,
            roomId: roomId,
            status: status,
            actualDate: actualDate,
            notes: notes,
            scheduleId: scheduleId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$SessionsTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {classId = false,
              teacherId = false,
              subjectId = false,
              scheduleId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (classId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.classId,
                    referencedTable:
                        $$SessionsTableTableReferences._classIdTable(db),
                    referencedColumn:
                        $$SessionsTableTableReferences._classIdTable(db).id,
                  ) as T;
                }
                if (teacherId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.teacherId,
                    referencedTable:
                        $$SessionsTableTableReferences._teacherIdTable(db),
                    referencedColumn:
                        $$SessionsTableTableReferences._teacherIdTable(db).id,
                  ) as T;
                }
                if (subjectId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.subjectId,
                    referencedTable:
                        $$SessionsTableTableReferences._subjectIdTable(db),
                    referencedColumn:
                        $$SessionsTableTableReferences._subjectIdTable(db).id,
                  ) as T;
                }
                if (scheduleId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.scheduleId,
                    referencedTable:
                        $$SessionsTableTableReferences._scheduleIdTable(db),
                    referencedColumn:
                        $$SessionsTableTableReferences._scheduleIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$SessionsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SessionsTableTable,
    SessionDto,
    $$SessionsTableTableFilterComposer,
    $$SessionsTableTableOrderingComposer,
    $$SessionsTableTableAnnotationComposer,
    $$SessionsTableTableCreateCompanionBuilder,
    $$SessionsTableTableUpdateCompanionBuilder,
    (SessionDto, $$SessionsTableTableReferences),
    SessionDto,
    PrefetchHooks Function(
        {bool classId, bool teacherId, bool subjectId, bool scheduleId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SchoolsTableTableTableManager get schoolsTable =>
      $$SchoolsTableTableTableManager(_db, _db.schoolsTable);
  $$TeachersTableTableTableManager get teachersTable =>
      $$TeachersTableTableTableManager(_db, _db.teachersTable);
  $$SubjectsTableTableTableManager get subjectsTable =>
      $$SubjectsTableTableTableManager(_db, _db.subjectsTable);
  $$ClassroomsTableTableTableManager get classroomsTable =>
      $$ClassroomsTableTableTableManager(_db, _db.classroomsTable);
  $$SchedulesTableTableTableManager get schedulesTable =>
      $$SchedulesTableTableTableManager(_db, _db.schedulesTable);
  $$SessionsTableTableTableManager get sessionsTable =>
      $$SessionsTableTableTableManager(_db, _db.sessionsTable);
}
