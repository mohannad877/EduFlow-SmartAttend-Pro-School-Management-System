// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_database.dart';

// ignore_for_file: type=lint
class $AttStudentsTable extends AttStudents
    with TableInfo<$AttStudentsTable, AttStudent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttStudentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 2, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _stageMeta = const VerificationMeta('stage');
  @override
  late final GeneratedColumn<String> stage = GeneratedColumn<String>(
      'stage', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _gradeMeta = const VerificationMeta('grade');
  @override
  late final GeneratedColumn<String> grade = GeneratedColumn<String>(
      'grade', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sectionMeta =
      const VerificationMeta('section');
  @override
  late final GeneratedColumn<String> section = GeneratedColumn<String>(
      'section', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _barcodeMeta =
      const VerificationMeta('barcode');
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
      'barcode', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, stage, grade, section, barcode, notes, createdAt, isActive];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'att_students';
  @override
  VerificationContext validateIntegrity(Insertable<AttStudent> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('stage')) {
      context.handle(
          _stageMeta, stage.isAcceptableOrUnknown(data['stage']!, _stageMeta));
    } else if (isInserting) {
      context.missing(_stageMeta);
    }
    if (data.containsKey('grade')) {
      context.handle(
          _gradeMeta, grade.isAcceptableOrUnknown(data['grade']!, _gradeMeta));
    } else if (isInserting) {
      context.missing(_gradeMeta);
    }
    if (data.containsKey('section')) {
      context.handle(_sectionMeta,
          section.isAcceptableOrUnknown(data['section']!, _sectionMeta));
    } else if (isInserting) {
      context.missing(_sectionMeta);
    }
    if (data.containsKey('barcode')) {
      context.handle(_barcodeMeta,
          barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta));
    } else if (isInserting) {
      context.missing(_barcodeMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AttStudent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AttStudent(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      stage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}stage'])!,
      grade: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}grade'])!,
      section: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}section'])!,
      barcode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}barcode'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $AttStudentsTable createAlias(String alias) {
    return $AttStudentsTable(attachedDatabase, alias);
  }
}

class AttStudent extends DataClass implements Insertable<AttStudent> {
  final int id;
  final String name;
  final String stage;
  final String grade;
  final String section;
  final String barcode;
  final String? notes;
  final DateTime createdAt;
  final bool isActive;
  const AttStudent(
      {required this.id,
      required this.name,
      required this.stage,
      required this.grade,
      required this.section,
      required this.barcode,
      this.notes,
      required this.createdAt,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['stage'] = Variable<String>(stage);
    map['grade'] = Variable<String>(grade);
    map['section'] = Variable<String>(section);
    map['barcode'] = Variable<String>(barcode);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  AttStudentsCompanion toCompanion(bool nullToAbsent) {
    return AttStudentsCompanion(
      id: Value(id),
      name: Value(name),
      stage: Value(stage),
      grade: Value(grade),
      section: Value(section),
      barcode: Value(barcode),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
      isActive: Value(isActive),
    );
  }

  factory AttStudent.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AttStudent(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      stage: serializer.fromJson<String>(json['stage']),
      grade: serializer.fromJson<String>(json['grade']),
      section: serializer.fromJson<String>(json['section']),
      barcode: serializer.fromJson<String>(json['barcode']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'stage': serializer.toJson<String>(stage),
      'grade': serializer.toJson<String>(grade),
      'section': serializer.toJson<String>(section),
      'barcode': serializer.toJson<String>(barcode),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  AttStudent copyWith(
          {int? id,
          String? name,
          String? stage,
          String? grade,
          String? section,
          String? barcode,
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt,
          bool? isActive}) =>
      AttStudent(
        id: id ?? this.id,
        name: name ?? this.name,
        stage: stage ?? this.stage,
        grade: grade ?? this.grade,
        section: section ?? this.section,
        barcode: barcode ?? this.barcode,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
        isActive: isActive ?? this.isActive,
      );
  AttStudent copyWithCompanion(AttStudentsCompanion data) {
    return AttStudent(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      stage: data.stage.present ? data.stage.value : this.stage,
      grade: data.grade.present ? data.grade.value : this.grade,
      section: data.section.present ? data.section.value : this.section,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AttStudent(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('stage: $stage, ')
          ..write('grade: $grade, ')
          ..write('section: $section, ')
          ..write('barcode: $barcode, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, name, stage, grade, section, barcode, notes, createdAt, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AttStudent &&
          other.id == this.id &&
          other.name == this.name &&
          other.stage == this.stage &&
          other.grade == this.grade &&
          other.section == this.section &&
          other.barcode == this.barcode &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.isActive == this.isActive);
}

class AttStudentsCompanion extends UpdateCompanion<AttStudent> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> stage;
  final Value<String> grade;
  final Value<String> section;
  final Value<String> barcode;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<bool> isActive;
  const AttStudentsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.stage = const Value.absent(),
    this.grade = const Value.absent(),
    this.section = const Value.absent(),
    this.barcode = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  AttStudentsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String stage,
    required String grade,
    required String section,
    required String barcode,
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isActive = const Value.absent(),
  })  : name = Value(name),
        stage = Value(stage),
        grade = Value(grade),
        section = Value(section),
        barcode = Value(barcode);
  static Insertable<AttStudent> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? stage,
    Expression<String>? grade,
    Expression<String>? section,
    Expression<String>? barcode,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (stage != null) 'stage': stage,
      if (grade != null) 'grade': grade,
      if (section != null) 'section': section,
      if (barcode != null) 'barcode': barcode,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (isActive != null) 'is_active': isActive,
    });
  }

  AttStudentsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? stage,
      Value<String>? grade,
      Value<String>? section,
      Value<String>? barcode,
      Value<String?>? notes,
      Value<DateTime>? createdAt,
      Value<bool>? isActive}) {
    return AttStudentsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      stage: stage ?? this.stage,
      grade: grade ?? this.grade,
      section: section ?? this.section,
      barcode: barcode ?? this.barcode,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (stage.present) {
      map['stage'] = Variable<String>(stage.value);
    }
    if (grade.present) {
      map['grade'] = Variable<String>(grade.value);
    }
    if (section.present) {
      map['section'] = Variable<String>(section.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttStudentsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('stage: $stage, ')
          ..write('grade: $grade, ')
          ..write('section: $section, ')
          ..write('barcode: $barcode, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $AttUsersTable extends AttUsers with TableInfo<$AttUsersTable, AttUser> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttUsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 2, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _usernameMeta =
      const VerificationMeta('username');
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _passwordHashMeta =
      const VerificationMeta('passwordHash');
  @override
  late final GeneratedColumn<String> passwordHash = GeneratedColumn<String>(
      'password_hash', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _lastLoginMeta =
      const VerificationMeta('lastLogin');
  @override
  late final GeneratedColumn<DateTime> lastLogin = GeneratedColumn<DateTime>(
      'last_login', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, username, passwordHash, role, createdAt, lastLogin, isActive];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'att_users';
  @override
  VerificationContext validateIntegrity(Insertable<AttUser> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('password_hash')) {
      context.handle(
          _passwordHashMeta,
          passwordHash.isAcceptableOrUnknown(
              data['password_hash']!, _passwordHashMeta));
    } else if (isInserting) {
      context.missing(_passwordHashMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('last_login')) {
      context.handle(_lastLoginMeta,
          lastLogin.isAcceptableOrUnknown(data['last_login']!, _lastLoginMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AttUser map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AttUser(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      username: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}username'])!,
      passwordHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}password_hash'])!,
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      lastLogin: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_login']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $AttUsersTable createAlias(String alias) {
    return $AttUsersTable(attachedDatabase, alias);
  }
}

class AttUser extends DataClass implements Insertable<AttUser> {
  final int id;
  final String name;
  final String username;
  final String passwordHash;
  final String role;
  final DateTime createdAt;
  final DateTime? lastLogin;
  final bool isActive;
  const AttUser(
      {required this.id,
      required this.name,
      required this.username,
      required this.passwordHash,
      required this.role,
      required this.createdAt,
      this.lastLogin,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['username'] = Variable<String>(username);
    map['password_hash'] = Variable<String>(passwordHash);
    map['role'] = Variable<String>(role);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || lastLogin != null) {
      map['last_login'] = Variable<DateTime>(lastLogin);
    }
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  AttUsersCompanion toCompanion(bool nullToAbsent) {
    return AttUsersCompanion(
      id: Value(id),
      name: Value(name),
      username: Value(username),
      passwordHash: Value(passwordHash),
      role: Value(role),
      createdAt: Value(createdAt),
      lastLogin: lastLogin == null && nullToAbsent
          ? const Value.absent()
          : Value(lastLogin),
      isActive: Value(isActive),
    );
  }

  factory AttUser.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AttUser(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      username: serializer.fromJson<String>(json['username']),
      passwordHash: serializer.fromJson<String>(json['passwordHash']),
      role: serializer.fromJson<String>(json['role']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastLogin: serializer.fromJson<DateTime?>(json['lastLogin']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'username': serializer.toJson<String>(username),
      'passwordHash': serializer.toJson<String>(passwordHash),
      'role': serializer.toJson<String>(role),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastLogin': serializer.toJson<DateTime?>(lastLogin),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  AttUser copyWith(
          {int? id,
          String? name,
          String? username,
          String? passwordHash,
          String? role,
          DateTime? createdAt,
          Value<DateTime?> lastLogin = const Value.absent(),
          bool? isActive}) =>
      AttUser(
        id: id ?? this.id,
        name: name ?? this.name,
        username: username ?? this.username,
        passwordHash: passwordHash ?? this.passwordHash,
        role: role ?? this.role,
        createdAt: createdAt ?? this.createdAt,
        lastLogin: lastLogin.present ? lastLogin.value : this.lastLogin,
        isActive: isActive ?? this.isActive,
      );
  AttUser copyWithCompanion(AttUsersCompanion data) {
    return AttUser(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      username: data.username.present ? data.username.value : this.username,
      passwordHash: data.passwordHash.present
          ? data.passwordHash.value
          : this.passwordHash,
      role: data.role.present ? data.role.value : this.role,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastLogin: data.lastLogin.present ? data.lastLogin.value : this.lastLogin,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AttUser(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('username: $username, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('role: $role, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastLogin: $lastLogin, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, name, username, passwordHash, role, createdAt, lastLogin, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AttUser &&
          other.id == this.id &&
          other.name == this.name &&
          other.username == this.username &&
          other.passwordHash == this.passwordHash &&
          other.role == this.role &&
          other.createdAt == this.createdAt &&
          other.lastLogin == this.lastLogin &&
          other.isActive == this.isActive);
}

class AttUsersCompanion extends UpdateCompanion<AttUser> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> username;
  final Value<String> passwordHash;
  final Value<String> role;
  final Value<DateTime> createdAt;
  final Value<DateTime?> lastLogin;
  final Value<bool> isActive;
  const AttUsersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.username = const Value.absent(),
    this.passwordHash = const Value.absent(),
    this.role = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastLogin = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  AttUsersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String username,
    required String passwordHash,
    required String role,
    this.createdAt = const Value.absent(),
    this.lastLogin = const Value.absent(),
    this.isActive = const Value.absent(),
  })  : name = Value(name),
        username = Value(username),
        passwordHash = Value(passwordHash),
        role = Value(role);
  static Insertable<AttUser> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? username,
    Expression<String>? passwordHash,
    Expression<String>? role,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastLogin,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (username != null) 'username': username,
      if (passwordHash != null) 'password_hash': passwordHash,
      if (role != null) 'role': role,
      if (createdAt != null) 'created_at': createdAt,
      if (lastLogin != null) 'last_login': lastLogin,
      if (isActive != null) 'is_active': isActive,
    });
  }

  AttUsersCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? username,
      Value<String>? passwordHash,
      Value<String>? role,
      Value<DateTime>? createdAt,
      Value<DateTime?>? lastLogin,
      Value<bool>? isActive}) {
    return AttUsersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      passwordHash: passwordHash ?? this.passwordHash,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (passwordHash.present) {
      map['password_hash'] = Variable<String>(passwordHash.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastLogin.present) {
      map['last_login'] = Variable<DateTime>(lastLogin.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttUsersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('username: $username, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('role: $role, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastLogin: $lastLogin, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $AttStagesTable extends AttStages
    with TableInfo<$AttStagesTable, AttStage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttStagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [id, name, sortOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'att_stages';
  @override
  VerificationContext validateIntegrity(Insertable<AttStage> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AttStage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AttStage(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
    );
  }

  @override
  $AttStagesTable createAlias(String alias) {
    return $AttStagesTable(attachedDatabase, alias);
  }
}

class AttStage extends DataClass implements Insertable<AttStage> {
  final int id;
  final String name;
  final int sortOrder;
  const AttStage(
      {required this.id, required this.name, required this.sortOrder});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  AttStagesCompanion toCompanion(bool nullToAbsent) {
    return AttStagesCompanion(
      id: Value(id),
      name: Value(name),
      sortOrder: Value(sortOrder),
    );
  }

  factory AttStage.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AttStage(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  AttStage copyWith({int? id, String? name, int? sortOrder}) => AttStage(
        id: id ?? this.id,
        name: name ?? this.name,
        sortOrder: sortOrder ?? this.sortOrder,
      );
  AttStage copyWithCompanion(AttStagesCompanion data) {
    return AttStage(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AttStage(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AttStage &&
          other.id == this.id &&
          other.name == this.name &&
          other.sortOrder == this.sortOrder);
}

class AttStagesCompanion extends UpdateCompanion<AttStage> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> sortOrder;
  const AttStagesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  AttStagesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.sortOrder = const Value.absent(),
  }) : name = Value(name);
  static Insertable<AttStage> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  AttStagesCompanion copyWith(
      {Value<int>? id, Value<String>? name, Value<int>? sortOrder}) {
    return AttStagesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttStagesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

class $AttGradesTable extends AttGrades
    with TableInfo<$AttGradesTable, AttGrade> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttGradesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _stageIdMeta =
      const VerificationMeta('stageId');
  @override
  late final GeneratedColumn<int> stageId = GeneratedColumn<int>(
      'stage_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES att_stages (id)'));
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [id, name, stageId, sortOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'att_grades';
  @override
  VerificationContext validateIntegrity(Insertable<AttGrade> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('stage_id')) {
      context.handle(_stageIdMeta,
          stageId.isAcceptableOrUnknown(data['stage_id']!, _stageIdMeta));
    } else if (isInserting) {
      context.missing(_stageIdMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {name, stageId},
      ];
  @override
  AttGrade map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AttGrade(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      stageId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}stage_id'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
    );
  }

  @override
  $AttGradesTable createAlias(String alias) {
    return $AttGradesTable(attachedDatabase, alias);
  }
}

class AttGrade extends DataClass implements Insertable<AttGrade> {
  final int id;
  final String name;
  final int stageId;
  final int sortOrder;
  const AttGrade(
      {required this.id,
      required this.name,
      required this.stageId,
      required this.sortOrder});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['stage_id'] = Variable<int>(stageId);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  AttGradesCompanion toCompanion(bool nullToAbsent) {
    return AttGradesCompanion(
      id: Value(id),
      name: Value(name),
      stageId: Value(stageId),
      sortOrder: Value(sortOrder),
    );
  }

  factory AttGrade.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AttGrade(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      stageId: serializer.fromJson<int>(json['stageId']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'stageId': serializer.toJson<int>(stageId),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  AttGrade copyWith({int? id, String? name, int? stageId, int? sortOrder}) =>
      AttGrade(
        id: id ?? this.id,
        name: name ?? this.name,
        stageId: stageId ?? this.stageId,
        sortOrder: sortOrder ?? this.sortOrder,
      );
  AttGrade copyWithCompanion(AttGradesCompanion data) {
    return AttGrade(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      stageId: data.stageId.present ? data.stageId.value : this.stageId,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AttGrade(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('stageId: $stageId, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, stageId, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AttGrade &&
          other.id == this.id &&
          other.name == this.name &&
          other.stageId == this.stageId &&
          other.sortOrder == this.sortOrder);
}

class AttGradesCompanion extends UpdateCompanion<AttGrade> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> stageId;
  final Value<int> sortOrder;
  const AttGradesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.stageId = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  AttGradesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int stageId,
    this.sortOrder = const Value.absent(),
  })  : name = Value(name),
        stageId = Value(stageId);
  static Insertable<AttGrade> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? stageId,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (stageId != null) 'stage_id': stageId,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  AttGradesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<int>? stageId,
      Value<int>? sortOrder}) {
    return AttGradesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      stageId: stageId ?? this.stageId,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (stageId.present) {
      map['stage_id'] = Variable<int>(stageId.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttGradesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('stageId: $stageId, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

class $AttSectionsTable extends AttSections
    with TableInfo<$AttSectionsTable, AttSection> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttSectionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _gradeIdMeta =
      const VerificationMeta('gradeId');
  @override
  late final GeneratedColumn<int> gradeId = GeneratedColumn<int>(
      'grade_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES att_grades (id)'));
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [id, name, gradeId, sortOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'att_sections';
  @override
  VerificationContext validateIntegrity(Insertable<AttSection> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('grade_id')) {
      context.handle(_gradeIdMeta,
          gradeId.isAcceptableOrUnknown(data['grade_id']!, _gradeIdMeta));
    } else if (isInserting) {
      context.missing(_gradeIdMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {name, gradeId},
      ];
  @override
  AttSection map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AttSection(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      gradeId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}grade_id'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
    );
  }

  @override
  $AttSectionsTable createAlias(String alias) {
    return $AttSectionsTable(attachedDatabase, alias);
  }
}

class AttSection extends DataClass implements Insertable<AttSection> {
  final int id;
  final String name;
  final int gradeId;
  final int sortOrder;
  const AttSection(
      {required this.id,
      required this.name,
      required this.gradeId,
      required this.sortOrder});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['grade_id'] = Variable<int>(gradeId);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  AttSectionsCompanion toCompanion(bool nullToAbsent) {
    return AttSectionsCompanion(
      id: Value(id),
      name: Value(name),
      gradeId: Value(gradeId),
      sortOrder: Value(sortOrder),
    );
  }

  factory AttSection.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AttSection(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      gradeId: serializer.fromJson<int>(json['gradeId']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'gradeId': serializer.toJson<int>(gradeId),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  AttSection copyWith({int? id, String? name, int? gradeId, int? sortOrder}) =>
      AttSection(
        id: id ?? this.id,
        name: name ?? this.name,
        gradeId: gradeId ?? this.gradeId,
        sortOrder: sortOrder ?? this.sortOrder,
      );
  AttSection copyWithCompanion(AttSectionsCompanion data) {
    return AttSection(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      gradeId: data.gradeId.present ? data.gradeId.value : this.gradeId,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AttSection(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('gradeId: $gradeId, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, gradeId, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AttSection &&
          other.id == this.id &&
          other.name == this.name &&
          other.gradeId == this.gradeId &&
          other.sortOrder == this.sortOrder);
}

class AttSectionsCompanion extends UpdateCompanion<AttSection> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> gradeId;
  final Value<int> sortOrder;
  const AttSectionsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.gradeId = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  AttSectionsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int gradeId,
    this.sortOrder = const Value.absent(),
  })  : name = Value(name),
        gradeId = Value(gradeId);
  static Insertable<AttSection> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? gradeId,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (gradeId != null) 'grade_id': gradeId,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  AttSectionsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<int>? gradeId,
      Value<int>? sortOrder}) {
    return AttSectionsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      gradeId: gradeId ?? this.gradeId,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (gradeId.present) {
      map['grade_id'] = Variable<int>(gradeId.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttSectionsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('gradeId: $gradeId, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

class $AttSubjectsTable extends AttSubjects
    with TableInfo<$AttSubjectsTable, AttSubject> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttSubjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _gradeIdMeta =
      const VerificationMeta('gradeId');
  @override
  late final GeneratedColumn<int> gradeId = GeneratedColumn<int>(
      'grade_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES att_grades (id)'));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [id, name, gradeId, isActive];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'att_subjects';
  @override
  VerificationContext validateIntegrity(Insertable<AttSubject> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('grade_id')) {
      context.handle(_gradeIdMeta,
          gradeId.isAcceptableOrUnknown(data['grade_id']!, _gradeIdMeta));
    } else if (isInserting) {
      context.missing(_gradeIdMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {name, gradeId},
      ];
  @override
  AttSubject map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AttSubject(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      gradeId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}grade_id'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $AttSubjectsTable createAlias(String alias) {
    return $AttSubjectsTable(attachedDatabase, alias);
  }
}

class AttSubject extends DataClass implements Insertable<AttSubject> {
  final int id;
  final String name;
  final int gradeId;
  final bool isActive;
  const AttSubject(
      {required this.id,
      required this.name,
      required this.gradeId,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['grade_id'] = Variable<int>(gradeId);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  AttSubjectsCompanion toCompanion(bool nullToAbsent) {
    return AttSubjectsCompanion(
      id: Value(id),
      name: Value(name),
      gradeId: Value(gradeId),
      isActive: Value(isActive),
    );
  }

  factory AttSubject.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AttSubject(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      gradeId: serializer.fromJson<int>(json['gradeId']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'gradeId': serializer.toJson<int>(gradeId),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  AttSubject copyWith({int? id, String? name, int? gradeId, bool? isActive}) =>
      AttSubject(
        id: id ?? this.id,
        name: name ?? this.name,
        gradeId: gradeId ?? this.gradeId,
        isActive: isActive ?? this.isActive,
      );
  AttSubject copyWithCompanion(AttSubjectsCompanion data) {
    return AttSubject(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      gradeId: data.gradeId.present ? data.gradeId.value : this.gradeId,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AttSubject(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('gradeId: $gradeId, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, gradeId, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AttSubject &&
          other.id == this.id &&
          other.name == this.name &&
          other.gradeId == this.gradeId &&
          other.isActive == this.isActive);
}

class AttSubjectsCompanion extends UpdateCompanion<AttSubject> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> gradeId;
  final Value<bool> isActive;
  const AttSubjectsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.gradeId = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  AttSubjectsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int gradeId,
    this.isActive = const Value.absent(),
  })  : name = Value(name),
        gradeId = Value(gradeId);
  static Insertable<AttSubject> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? gradeId,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (gradeId != null) 'grade_id': gradeId,
      if (isActive != null) 'is_active': isActive,
    });
  }

  AttSubjectsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<int>? gradeId,
      Value<bool>? isActive}) {
    return AttSubjectsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      gradeId: gradeId ?? this.gradeId,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (gradeId.present) {
      map['grade_id'] = Variable<int>(gradeId.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttSubjectsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('gradeId: $gradeId, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $AttSessionsTable extends AttSessions
    with TableInfo<$AttSessionsTable, AttSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _gradeIdMeta =
      const VerificationMeta('gradeId');
  @override
  late final GeneratedColumn<int> gradeId = GeneratedColumn<int>(
      'grade_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES att_grades (id)'));
  static const VerificationMeta _sectionIdMeta =
      const VerificationMeta('sectionId');
  @override
  late final GeneratedColumn<int> sectionId = GeneratedColumn<int>(
      'section_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES att_sections (id)'));
  static const VerificationMeta _subjectIdMeta =
      const VerificationMeta('subjectId');
  @override
  late final GeneratedColumn<int> subjectId = GeneratedColumn<int>(
      'subject_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES att_subjects (id)'));
  static const VerificationMeta _periodNumberMeta =
      const VerificationMeta('periodNumber');
  @override
  late final GeneratedColumn<int> periodNumber = GeneratedColumn<int>(
      'period_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _teacherIdMeta =
      const VerificationMeta('teacherId');
  @override
  late final GeneratedColumn<int> teacherId = GeneratedColumn<int>(
      'teacher_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES att_users (id)'));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('active'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _closedAtMeta =
      const VerificationMeta('closedAt');
  @override
  late final GeneratedColumn<DateTime> closedAt = GeneratedColumn<DateTime>(
      'closed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        date,
        gradeId,
        sectionId,
        subjectId,
        periodNumber,
        teacherId,
        status,
        createdAt,
        closedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'att_sessions';
  @override
  VerificationContext validateIntegrity(Insertable<AttSession> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('grade_id')) {
      context.handle(_gradeIdMeta,
          gradeId.isAcceptableOrUnknown(data['grade_id']!, _gradeIdMeta));
    } else if (isInserting) {
      context.missing(_gradeIdMeta);
    }
    if (data.containsKey('section_id')) {
      context.handle(_sectionIdMeta,
          sectionId.isAcceptableOrUnknown(data['section_id']!, _sectionIdMeta));
    } else if (isInserting) {
      context.missing(_sectionIdMeta);
    }
    if (data.containsKey('subject_id')) {
      context.handle(_subjectIdMeta,
          subjectId.isAcceptableOrUnknown(data['subject_id']!, _subjectIdMeta));
    } else if (isInserting) {
      context.missing(_subjectIdMeta);
    }
    if (data.containsKey('period_number')) {
      context.handle(
          _periodNumberMeta,
          periodNumber.isAcceptableOrUnknown(
              data['period_number']!, _periodNumberMeta));
    } else if (isInserting) {
      context.missing(_periodNumberMeta);
    }
    if (data.containsKey('teacher_id')) {
      context.handle(_teacherIdMeta,
          teacherId.isAcceptableOrUnknown(data['teacher_id']!, _teacherIdMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('closed_at')) {
      context.handle(_closedAtMeta,
          closedAt.isAcceptableOrUnknown(data['closed_at']!, _closedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {date, gradeId, sectionId, subjectId, periodNumber},
      ];
  @override
  AttSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AttSession(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      gradeId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}grade_id'])!,
      sectionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}section_id'])!,
      subjectId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}subject_id'])!,
      periodNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}period_number'])!,
      teacherId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}teacher_id']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      closedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}closed_at']),
    );
  }

  @override
  $AttSessionsTable createAlias(String alias) {
    return $AttSessionsTable(attachedDatabase, alias);
  }
}

class AttSession extends DataClass implements Insertable<AttSession> {
  final int id;
  final DateTime date;
  final int gradeId;
  final int sectionId;
  final int subjectId;
  final int periodNumber;
  final int? teacherId;
  final String status;
  final DateTime createdAt;
  final DateTime? closedAt;
  const AttSession(
      {required this.id,
      required this.date,
      required this.gradeId,
      required this.sectionId,
      required this.subjectId,
      required this.periodNumber,
      this.teacherId,
      required this.status,
      required this.createdAt,
      this.closedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['grade_id'] = Variable<int>(gradeId);
    map['section_id'] = Variable<int>(sectionId);
    map['subject_id'] = Variable<int>(subjectId);
    map['period_number'] = Variable<int>(periodNumber);
    if (!nullToAbsent || teacherId != null) {
      map['teacher_id'] = Variable<int>(teacherId);
    }
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || closedAt != null) {
      map['closed_at'] = Variable<DateTime>(closedAt);
    }
    return map;
  }

  AttSessionsCompanion toCompanion(bool nullToAbsent) {
    return AttSessionsCompanion(
      id: Value(id),
      date: Value(date),
      gradeId: Value(gradeId),
      sectionId: Value(sectionId),
      subjectId: Value(subjectId),
      periodNumber: Value(periodNumber),
      teacherId: teacherId == null && nullToAbsent
          ? const Value.absent()
          : Value(teacherId),
      status: Value(status),
      createdAt: Value(createdAt),
      closedAt: closedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(closedAt),
    );
  }

  factory AttSession.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AttSession(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      gradeId: serializer.fromJson<int>(json['gradeId']),
      sectionId: serializer.fromJson<int>(json['sectionId']),
      subjectId: serializer.fromJson<int>(json['subjectId']),
      periodNumber: serializer.fromJson<int>(json['periodNumber']),
      teacherId: serializer.fromJson<int?>(json['teacherId']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      closedAt: serializer.fromJson<DateTime?>(json['closedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'gradeId': serializer.toJson<int>(gradeId),
      'sectionId': serializer.toJson<int>(sectionId),
      'subjectId': serializer.toJson<int>(subjectId),
      'periodNumber': serializer.toJson<int>(periodNumber),
      'teacherId': serializer.toJson<int?>(teacherId),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'closedAt': serializer.toJson<DateTime?>(closedAt),
    };
  }

  AttSession copyWith(
          {int? id,
          DateTime? date,
          int? gradeId,
          int? sectionId,
          int? subjectId,
          int? periodNumber,
          Value<int?> teacherId = const Value.absent(),
          String? status,
          DateTime? createdAt,
          Value<DateTime?> closedAt = const Value.absent()}) =>
      AttSession(
        id: id ?? this.id,
        date: date ?? this.date,
        gradeId: gradeId ?? this.gradeId,
        sectionId: sectionId ?? this.sectionId,
        subjectId: subjectId ?? this.subjectId,
        periodNumber: periodNumber ?? this.periodNumber,
        teacherId: teacherId.present ? teacherId.value : this.teacherId,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        closedAt: closedAt.present ? closedAt.value : this.closedAt,
      );
  AttSession copyWithCompanion(AttSessionsCompanion data) {
    return AttSession(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      gradeId: data.gradeId.present ? data.gradeId.value : this.gradeId,
      sectionId: data.sectionId.present ? data.sectionId.value : this.sectionId,
      subjectId: data.subjectId.present ? data.subjectId.value : this.subjectId,
      periodNumber: data.periodNumber.present
          ? data.periodNumber.value
          : this.periodNumber,
      teacherId: data.teacherId.present ? data.teacherId.value : this.teacherId,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      closedAt: data.closedAt.present ? data.closedAt.value : this.closedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AttSession(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('gradeId: $gradeId, ')
          ..write('sectionId: $sectionId, ')
          ..write('subjectId: $subjectId, ')
          ..write('periodNumber: $periodNumber, ')
          ..write('teacherId: $teacherId, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('closedAt: $closedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, gradeId, sectionId, subjectId,
      periodNumber, teacherId, status, createdAt, closedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AttSession &&
          other.id == this.id &&
          other.date == this.date &&
          other.gradeId == this.gradeId &&
          other.sectionId == this.sectionId &&
          other.subjectId == this.subjectId &&
          other.periodNumber == this.periodNumber &&
          other.teacherId == this.teacherId &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.closedAt == this.closedAt);
}

class AttSessionsCompanion extends UpdateCompanion<AttSession> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<int> gradeId;
  final Value<int> sectionId;
  final Value<int> subjectId;
  final Value<int> periodNumber;
  final Value<int?> teacherId;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<DateTime?> closedAt;
  const AttSessionsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.gradeId = const Value.absent(),
    this.sectionId = const Value.absent(),
    this.subjectId = const Value.absent(),
    this.periodNumber = const Value.absent(),
    this.teacherId = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.closedAt = const Value.absent(),
  });
  AttSessionsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required int gradeId,
    required int sectionId,
    required int subjectId,
    required int periodNumber,
    this.teacherId = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.closedAt = const Value.absent(),
  })  : date = Value(date),
        gradeId = Value(gradeId),
        sectionId = Value(sectionId),
        subjectId = Value(subjectId),
        periodNumber = Value(periodNumber);
  static Insertable<AttSession> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<int>? gradeId,
    Expression<int>? sectionId,
    Expression<int>? subjectId,
    Expression<int>? periodNumber,
    Expression<int>? teacherId,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? closedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (gradeId != null) 'grade_id': gradeId,
      if (sectionId != null) 'section_id': sectionId,
      if (subjectId != null) 'subject_id': subjectId,
      if (periodNumber != null) 'period_number': periodNumber,
      if (teacherId != null) 'teacher_id': teacherId,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (closedAt != null) 'closed_at': closedAt,
    });
  }

  AttSessionsCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? date,
      Value<int>? gradeId,
      Value<int>? sectionId,
      Value<int>? subjectId,
      Value<int>? periodNumber,
      Value<int?>? teacherId,
      Value<String>? status,
      Value<DateTime>? createdAt,
      Value<DateTime?>? closedAt}) {
    return AttSessionsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      gradeId: gradeId ?? this.gradeId,
      sectionId: sectionId ?? this.sectionId,
      subjectId: subjectId ?? this.subjectId,
      periodNumber: periodNumber ?? this.periodNumber,
      teacherId: teacherId ?? this.teacherId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      closedAt: closedAt ?? this.closedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (gradeId.present) {
      map['grade_id'] = Variable<int>(gradeId.value);
    }
    if (sectionId.present) {
      map['section_id'] = Variable<int>(sectionId.value);
    }
    if (subjectId.present) {
      map['subject_id'] = Variable<int>(subjectId.value);
    }
    if (periodNumber.present) {
      map['period_number'] = Variable<int>(periodNumber.value);
    }
    if (teacherId.present) {
      map['teacher_id'] = Variable<int>(teacherId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (closedAt.present) {
      map['closed_at'] = Variable<DateTime>(closedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttSessionsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('gradeId: $gradeId, ')
          ..write('sectionId: $sectionId, ')
          ..write('subjectId: $subjectId, ')
          ..write('periodNumber: $periodNumber, ')
          ..write('teacherId: $teacherId, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('closedAt: $closedAt')
          ..write(')'))
        .toString();
  }
}

class $AttRecordsTable extends AttRecords
    with TableInfo<$AttRecordsTable, AttRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _studentIdMeta =
      const VerificationMeta('studentId');
  @override
  late final GeneratedColumn<int> studentId = GeneratedColumn<int>(
      'student_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES att_students (id)'));
  static const VerificationMeta _sessionIdMeta =
      const VerificationMeta('sessionId');
  @override
  late final GeneratedColumn<int> sessionId = GeneratedColumn<int>(
      'session_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES att_sessions (id)'));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _recordedAtMeta =
      const VerificationMeta('recordedAt');
  @override
  late final GeneratedColumn<DateTime> recordedAt = GeneratedColumn<DateTime>(
      'recorded_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, studentId, sessionId, status, recordedAt, notes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'att_records';
  @override
  VerificationContext validateIntegrity(Insertable<AttRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('student_id')) {
      context.handle(_studentIdMeta,
          studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta));
    } else if (isInserting) {
      context.missing(_studentIdMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(_sessionIdMeta,
          sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta));
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
          _recordedAtMeta,
          recordedAt.isAcceptableOrUnknown(
              data['recorded_at']!, _recordedAtMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {studentId, sessionId},
      ];
  @override
  AttRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AttRecord(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      studentId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}student_id'])!,
      sessionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}session_id'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      recordedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}recorded_at'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
    );
  }

  @override
  $AttRecordsTable createAlias(String alias) {
    return $AttRecordsTable(attachedDatabase, alias);
  }
}

class AttRecord extends DataClass implements Insertable<AttRecord> {
  final int id;
  final int studentId;
  final int sessionId;
  final String status;
  final DateTime recordedAt;
  final String? notes;
  const AttRecord(
      {required this.id,
      required this.studentId,
      required this.sessionId,
      required this.status,
      required this.recordedAt,
      this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['student_id'] = Variable<int>(studentId);
    map['session_id'] = Variable<int>(sessionId);
    map['status'] = Variable<String>(status);
    map['recorded_at'] = Variable<DateTime>(recordedAt);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  AttRecordsCompanion toCompanion(bool nullToAbsent) {
    return AttRecordsCompanion(
      id: Value(id),
      studentId: Value(studentId),
      sessionId: Value(sessionId),
      status: Value(status),
      recordedAt: Value(recordedAt),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
    );
  }

  factory AttRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AttRecord(
      id: serializer.fromJson<int>(json['id']),
      studentId: serializer.fromJson<int>(json['studentId']),
      sessionId: serializer.fromJson<int>(json['sessionId']),
      status: serializer.fromJson<String>(json['status']),
      recordedAt: serializer.fromJson<DateTime>(json['recordedAt']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'studentId': serializer.toJson<int>(studentId),
      'sessionId': serializer.toJson<int>(sessionId),
      'status': serializer.toJson<String>(status),
      'recordedAt': serializer.toJson<DateTime>(recordedAt),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  AttRecord copyWith(
          {int? id,
          int? studentId,
          int? sessionId,
          String? status,
          DateTime? recordedAt,
          Value<String?> notes = const Value.absent()}) =>
      AttRecord(
        id: id ?? this.id,
        studentId: studentId ?? this.studentId,
        sessionId: sessionId ?? this.sessionId,
        status: status ?? this.status,
        recordedAt: recordedAt ?? this.recordedAt,
        notes: notes.present ? notes.value : this.notes,
      );
  AttRecord copyWithCompanion(AttRecordsCompanion data) {
    return AttRecord(
      id: data.id.present ? data.id.value : this.id,
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      status: data.status.present ? data.status.value : this.status,
      recordedAt:
          data.recordedAt.present ? data.recordedAt.value : this.recordedAt,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AttRecord(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('sessionId: $sessionId, ')
          ..write('status: $status, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, studentId, sessionId, status, recordedAt, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AttRecord &&
          other.id == this.id &&
          other.studentId == this.studentId &&
          other.sessionId == this.sessionId &&
          other.status == this.status &&
          other.recordedAt == this.recordedAt &&
          other.notes == this.notes);
}

class AttRecordsCompanion extends UpdateCompanion<AttRecord> {
  final Value<int> id;
  final Value<int> studentId;
  final Value<int> sessionId;
  final Value<String> status;
  final Value<DateTime> recordedAt;
  final Value<String?> notes;
  const AttRecordsCompanion({
    this.id = const Value.absent(),
    this.studentId = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.status = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.notes = const Value.absent(),
  });
  AttRecordsCompanion.insert({
    this.id = const Value.absent(),
    required int studentId,
    required int sessionId,
    required String status,
    this.recordedAt = const Value.absent(),
    this.notes = const Value.absent(),
  })  : studentId = Value(studentId),
        sessionId = Value(sessionId),
        status = Value(status);
  static Insertable<AttRecord> custom({
    Expression<int>? id,
    Expression<int>? studentId,
    Expression<int>? sessionId,
    Expression<String>? status,
    Expression<DateTime>? recordedAt,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (studentId != null) 'student_id': studentId,
      if (sessionId != null) 'session_id': sessionId,
      if (status != null) 'status': status,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (notes != null) 'notes': notes,
    });
  }

  AttRecordsCompanion copyWith(
      {Value<int>? id,
      Value<int>? studentId,
      Value<int>? sessionId,
      Value<String>? status,
      Value<DateTime>? recordedAt,
      Value<String?>? notes}) {
    return AttRecordsCompanion(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      sessionId: sessionId ?? this.sessionId,
      status: status ?? this.status,
      recordedAt: recordedAt ?? this.recordedAt,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (studentId.present) {
      map['student_id'] = Variable<int>(studentId.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<int>(sessionId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<DateTime>(recordedAt.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttRecordsCompanion(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('sessionId: $sessionId, ')
          ..write('status: $status, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $AuditLogTable extends AuditLog
    with TableInfo<$AuditLogTable, AuditEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuditLogTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES att_users (id)'));
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
      'action', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _targetTableMeta =
      const VerificationMeta('targetTable');
  @override
  late final GeneratedColumn<String> targetTable = GeneratedColumn<String>(
      'target_table', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _recordIdMeta =
      const VerificationMeta('recordId');
  @override
  late final GeneratedColumn<int> recordId = GeneratedColumn<int>(
      'record_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _oldValueMeta =
      const VerificationMeta('oldValue');
  @override
  late final GeneratedColumn<String> oldValue = GeneratedColumn<String>(
      'old_value', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _newValueMeta =
      const VerificationMeta('newValue');
  @override
  late final GeneratedColumn<String> newValue = GeneratedColumn<String>(
      'new_value', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        action,
        targetTable,
        recordId,
        oldValue,
        newValue,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'audit_log';
  @override
  VerificationContext validateIntegrity(Insertable<AuditEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    }
    if (data.containsKey('action')) {
      context.handle(_actionMeta,
          action.isAcceptableOrUnknown(data['action']!, _actionMeta));
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('target_table')) {
      context.handle(
          _targetTableMeta,
          targetTable.isAcceptableOrUnknown(
              data['target_table']!, _targetTableMeta));
    } else if (isInserting) {
      context.missing(_targetTableMeta);
    }
    if (data.containsKey('record_id')) {
      context.handle(_recordIdMeta,
          recordId.isAcceptableOrUnknown(data['record_id']!, _recordIdMeta));
    } else if (isInserting) {
      context.missing(_recordIdMeta);
    }
    if (data.containsKey('old_value')) {
      context.handle(_oldValueMeta,
          oldValue.isAcceptableOrUnknown(data['old_value']!, _oldValueMeta));
    }
    if (data.containsKey('new_value')) {
      context.handle(_newValueMeta,
          newValue.isAcceptableOrUnknown(data['new_value']!, _newValueMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AuditEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuditEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id']),
      action: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}action'])!,
      targetTable: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}target_table'])!,
      recordId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}record_id'])!,
      oldValue: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}old_value']),
      newValue: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}new_value']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $AuditLogTable createAlias(String alias) {
    return $AuditLogTable(attachedDatabase, alias);
  }
}

class AuditEntry extends DataClass implements Insertable<AuditEntry> {
  final int id;
  final int? userId;
  final String action;
  final String targetTable;
  final int recordId;
  final String? oldValue;
  final String? newValue;
  final DateTime createdAt;
  const AuditEntry(
      {required this.id,
      this.userId,
      required this.action,
      required this.targetTable,
      required this.recordId,
      this.oldValue,
      this.newValue,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<int>(userId);
    }
    map['action'] = Variable<String>(action);
    map['target_table'] = Variable<String>(targetTable);
    map['record_id'] = Variable<int>(recordId);
    if (!nullToAbsent || oldValue != null) {
      map['old_value'] = Variable<String>(oldValue);
    }
    if (!nullToAbsent || newValue != null) {
      map['new_value'] = Variable<String>(newValue);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AuditLogCompanion toCompanion(bool nullToAbsent) {
    return AuditLogCompanion(
      id: Value(id),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      action: Value(action),
      targetTable: Value(targetTable),
      recordId: Value(recordId),
      oldValue: oldValue == null && nullToAbsent
          ? const Value.absent()
          : Value(oldValue),
      newValue: newValue == null && nullToAbsent
          ? const Value.absent()
          : Value(newValue),
      createdAt: Value(createdAt),
    );
  }

  factory AuditEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuditEntry(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int?>(json['userId']),
      action: serializer.fromJson<String>(json['action']),
      targetTable: serializer.fromJson<String>(json['targetTable']),
      recordId: serializer.fromJson<int>(json['recordId']),
      oldValue: serializer.fromJson<String?>(json['oldValue']),
      newValue: serializer.fromJson<String?>(json['newValue']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int?>(userId),
      'action': serializer.toJson<String>(action),
      'targetTable': serializer.toJson<String>(targetTable),
      'recordId': serializer.toJson<int>(recordId),
      'oldValue': serializer.toJson<String?>(oldValue),
      'newValue': serializer.toJson<String?>(newValue),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  AuditEntry copyWith(
          {int? id,
          Value<int?> userId = const Value.absent(),
          String? action,
          String? targetTable,
          int? recordId,
          Value<String?> oldValue = const Value.absent(),
          Value<String?> newValue = const Value.absent(),
          DateTime? createdAt}) =>
      AuditEntry(
        id: id ?? this.id,
        userId: userId.present ? userId.value : this.userId,
        action: action ?? this.action,
        targetTable: targetTable ?? this.targetTable,
        recordId: recordId ?? this.recordId,
        oldValue: oldValue.present ? oldValue.value : this.oldValue,
        newValue: newValue.present ? newValue.value : this.newValue,
        createdAt: createdAt ?? this.createdAt,
      );
  AuditEntry copyWithCompanion(AuditLogCompanion data) {
    return AuditEntry(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      action: data.action.present ? data.action.value : this.action,
      targetTable:
          data.targetTable.present ? data.targetTable.value : this.targetTable,
      recordId: data.recordId.present ? data.recordId.value : this.recordId,
      oldValue: data.oldValue.present ? data.oldValue.value : this.oldValue,
      newValue: data.newValue.present ? data.newValue.value : this.newValue,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuditEntry(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('action: $action, ')
          ..write('targetTable: $targetTable, ')
          ..write('recordId: $recordId, ')
          ..write('oldValue: $oldValue, ')
          ..write('newValue: $newValue, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, userId, action, targetTable, recordId, oldValue, newValue, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuditEntry &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.action == this.action &&
          other.targetTable == this.targetTable &&
          other.recordId == this.recordId &&
          other.oldValue == this.oldValue &&
          other.newValue == this.newValue &&
          other.createdAt == this.createdAt);
}

class AuditLogCompanion extends UpdateCompanion<AuditEntry> {
  final Value<int> id;
  final Value<int?> userId;
  final Value<String> action;
  final Value<String> targetTable;
  final Value<int> recordId;
  final Value<String?> oldValue;
  final Value<String?> newValue;
  final Value<DateTime> createdAt;
  const AuditLogCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.action = const Value.absent(),
    this.targetTable = const Value.absent(),
    this.recordId = const Value.absent(),
    this.oldValue = const Value.absent(),
    this.newValue = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  AuditLogCompanion.insert({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    required String action,
    required String targetTable,
    required int recordId,
    this.oldValue = const Value.absent(),
    this.newValue = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : action = Value(action),
        targetTable = Value(targetTable),
        recordId = Value(recordId);
  static Insertable<AuditEntry> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<String>? action,
    Expression<String>? targetTable,
    Expression<int>? recordId,
    Expression<String>? oldValue,
    Expression<String>? newValue,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (action != null) 'action': action,
      if (targetTable != null) 'target_table': targetTable,
      if (recordId != null) 'record_id': recordId,
      if (oldValue != null) 'old_value': oldValue,
      if (newValue != null) 'new_value': newValue,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  AuditLogCompanion copyWith(
      {Value<int>? id,
      Value<int?>? userId,
      Value<String>? action,
      Value<String>? targetTable,
      Value<int>? recordId,
      Value<String?>? oldValue,
      Value<String?>? newValue,
      Value<DateTime>? createdAt}) {
    return AuditLogCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      action: action ?? this.action,
      targetTable: targetTable ?? this.targetTable,
      recordId: recordId ?? this.recordId,
      oldValue: oldValue ?? this.oldValue,
      newValue: newValue ?? this.newValue,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (targetTable.present) {
      map['target_table'] = Variable<String>(targetTable.value);
    }
    if (recordId.present) {
      map['record_id'] = Variable<int>(recordId.value);
    }
    if (oldValue.present) {
      map['old_value'] = Variable<String>(oldValue.value);
    }
    if (newValue.present) {
      map['new_value'] = Variable<String>(newValue.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuditLogCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('action: $action, ')
          ..write('targetTable: $targetTable, ')
          ..write('recordId: $recordId, ')
          ..write('oldValue: $oldValue, ')
          ..write('newValue: $newValue, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $AttSettingsTable extends AttSettings
    with TableInfo<$AttSettingsTable, AttSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [id, key, value, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'att_settings';
  @override
  VerificationContext validateIntegrity(Insertable<AttSetting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AttSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AttSetting(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $AttSettingsTable createAlias(String alias) {
    return $AttSettingsTable(attachedDatabase, alias);
  }
}

class AttSetting extends DataClass implements Insertable<AttSetting> {
  final int id;
  final String key;
  final String value;
  final DateTime updatedAt;
  const AttSetting(
      {required this.id,
      required this.key,
      required this.value,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AttSettingsCompanion toCompanion(bool nullToAbsent) {
    return AttSettingsCompanion(
      id: Value(id),
      key: Value(key),
      value: Value(value),
      updatedAt: Value(updatedAt),
    );
  }

  factory AttSetting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AttSetting(
      id: serializer.fromJson<int>(json['id']),
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AttSetting copyWith(
          {int? id, String? key, String? value, DateTime? updatedAt}) =>
      AttSetting(
        id: id ?? this.id,
        key: key ?? this.key,
        value: value ?? this.value,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  AttSetting copyWithCompanion(AttSettingsCompanion data) {
    return AttSetting(
      id: data.id.present ? data.id.value : this.id,
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AttSetting(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, key, value, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AttSetting &&
          other.id == this.id &&
          other.key == this.key &&
          other.value == this.value &&
          other.updatedAt == this.updatedAt);
}

class AttSettingsCompanion extends UpdateCompanion<AttSetting> {
  final Value<int> id;
  final Value<String> key;
  final Value<String> value;
  final Value<DateTime> updatedAt;
  const AttSettingsCompanion({
    this.id = const Value.absent(),
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  AttSettingsCompanion.insert({
    this.id = const Value.absent(),
    required String key,
    required String value,
    this.updatedAt = const Value.absent(),
  })  : key = Value(key),
        value = Value(value);
  static Insertable<AttSetting> custom({
    Expression<int>? id,
    Expression<String>? key,
    Expression<String>? value,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  AttSettingsCompanion copyWith(
      {Value<int>? id,
      Value<String>? key,
      Value<String>? value,
      Value<DateTime>? updatedAt}) {
    return AttSettingsCompanion(
      id: id ?? this.id,
      key: key ?? this.key,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttSettingsCompanion(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AttendanceDatabase extends GeneratedDatabase {
  _$AttendanceDatabase(QueryExecutor e) : super(e);
  $AttendanceDatabaseManager get managers => $AttendanceDatabaseManager(this);
  late final $AttStudentsTable attStudents = $AttStudentsTable(this);
  late final $AttUsersTable attUsers = $AttUsersTable(this);
  late final $AttStagesTable attStages = $AttStagesTable(this);
  late final $AttGradesTable attGrades = $AttGradesTable(this);
  late final $AttSectionsTable attSections = $AttSectionsTable(this);
  late final $AttSubjectsTable attSubjects = $AttSubjectsTable(this);
  late final $AttSessionsTable attSessions = $AttSessionsTable(this);
  late final $AttRecordsTable attRecords = $AttRecordsTable(this);
  late final $AuditLogTable auditLog = $AuditLogTable(this);
  late final $AttSettingsTable attSettings = $AttSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        attStudents,
        attUsers,
        attStages,
        attGrades,
        attSections,
        attSubjects,
        attSessions,
        attRecords,
        auditLog,
        attSettings
      ];
}

typedef $$AttStudentsTableCreateCompanionBuilder = AttStudentsCompanion
    Function({
  Value<int> id,
  required String name,
  required String stage,
  required String grade,
  required String section,
  required String barcode,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<bool> isActive,
});
typedef $$AttStudentsTableUpdateCompanionBuilder = AttStudentsCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<String> stage,
  Value<String> grade,
  Value<String> section,
  Value<String> barcode,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<bool> isActive,
});

final class $$AttStudentsTableReferences extends BaseReferences<
    _$AttendanceDatabase, $AttStudentsTable, AttStudent> {
  $$AttStudentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$AttRecordsTable, List<AttRecord>>
      _attRecordsRefsTable(_$AttendanceDatabase db) =>
          MultiTypedResultKey.fromTable(db.attRecords,
              aliasName: $_aliasNameGenerator(
                  db.attStudents.id, db.attRecords.studentId));

  $$AttRecordsTableProcessedTableManager get attRecordsRefs {
    final manager = $$AttRecordsTableTableManager($_db, $_db.attRecords)
        .filter((f) => f.studentId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_attRecordsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$AttStudentsTableFilterComposer
    extends Composer<_$AttendanceDatabase, $AttStudentsTable> {
  $$AttStudentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get stage => $composableBuilder(
      column: $table.stage, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get grade => $composableBuilder(
      column: $table.grade, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get section => $composableBuilder(
      column: $table.section, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get barcode => $composableBuilder(
      column: $table.barcode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  Expression<bool> attRecordsRefs(
      Expression<bool> Function($$AttRecordsTableFilterComposer f) f) {
    final $$AttRecordsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.attRecords,
        getReferencedColumn: (t) => t.studentId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttRecordsTableFilterComposer(
              $db: $db,
              $table: $db.attRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$AttStudentsTableOrderingComposer
    extends Composer<_$AttendanceDatabase, $AttStudentsTable> {
  $$AttStudentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get stage => $composableBuilder(
      column: $table.stage, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get grade => $composableBuilder(
      column: $table.grade, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get section => $composableBuilder(
      column: $table.section, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get barcode => $composableBuilder(
      column: $table.barcode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));
}

class $$AttStudentsTableAnnotationComposer
    extends Composer<_$AttendanceDatabase, $AttStudentsTable> {
  $$AttStudentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get stage =>
      $composableBuilder(column: $table.stage, builder: (column) => column);

  GeneratedColumn<String> get grade =>
      $composableBuilder(column: $table.grade, builder: (column) => column);

  GeneratedColumn<String> get section =>
      $composableBuilder(column: $table.section, builder: (column) => column);

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  Expression<T> attRecordsRefs<T extends Object>(
      Expression<T> Function($$AttRecordsTableAnnotationComposer a) f) {
    final $$AttRecordsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.attRecords,
        getReferencedColumn: (t) => t.studentId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttRecordsTableAnnotationComposer(
              $db: $db,
              $table: $db.attRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$AttStudentsTableTableManager extends RootTableManager<
    _$AttendanceDatabase,
    $AttStudentsTable,
    AttStudent,
    $$AttStudentsTableFilterComposer,
    $$AttStudentsTableOrderingComposer,
    $$AttStudentsTableAnnotationComposer,
    $$AttStudentsTableCreateCompanionBuilder,
    $$AttStudentsTableUpdateCompanionBuilder,
    (AttStudent, $$AttStudentsTableReferences),
    AttStudent,
    PrefetchHooks Function({bool attRecordsRefs})> {
  $$AttStudentsTableTableManager(
      _$AttendanceDatabase db, $AttStudentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AttStudentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AttStudentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AttStudentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> stage = const Value.absent(),
            Value<String> grade = const Value.absent(),
            Value<String> section = const Value.absent(),
            Value<String> barcode = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              AttStudentsCompanion(
            id: id,
            name: name,
            stage: stage,
            grade: grade,
            section: section,
            barcode: barcode,
            notes: notes,
            createdAt: createdAt,
            isActive: isActive,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String stage,
            required String grade,
            required String section,
            required String barcode,
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              AttStudentsCompanion.insert(
            id: id,
            name: name,
            stage: stage,
            grade: grade,
            section: section,
            barcode: barcode,
            notes: notes,
            createdAt: createdAt,
            isActive: isActive,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$AttStudentsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({attRecordsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (attRecordsRefs) db.attRecords],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (attRecordsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$AttStudentsTableReferences
                            ._attRecordsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$AttStudentsTableReferences(db, table, p0)
                                .attRecordsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.studentId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$AttStudentsTableProcessedTableManager = ProcessedTableManager<
    _$AttendanceDatabase,
    $AttStudentsTable,
    AttStudent,
    $$AttStudentsTableFilterComposer,
    $$AttStudentsTableOrderingComposer,
    $$AttStudentsTableAnnotationComposer,
    $$AttStudentsTableCreateCompanionBuilder,
    $$AttStudentsTableUpdateCompanionBuilder,
    (AttStudent, $$AttStudentsTableReferences),
    AttStudent,
    PrefetchHooks Function({bool attRecordsRefs})>;
typedef $$AttUsersTableCreateCompanionBuilder = AttUsersCompanion Function({
  Value<int> id,
  required String name,
  required String username,
  required String passwordHash,
  required String role,
  Value<DateTime> createdAt,
  Value<DateTime?> lastLogin,
  Value<bool> isActive,
});
typedef $$AttUsersTableUpdateCompanionBuilder = AttUsersCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> username,
  Value<String> passwordHash,
  Value<String> role,
  Value<DateTime> createdAt,
  Value<DateTime?> lastLogin,
  Value<bool> isActive,
});

final class $$AttUsersTableReferences
    extends BaseReferences<_$AttendanceDatabase, $AttUsersTable, AttUser> {
  $$AttUsersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$AttSessionsTable, List<AttSession>>
      _attSessionsRefsTable(_$AttendanceDatabase db) =>
          MultiTypedResultKey.fromTable(db.attSessions,
              aliasName: $_aliasNameGenerator(
                  db.attUsers.id, db.attSessions.teacherId));

  $$AttSessionsTableProcessedTableManager get attSessionsRefs {
    final manager = $$AttSessionsTableTableManager($_db, $_db.attSessions)
        .filter((f) => f.teacherId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_attSessionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$AuditLogTable, List<AuditEntry>>
      _auditLogRefsTable(_$AttendanceDatabase db) =>
          MultiTypedResultKey.fromTable(db.auditLog,
              aliasName:
                  $_aliasNameGenerator(db.attUsers.id, db.auditLog.userId));

  $$AuditLogTableProcessedTableManager get auditLogRefs {
    final manager = $$AuditLogTableTableManager($_db, $_db.auditLog)
        .filter((f) => f.userId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_auditLogRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$AttUsersTableFilterComposer
    extends Composer<_$AttendanceDatabase, $AttUsersTable> {
  $$AttUsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get passwordHash => $composableBuilder(
      column: $table.passwordHash, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastLogin => $composableBuilder(
      column: $table.lastLogin, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  Expression<bool> attSessionsRefs(
      Expression<bool> Function($$AttSessionsTableFilterComposer f) f) {
    final $$AttSessionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.attSessions,
        getReferencedColumn: (t) => t.teacherId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttSessionsTableFilterComposer(
              $db: $db,
              $table: $db.attSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> auditLogRefs(
      Expression<bool> Function($$AuditLogTableFilterComposer f) f) {
    final $$AuditLogTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.auditLog,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AuditLogTableFilterComposer(
              $db: $db,
              $table: $db.auditLog,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$AttUsersTableOrderingComposer
    extends Composer<_$AttendanceDatabase, $AttUsersTable> {
  $$AttUsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get passwordHash => $composableBuilder(
      column: $table.passwordHash,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastLogin => $composableBuilder(
      column: $table.lastLogin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));
}

class $$AttUsersTableAnnotationComposer
    extends Composer<_$AttendanceDatabase, $AttUsersTable> {
  $$AttUsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get passwordHash => $composableBuilder(
      column: $table.passwordHash, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastLogin =>
      $composableBuilder(column: $table.lastLogin, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  Expression<T> attSessionsRefs<T extends Object>(
      Expression<T> Function($$AttSessionsTableAnnotationComposer a) f) {
    final $$AttSessionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.attSessions,
        getReferencedColumn: (t) => t.teacherId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttSessionsTableAnnotationComposer(
              $db: $db,
              $table: $db.attSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> auditLogRefs<T extends Object>(
      Expression<T> Function($$AuditLogTableAnnotationComposer a) f) {
    final $$AuditLogTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.auditLog,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AuditLogTableAnnotationComposer(
              $db: $db,
              $table: $db.auditLog,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$AttUsersTableTableManager extends RootTableManager<
    _$AttendanceDatabase,
    $AttUsersTable,
    AttUser,
    $$AttUsersTableFilterComposer,
    $$AttUsersTableOrderingComposer,
    $$AttUsersTableAnnotationComposer,
    $$AttUsersTableCreateCompanionBuilder,
    $$AttUsersTableUpdateCompanionBuilder,
    (AttUser, $$AttUsersTableReferences),
    AttUser,
    PrefetchHooks Function({bool attSessionsRefs, bool auditLogRefs})> {
  $$AttUsersTableTableManager(_$AttendanceDatabase db, $AttUsersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AttUsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AttUsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AttUsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> username = const Value.absent(),
            Value<String> passwordHash = const Value.absent(),
            Value<String> role = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> lastLogin = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              AttUsersCompanion(
            id: id,
            name: name,
            username: username,
            passwordHash: passwordHash,
            role: role,
            createdAt: createdAt,
            lastLogin: lastLogin,
            isActive: isActive,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String username,
            required String passwordHash,
            required String role,
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> lastLogin = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              AttUsersCompanion.insert(
            id: id,
            name: name,
            username: username,
            passwordHash: passwordHash,
            role: role,
            createdAt: createdAt,
            lastLogin: lastLogin,
            isActive: isActive,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$AttUsersTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {attSessionsRefs = false, auditLogRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (attSessionsRefs) db.attSessions,
                if (auditLogRefs) db.auditLog
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (attSessionsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$AttUsersTableReferences._attSessionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$AttUsersTableReferences(db, table, p0)
                                .attSessionsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.teacherId == item.id),
                        typedResults: items),
                  if (auditLogRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$AttUsersTableReferences._auditLogRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$AttUsersTableReferences(db, table, p0)
                                .auditLogRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.userId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$AttUsersTableProcessedTableManager = ProcessedTableManager<
    _$AttendanceDatabase,
    $AttUsersTable,
    AttUser,
    $$AttUsersTableFilterComposer,
    $$AttUsersTableOrderingComposer,
    $$AttUsersTableAnnotationComposer,
    $$AttUsersTableCreateCompanionBuilder,
    $$AttUsersTableUpdateCompanionBuilder,
    (AttUser, $$AttUsersTableReferences),
    AttUser,
    PrefetchHooks Function({bool attSessionsRefs, bool auditLogRefs})>;
typedef $$AttStagesTableCreateCompanionBuilder = AttStagesCompanion Function({
  Value<int> id,
  required String name,
  Value<int> sortOrder,
});
typedef $$AttStagesTableUpdateCompanionBuilder = AttStagesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<int> sortOrder,
});

final class $$AttStagesTableReferences
    extends BaseReferences<_$AttendanceDatabase, $AttStagesTable, AttStage> {
  $$AttStagesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$AttGradesTable, List<AttGrade>>
      _attGradesRefsTable(_$AttendanceDatabase db) =>
          MultiTypedResultKey.fromTable(db.attGrades,
              aliasName:
                  $_aliasNameGenerator(db.attStages.id, db.attGrades.stageId));

  $$AttGradesTableProcessedTableManager get attGradesRefs {
    final manager = $$AttGradesTableTableManager($_db, $_db.attGrades)
        .filter((f) => f.stageId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_attGradesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$AttStagesTableFilterComposer
    extends Composer<_$AttendanceDatabase, $AttStagesTable> {
  $$AttStagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  Expression<bool> attGradesRefs(
      Expression<bool> Function($$AttGradesTableFilterComposer f) f) {
    final $$AttGradesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.attGrades,
        getReferencedColumn: (t) => t.stageId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttGradesTableFilterComposer(
              $db: $db,
              $table: $db.attGrades,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$AttStagesTableOrderingComposer
    extends Composer<_$AttendanceDatabase, $AttStagesTable> {
  $$AttStagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));
}

class $$AttStagesTableAnnotationComposer
    extends Composer<_$AttendanceDatabase, $AttStagesTable> {
  $$AttStagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  Expression<T> attGradesRefs<T extends Object>(
      Expression<T> Function($$AttGradesTableAnnotationComposer a) f) {
    final $$AttGradesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.attGrades,
        getReferencedColumn: (t) => t.stageId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttGradesTableAnnotationComposer(
              $db: $db,
              $table: $db.attGrades,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$AttStagesTableTableManager extends RootTableManager<
    _$AttendanceDatabase,
    $AttStagesTable,
    AttStage,
    $$AttStagesTableFilterComposer,
    $$AttStagesTableOrderingComposer,
    $$AttStagesTableAnnotationComposer,
    $$AttStagesTableCreateCompanionBuilder,
    $$AttStagesTableUpdateCompanionBuilder,
    (AttStage, $$AttStagesTableReferences),
    AttStage,
    PrefetchHooks Function({bool attGradesRefs})> {
  $$AttStagesTableTableManager(_$AttendanceDatabase db, $AttStagesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AttStagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AttStagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AttStagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
          }) =>
              AttStagesCompanion(
            id: id,
            name: name,
            sortOrder: sortOrder,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<int> sortOrder = const Value.absent(),
          }) =>
              AttStagesCompanion.insert(
            id: id,
            name: name,
            sortOrder: sortOrder,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$AttStagesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({attGradesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (attGradesRefs) db.attGrades],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (attGradesRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$AttStagesTableReferences._attGradesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$AttStagesTableReferences(db, table, p0)
                                .attGradesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.stageId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$AttStagesTableProcessedTableManager = ProcessedTableManager<
    _$AttendanceDatabase,
    $AttStagesTable,
    AttStage,
    $$AttStagesTableFilterComposer,
    $$AttStagesTableOrderingComposer,
    $$AttStagesTableAnnotationComposer,
    $$AttStagesTableCreateCompanionBuilder,
    $$AttStagesTableUpdateCompanionBuilder,
    (AttStage, $$AttStagesTableReferences),
    AttStage,
    PrefetchHooks Function({bool attGradesRefs})>;
typedef $$AttGradesTableCreateCompanionBuilder = AttGradesCompanion Function({
  Value<int> id,
  required String name,
  required int stageId,
  Value<int> sortOrder,
});
typedef $$AttGradesTableUpdateCompanionBuilder = AttGradesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<int> stageId,
  Value<int> sortOrder,
});

final class $$AttGradesTableReferences
    extends BaseReferences<_$AttendanceDatabase, $AttGradesTable, AttGrade> {
  $$AttGradesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AttStagesTable _stageIdTable(_$AttendanceDatabase db) => db.attStages
      .createAlias($_aliasNameGenerator(db.attGrades.stageId, db.attStages.id));

  $$AttStagesTableProcessedTableManager get stageId {
    final manager = $$AttStagesTableTableManager($_db, $_db.attStages)
        .filter((f) => f.id($_item.stageId));
    final item = $_typedResult.readTableOrNull(_stageIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$AttSectionsTable, List<AttSection>>
      _attSectionsRefsTable(_$AttendanceDatabase db) =>
          MultiTypedResultKey.fromTable(db.attSections,
              aliasName: $_aliasNameGenerator(
                  db.attGrades.id, db.attSections.gradeId));

  $$AttSectionsTableProcessedTableManager get attSectionsRefs {
    final manager = $$AttSectionsTableTableManager($_db, $_db.attSections)
        .filter((f) => f.gradeId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_attSectionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$AttSubjectsTable, List<AttSubject>>
      _attSubjectsRefsTable(_$AttendanceDatabase db) =>
          MultiTypedResultKey.fromTable(db.attSubjects,
              aliasName: $_aliasNameGenerator(
                  db.attGrades.id, db.attSubjects.gradeId));

  $$AttSubjectsTableProcessedTableManager get attSubjectsRefs {
    final manager = $$AttSubjectsTableTableManager($_db, $_db.attSubjects)
        .filter((f) => f.gradeId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_attSubjectsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$AttSessionsTable, List<AttSession>>
      _attSessionsRefsTable(_$AttendanceDatabase db) =>
          MultiTypedResultKey.fromTable(db.attSessions,
              aliasName: $_aliasNameGenerator(
                  db.attGrades.id, db.attSessions.gradeId));

  $$AttSessionsTableProcessedTableManager get attSessionsRefs {
    final manager = $$AttSessionsTableTableManager($_db, $_db.attSessions)
        .filter((f) => f.gradeId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_attSessionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$AttGradesTableFilterComposer
    extends Composer<_$AttendanceDatabase, $AttGradesTable> {
  $$AttGradesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  $$AttStagesTableFilterComposer get stageId {
    final $$AttStagesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.stageId,
        referencedTable: $db.attStages,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttStagesTableFilterComposer(
              $db: $db,
              $table: $db.attStages,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> attSectionsRefs(
      Expression<bool> Function($$AttSectionsTableFilterComposer f) f) {
    final $$AttSectionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.attSections,
        getReferencedColumn: (t) => t.gradeId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttSectionsTableFilterComposer(
              $db: $db,
              $table: $db.attSections,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> attSubjectsRefs(
      Expression<bool> Function($$AttSubjectsTableFilterComposer f) f) {
    final $$AttSubjectsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.attSubjects,
        getReferencedColumn: (t) => t.gradeId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttSubjectsTableFilterComposer(
              $db: $db,
              $table: $db.attSubjects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> attSessionsRefs(
      Expression<bool> Function($$AttSessionsTableFilterComposer f) f) {
    final $$AttSessionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.attSessions,
        getReferencedColumn: (t) => t.gradeId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttSessionsTableFilterComposer(
              $db: $db,
              $table: $db.attSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$AttGradesTableOrderingComposer
    extends Composer<_$AttendanceDatabase, $AttGradesTable> {
  $$AttGradesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  $$AttStagesTableOrderingComposer get stageId {
    final $$AttStagesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.stageId,
        referencedTable: $db.attStages,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttStagesTableOrderingComposer(
              $db: $db,
              $table: $db.attStages,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AttGradesTableAnnotationComposer
    extends Composer<_$AttendanceDatabase, $AttGradesTable> {
  $$AttGradesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  $$AttStagesTableAnnotationComposer get stageId {
    final $$AttStagesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.stageId,
        referencedTable: $db.attStages,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttStagesTableAnnotationComposer(
              $db: $db,
              $table: $db.attStages,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> attSectionsRefs<T extends Object>(
      Expression<T> Function($$AttSectionsTableAnnotationComposer a) f) {
    final $$AttSectionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.attSections,
        getReferencedColumn: (t) => t.gradeId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttSectionsTableAnnotationComposer(
              $db: $db,
              $table: $db.attSections,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> attSubjectsRefs<T extends Object>(
      Expression<T> Function($$AttSubjectsTableAnnotationComposer a) f) {
    final $$AttSubjectsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.attSubjects,
        getReferencedColumn: (t) => t.gradeId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttSubjectsTableAnnotationComposer(
              $db: $db,
              $table: $db.attSubjects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> attSessionsRefs<T extends Object>(
      Expression<T> Function($$AttSessionsTableAnnotationComposer a) f) {
    final $$AttSessionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.attSessions,
        getReferencedColumn: (t) => t.gradeId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttSessionsTableAnnotationComposer(
              $db: $db,
              $table: $db.attSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$AttGradesTableTableManager extends RootTableManager<
    _$AttendanceDatabase,
    $AttGradesTable,
    AttGrade,
    $$AttGradesTableFilterComposer,
    $$AttGradesTableOrderingComposer,
    $$AttGradesTableAnnotationComposer,
    $$AttGradesTableCreateCompanionBuilder,
    $$AttGradesTableUpdateCompanionBuilder,
    (AttGrade, $$AttGradesTableReferences),
    AttGrade,
    PrefetchHooks Function(
        {bool stageId,
        bool attSectionsRefs,
        bool attSubjectsRefs,
        bool attSessionsRefs})> {
  $$AttGradesTableTableManager(_$AttendanceDatabase db, $AttGradesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AttGradesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AttGradesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AttGradesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> stageId = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
          }) =>
              AttGradesCompanion(
            id: id,
            name: name,
            stageId: stageId,
            sortOrder: sortOrder,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required int stageId,
            Value<int> sortOrder = const Value.absent(),
          }) =>
              AttGradesCompanion.insert(
            id: id,
            name: name,
            stageId: stageId,
            sortOrder: sortOrder,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$AttGradesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {stageId = false,
              attSectionsRefs = false,
              attSubjectsRefs = false,
              attSessionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (attSectionsRefs) db.attSections,
                if (attSubjectsRefs) db.attSubjects,
                if (attSessionsRefs) db.attSessions
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
                if (stageId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.stageId,
                    referencedTable:
                        $$AttGradesTableReferences._stageIdTable(db),
                    referencedColumn:
                        $$AttGradesTableReferences._stageIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (attSectionsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$AttGradesTableReferences
                            ._attSectionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$AttGradesTableReferences(db, table, p0)
                                .attSectionsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.gradeId == item.id),
                        typedResults: items),
                  if (attSubjectsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$AttGradesTableReferences
                            ._attSubjectsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$AttGradesTableReferences(db, table, p0)
                                .attSubjectsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.gradeId == item.id),
                        typedResults: items),
                  if (attSessionsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$AttGradesTableReferences
                            ._attSessionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$AttGradesTableReferences(db, table, p0)
                                .attSessionsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.gradeId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$AttGradesTableProcessedTableManager = ProcessedTableManager<
    _$AttendanceDatabase,
    $AttGradesTable,
    AttGrade,
    $$AttGradesTableFilterComposer,
    $$AttGradesTableOrderingComposer,
    $$AttGradesTableAnnotationComposer,
    $$AttGradesTableCreateCompanionBuilder,
    $$AttGradesTableUpdateCompanionBuilder,
    (AttGrade, $$AttGradesTableReferences),
    AttGrade,
    PrefetchHooks Function(
        {bool stageId,
        bool attSectionsRefs,
        bool attSubjectsRefs,
        bool attSessionsRefs})>;
typedef $$AttSectionsTableCreateCompanionBuilder = AttSectionsCompanion
    Function({
  Value<int> id,
  required String name,
  required int gradeId,
  Value<int> sortOrder,
});
typedef $$AttSectionsTableUpdateCompanionBuilder = AttSectionsCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<int> gradeId,
  Value<int> sortOrder,
});

final class $$AttSectionsTableReferences extends BaseReferences<
    _$AttendanceDatabase, $AttSectionsTable, AttSection> {
  $$AttSectionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AttGradesTable _gradeIdTable(_$AttendanceDatabase db) =>
      db.attGrades.createAlias(
          $_aliasNameGenerator(db.attSections.gradeId, db.attGrades.id));

  $$AttGradesTableProcessedTableManager get gradeId {
    final manager = $$AttGradesTableTableManager($_db, $_db.attGrades)
        .filter((f) => f.id($_item.gradeId));
    final item = $_typedResult.readTableOrNull(_gradeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$AttSessionsTable, List<AttSession>>
      _attSessionsRefsTable(_$AttendanceDatabase db) =>
          MultiTypedResultKey.fromTable(db.attSessions,
              aliasName: $_aliasNameGenerator(
                  db.attSections.id, db.attSessions.sectionId));

  $$AttSessionsTableProcessedTableManager get attSessionsRefs {
    final manager = $$AttSessionsTableTableManager($_db, $_db.attSessions)
        .filter((f) => f.sectionId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_attSessionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$AttSectionsTableFilterComposer
    extends Composer<_$AttendanceDatabase, $AttSectionsTable> {
  $$AttSectionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  $$AttGradesTableFilterComposer get gradeId {
    final $$AttGradesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.gradeId,
        referencedTable: $db.attGrades,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttGradesTableFilterComposer(
              $db: $db,
              $table: $db.attGrades,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> attSessionsRefs(
      Expression<bool> Function($$AttSessionsTableFilterComposer f) f) {
    final $$AttSessionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.attSessions,
        getReferencedColumn: (t) => t.sectionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttSessionsTableFilterComposer(
              $db: $db,
              $table: $db.attSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$AttSectionsTableOrderingComposer
    extends Composer<_$AttendanceDatabase, $AttSectionsTable> {
  $$AttSectionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  $$AttGradesTableOrderingComposer get gradeId {
    final $$AttGradesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.gradeId,
        referencedTable: $db.attGrades,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttGradesTableOrderingComposer(
              $db: $db,
              $table: $db.attGrades,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AttSectionsTableAnnotationComposer
    extends Composer<_$AttendanceDatabase, $AttSectionsTable> {
  $$AttSectionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  $$AttGradesTableAnnotationComposer get gradeId {
    final $$AttGradesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.gradeId,
        referencedTable: $db.attGrades,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttGradesTableAnnotationComposer(
              $db: $db,
              $table: $db.attGrades,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> attSessionsRefs<T extends Object>(
      Expression<T> Function($$AttSessionsTableAnnotationComposer a) f) {
    final $$AttSessionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.attSessions,
        getReferencedColumn: (t) => t.sectionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttSessionsTableAnnotationComposer(
              $db: $db,
              $table: $db.attSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$AttSectionsTableTableManager extends RootTableManager<
    _$AttendanceDatabase,
    $AttSectionsTable,
    AttSection,
    $$AttSectionsTableFilterComposer,
    $$AttSectionsTableOrderingComposer,
    $$AttSectionsTableAnnotationComposer,
    $$AttSectionsTableCreateCompanionBuilder,
    $$AttSectionsTableUpdateCompanionBuilder,
    (AttSection, $$AttSectionsTableReferences),
    AttSection,
    PrefetchHooks Function({bool gradeId, bool attSessionsRefs})> {
  $$AttSectionsTableTableManager(
      _$AttendanceDatabase db, $AttSectionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AttSectionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AttSectionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AttSectionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> gradeId = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
          }) =>
              AttSectionsCompanion(
            id: id,
            name: name,
            gradeId: gradeId,
            sortOrder: sortOrder,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required int gradeId,
            Value<int> sortOrder = const Value.absent(),
          }) =>
              AttSectionsCompanion.insert(
            id: id,
            name: name,
            gradeId: gradeId,
            sortOrder: sortOrder,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$AttSectionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({gradeId = false, attSessionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (attSessionsRefs) db.attSessions],
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
                if (gradeId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.gradeId,
                    referencedTable:
                        $$AttSectionsTableReferences._gradeIdTable(db),
                    referencedColumn:
                        $$AttSectionsTableReferences._gradeIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (attSessionsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$AttSectionsTableReferences
                            ._attSessionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$AttSectionsTableReferences(db, table, p0)
                                .attSessionsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.sectionId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$AttSectionsTableProcessedTableManager = ProcessedTableManager<
    _$AttendanceDatabase,
    $AttSectionsTable,
    AttSection,
    $$AttSectionsTableFilterComposer,
    $$AttSectionsTableOrderingComposer,
    $$AttSectionsTableAnnotationComposer,
    $$AttSectionsTableCreateCompanionBuilder,
    $$AttSectionsTableUpdateCompanionBuilder,
    (AttSection, $$AttSectionsTableReferences),
    AttSection,
    PrefetchHooks Function({bool gradeId, bool attSessionsRefs})>;
typedef $$AttSubjectsTableCreateCompanionBuilder = AttSubjectsCompanion
    Function({
  Value<int> id,
  required String name,
  required int gradeId,
  Value<bool> isActive,
});
typedef $$AttSubjectsTableUpdateCompanionBuilder = AttSubjectsCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<int> gradeId,
  Value<bool> isActive,
});

final class $$AttSubjectsTableReferences extends BaseReferences<
    _$AttendanceDatabase, $AttSubjectsTable, AttSubject> {
  $$AttSubjectsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AttGradesTable _gradeIdTable(_$AttendanceDatabase db) =>
      db.attGrades.createAlias(
          $_aliasNameGenerator(db.attSubjects.gradeId, db.attGrades.id));

  $$AttGradesTableProcessedTableManager get gradeId {
    final manager = $$AttGradesTableTableManager($_db, $_db.attGrades)
        .filter((f) => f.id($_item.gradeId));
    final item = $_typedResult.readTableOrNull(_gradeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$AttSessionsTable, List<AttSession>>
      _attSessionsRefsTable(_$AttendanceDatabase db) =>
          MultiTypedResultKey.fromTable(db.attSessions,
              aliasName: $_aliasNameGenerator(
                  db.attSubjects.id, db.attSessions.subjectId));

  $$AttSessionsTableProcessedTableManager get attSessionsRefs {
    final manager = $$AttSessionsTableTableManager($_db, $_db.attSessions)
        .filter((f) => f.subjectId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_attSessionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$AttSubjectsTableFilterComposer
    extends Composer<_$AttendanceDatabase, $AttSubjectsTable> {
  $$AttSubjectsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  $$AttGradesTableFilterComposer get gradeId {
    final $$AttGradesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.gradeId,
        referencedTable: $db.attGrades,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttGradesTableFilterComposer(
              $db: $db,
              $table: $db.attGrades,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> attSessionsRefs(
      Expression<bool> Function($$AttSessionsTableFilterComposer f) f) {
    final $$AttSessionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.attSessions,
        getReferencedColumn: (t) => t.subjectId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttSessionsTableFilterComposer(
              $db: $db,
              $table: $db.attSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$AttSubjectsTableOrderingComposer
    extends Composer<_$AttendanceDatabase, $AttSubjectsTable> {
  $$AttSubjectsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  $$AttGradesTableOrderingComposer get gradeId {
    final $$AttGradesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.gradeId,
        referencedTable: $db.attGrades,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttGradesTableOrderingComposer(
              $db: $db,
              $table: $db.attGrades,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AttSubjectsTableAnnotationComposer
    extends Composer<_$AttendanceDatabase, $AttSubjectsTable> {
  $$AttSubjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  $$AttGradesTableAnnotationComposer get gradeId {
    final $$AttGradesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.gradeId,
        referencedTable: $db.attGrades,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttGradesTableAnnotationComposer(
              $db: $db,
              $table: $db.attGrades,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> attSessionsRefs<T extends Object>(
      Expression<T> Function($$AttSessionsTableAnnotationComposer a) f) {
    final $$AttSessionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.attSessions,
        getReferencedColumn: (t) => t.subjectId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttSessionsTableAnnotationComposer(
              $db: $db,
              $table: $db.attSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$AttSubjectsTableTableManager extends RootTableManager<
    _$AttendanceDatabase,
    $AttSubjectsTable,
    AttSubject,
    $$AttSubjectsTableFilterComposer,
    $$AttSubjectsTableOrderingComposer,
    $$AttSubjectsTableAnnotationComposer,
    $$AttSubjectsTableCreateCompanionBuilder,
    $$AttSubjectsTableUpdateCompanionBuilder,
    (AttSubject, $$AttSubjectsTableReferences),
    AttSubject,
    PrefetchHooks Function({bool gradeId, bool attSessionsRefs})> {
  $$AttSubjectsTableTableManager(
      _$AttendanceDatabase db, $AttSubjectsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AttSubjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AttSubjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AttSubjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> gradeId = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              AttSubjectsCompanion(
            id: id,
            name: name,
            gradeId: gradeId,
            isActive: isActive,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required int gradeId,
            Value<bool> isActive = const Value.absent(),
          }) =>
              AttSubjectsCompanion.insert(
            id: id,
            name: name,
            gradeId: gradeId,
            isActive: isActive,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$AttSubjectsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({gradeId = false, attSessionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (attSessionsRefs) db.attSessions],
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
                if (gradeId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.gradeId,
                    referencedTable:
                        $$AttSubjectsTableReferences._gradeIdTable(db),
                    referencedColumn:
                        $$AttSubjectsTableReferences._gradeIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (attSessionsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$AttSubjectsTableReferences
                            ._attSessionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$AttSubjectsTableReferences(db, table, p0)
                                .attSessionsRefs,
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

typedef $$AttSubjectsTableProcessedTableManager = ProcessedTableManager<
    _$AttendanceDatabase,
    $AttSubjectsTable,
    AttSubject,
    $$AttSubjectsTableFilterComposer,
    $$AttSubjectsTableOrderingComposer,
    $$AttSubjectsTableAnnotationComposer,
    $$AttSubjectsTableCreateCompanionBuilder,
    $$AttSubjectsTableUpdateCompanionBuilder,
    (AttSubject, $$AttSubjectsTableReferences),
    AttSubject,
    PrefetchHooks Function({bool gradeId, bool attSessionsRefs})>;
typedef $$AttSessionsTableCreateCompanionBuilder = AttSessionsCompanion
    Function({
  Value<int> id,
  required DateTime date,
  required int gradeId,
  required int sectionId,
  required int subjectId,
  required int periodNumber,
  Value<int?> teacherId,
  Value<String> status,
  Value<DateTime> createdAt,
  Value<DateTime?> closedAt,
});
typedef $$AttSessionsTableUpdateCompanionBuilder = AttSessionsCompanion
    Function({
  Value<int> id,
  Value<DateTime> date,
  Value<int> gradeId,
  Value<int> sectionId,
  Value<int> subjectId,
  Value<int> periodNumber,
  Value<int?> teacherId,
  Value<String> status,
  Value<DateTime> createdAt,
  Value<DateTime?> closedAt,
});

final class $$AttSessionsTableReferences extends BaseReferences<
    _$AttendanceDatabase, $AttSessionsTable, AttSession> {
  $$AttSessionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AttGradesTable _gradeIdTable(_$AttendanceDatabase db) =>
      db.attGrades.createAlias(
          $_aliasNameGenerator(db.attSessions.gradeId, db.attGrades.id));

  $$AttGradesTableProcessedTableManager get gradeId {
    final manager = $$AttGradesTableTableManager($_db, $_db.attGrades)
        .filter((f) => f.id($_item.gradeId));
    final item = $_typedResult.readTableOrNull(_gradeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $AttSectionsTable _sectionIdTable(_$AttendanceDatabase db) =>
      db.attSections.createAlias(
          $_aliasNameGenerator(db.attSessions.sectionId, db.attSections.id));

  $$AttSectionsTableProcessedTableManager get sectionId {
    final manager = $$AttSectionsTableTableManager($_db, $_db.attSections)
        .filter((f) => f.id($_item.sectionId));
    final item = $_typedResult.readTableOrNull(_sectionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $AttSubjectsTable _subjectIdTable(_$AttendanceDatabase db) =>
      db.attSubjects.createAlias(
          $_aliasNameGenerator(db.attSessions.subjectId, db.attSubjects.id));

  $$AttSubjectsTableProcessedTableManager get subjectId {
    final manager = $$AttSubjectsTableTableManager($_db, $_db.attSubjects)
        .filter((f) => f.id($_item.subjectId));
    final item = $_typedResult.readTableOrNull(_subjectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $AttUsersTable _teacherIdTable(_$AttendanceDatabase db) =>
      db.attUsers.createAlias(
          $_aliasNameGenerator(db.attSessions.teacherId, db.attUsers.id));

  $$AttUsersTableProcessedTableManager? get teacherId {
    if ($_item.teacherId == null) return null;
    final manager = $$AttUsersTableTableManager($_db, $_db.attUsers)
        .filter((f) => f.id($_item.teacherId!));
    final item = $_typedResult.readTableOrNull(_teacherIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$AttRecordsTable, List<AttRecord>>
      _attRecordsRefsTable(_$AttendanceDatabase db) =>
          MultiTypedResultKey.fromTable(db.attRecords,
              aliasName: $_aliasNameGenerator(
                  db.attSessions.id, db.attRecords.sessionId));

  $$AttRecordsTableProcessedTableManager get attRecordsRefs {
    final manager = $$AttRecordsTableTableManager($_db, $_db.attRecords)
        .filter((f) => f.sessionId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_attRecordsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$AttSessionsTableFilterComposer
    extends Composer<_$AttendanceDatabase, $AttSessionsTable> {
  $$AttSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get periodNumber => $composableBuilder(
      column: $table.periodNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get closedAt => $composableBuilder(
      column: $table.closedAt, builder: (column) => ColumnFilters(column));

  $$AttGradesTableFilterComposer get gradeId {
    final $$AttGradesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.gradeId,
        referencedTable: $db.attGrades,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttGradesTableFilterComposer(
              $db: $db,
              $table: $db.attGrades,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AttSectionsTableFilterComposer get sectionId {
    final $$AttSectionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sectionId,
        referencedTable: $db.attSections,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttSectionsTableFilterComposer(
              $db: $db,
              $table: $db.attSections,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AttSubjectsTableFilterComposer get subjectId {
    final $$AttSubjectsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.subjectId,
        referencedTable: $db.attSubjects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttSubjectsTableFilterComposer(
              $db: $db,
              $table: $db.attSubjects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AttUsersTableFilterComposer get teacherId {
    final $$AttUsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.teacherId,
        referencedTable: $db.attUsers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttUsersTableFilterComposer(
              $db: $db,
              $table: $db.attUsers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> attRecordsRefs(
      Expression<bool> Function($$AttRecordsTableFilterComposer f) f) {
    final $$AttRecordsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.attRecords,
        getReferencedColumn: (t) => t.sessionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttRecordsTableFilterComposer(
              $db: $db,
              $table: $db.attRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$AttSessionsTableOrderingComposer
    extends Composer<_$AttendanceDatabase, $AttSessionsTable> {
  $$AttSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get periodNumber => $composableBuilder(
      column: $table.periodNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get closedAt => $composableBuilder(
      column: $table.closedAt, builder: (column) => ColumnOrderings(column));

  $$AttGradesTableOrderingComposer get gradeId {
    final $$AttGradesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.gradeId,
        referencedTable: $db.attGrades,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttGradesTableOrderingComposer(
              $db: $db,
              $table: $db.attGrades,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AttSectionsTableOrderingComposer get sectionId {
    final $$AttSectionsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sectionId,
        referencedTable: $db.attSections,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttSectionsTableOrderingComposer(
              $db: $db,
              $table: $db.attSections,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AttSubjectsTableOrderingComposer get subjectId {
    final $$AttSubjectsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.subjectId,
        referencedTable: $db.attSubjects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttSubjectsTableOrderingComposer(
              $db: $db,
              $table: $db.attSubjects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AttUsersTableOrderingComposer get teacherId {
    final $$AttUsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.teacherId,
        referencedTable: $db.attUsers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttUsersTableOrderingComposer(
              $db: $db,
              $table: $db.attUsers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AttSessionsTableAnnotationComposer
    extends Composer<_$AttendanceDatabase, $AttSessionsTable> {
  $$AttSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get periodNumber => $composableBuilder(
      column: $table.periodNumber, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get closedAt =>
      $composableBuilder(column: $table.closedAt, builder: (column) => column);

  $$AttGradesTableAnnotationComposer get gradeId {
    final $$AttGradesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.gradeId,
        referencedTable: $db.attGrades,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttGradesTableAnnotationComposer(
              $db: $db,
              $table: $db.attGrades,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AttSectionsTableAnnotationComposer get sectionId {
    final $$AttSectionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sectionId,
        referencedTable: $db.attSections,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttSectionsTableAnnotationComposer(
              $db: $db,
              $table: $db.attSections,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AttSubjectsTableAnnotationComposer get subjectId {
    final $$AttSubjectsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.subjectId,
        referencedTable: $db.attSubjects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttSubjectsTableAnnotationComposer(
              $db: $db,
              $table: $db.attSubjects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AttUsersTableAnnotationComposer get teacherId {
    final $$AttUsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.teacherId,
        referencedTable: $db.attUsers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttUsersTableAnnotationComposer(
              $db: $db,
              $table: $db.attUsers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> attRecordsRefs<T extends Object>(
      Expression<T> Function($$AttRecordsTableAnnotationComposer a) f) {
    final $$AttRecordsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.attRecords,
        getReferencedColumn: (t) => t.sessionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttRecordsTableAnnotationComposer(
              $db: $db,
              $table: $db.attRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$AttSessionsTableTableManager extends RootTableManager<
    _$AttendanceDatabase,
    $AttSessionsTable,
    AttSession,
    $$AttSessionsTableFilterComposer,
    $$AttSessionsTableOrderingComposer,
    $$AttSessionsTableAnnotationComposer,
    $$AttSessionsTableCreateCompanionBuilder,
    $$AttSessionsTableUpdateCompanionBuilder,
    (AttSession, $$AttSessionsTableReferences),
    AttSession,
    PrefetchHooks Function(
        {bool gradeId,
        bool sectionId,
        bool subjectId,
        bool teacherId,
        bool attRecordsRefs})> {
  $$AttSessionsTableTableManager(
      _$AttendanceDatabase db, $AttSessionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AttSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AttSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AttSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<int> gradeId = const Value.absent(),
            Value<int> sectionId = const Value.absent(),
            Value<int> subjectId = const Value.absent(),
            Value<int> periodNumber = const Value.absent(),
            Value<int?> teacherId = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> closedAt = const Value.absent(),
          }) =>
              AttSessionsCompanion(
            id: id,
            date: date,
            gradeId: gradeId,
            sectionId: sectionId,
            subjectId: subjectId,
            periodNumber: periodNumber,
            teacherId: teacherId,
            status: status,
            createdAt: createdAt,
            closedAt: closedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DateTime date,
            required int gradeId,
            required int sectionId,
            required int subjectId,
            required int periodNumber,
            Value<int?> teacherId = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> closedAt = const Value.absent(),
          }) =>
              AttSessionsCompanion.insert(
            id: id,
            date: date,
            gradeId: gradeId,
            sectionId: sectionId,
            subjectId: subjectId,
            periodNumber: periodNumber,
            teacherId: teacherId,
            status: status,
            createdAt: createdAt,
            closedAt: closedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$AttSessionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {gradeId = false,
              sectionId = false,
              subjectId = false,
              teacherId = false,
              attRecordsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (attRecordsRefs) db.attRecords],
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
                if (gradeId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.gradeId,
                    referencedTable:
                        $$AttSessionsTableReferences._gradeIdTable(db),
                    referencedColumn:
                        $$AttSessionsTableReferences._gradeIdTable(db).id,
                  ) as T;
                }
                if (sectionId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.sectionId,
                    referencedTable:
                        $$AttSessionsTableReferences._sectionIdTable(db),
                    referencedColumn:
                        $$AttSessionsTableReferences._sectionIdTable(db).id,
                  ) as T;
                }
                if (subjectId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.subjectId,
                    referencedTable:
                        $$AttSessionsTableReferences._subjectIdTable(db),
                    referencedColumn:
                        $$AttSessionsTableReferences._subjectIdTable(db).id,
                  ) as T;
                }
                if (teacherId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.teacherId,
                    referencedTable:
                        $$AttSessionsTableReferences._teacherIdTable(db),
                    referencedColumn:
                        $$AttSessionsTableReferences._teacherIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (attRecordsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$AttSessionsTableReferences
                            ._attRecordsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$AttSessionsTableReferences(db, table, p0)
                                .attRecordsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.sessionId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$AttSessionsTableProcessedTableManager = ProcessedTableManager<
    _$AttendanceDatabase,
    $AttSessionsTable,
    AttSession,
    $$AttSessionsTableFilterComposer,
    $$AttSessionsTableOrderingComposer,
    $$AttSessionsTableAnnotationComposer,
    $$AttSessionsTableCreateCompanionBuilder,
    $$AttSessionsTableUpdateCompanionBuilder,
    (AttSession, $$AttSessionsTableReferences),
    AttSession,
    PrefetchHooks Function(
        {bool gradeId,
        bool sectionId,
        bool subjectId,
        bool teacherId,
        bool attRecordsRefs})>;
typedef $$AttRecordsTableCreateCompanionBuilder = AttRecordsCompanion Function({
  Value<int> id,
  required int studentId,
  required int sessionId,
  required String status,
  Value<DateTime> recordedAt,
  Value<String?> notes,
});
typedef $$AttRecordsTableUpdateCompanionBuilder = AttRecordsCompanion Function({
  Value<int> id,
  Value<int> studentId,
  Value<int> sessionId,
  Value<String> status,
  Value<DateTime> recordedAt,
  Value<String?> notes,
});

final class $$AttRecordsTableReferences
    extends BaseReferences<_$AttendanceDatabase, $AttRecordsTable, AttRecord> {
  $$AttRecordsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AttStudentsTable _studentIdTable(_$AttendanceDatabase db) =>
      db.attStudents.createAlias(
          $_aliasNameGenerator(db.attRecords.studentId, db.attStudents.id));

  $$AttStudentsTableProcessedTableManager get studentId {
    final manager = $$AttStudentsTableTableManager($_db, $_db.attStudents)
        .filter((f) => f.id($_item.studentId));
    final item = $_typedResult.readTableOrNull(_studentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $AttSessionsTable _sessionIdTable(_$AttendanceDatabase db) =>
      db.attSessions.createAlias(
          $_aliasNameGenerator(db.attRecords.sessionId, db.attSessions.id));

  $$AttSessionsTableProcessedTableManager get sessionId {
    final manager = $$AttSessionsTableTableManager($_db, $_db.attSessions)
        .filter((f) => f.id($_item.sessionId));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$AttRecordsTableFilterComposer
    extends Composer<_$AttendanceDatabase, $AttRecordsTable> {
  $$AttRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get recordedAt => $composableBuilder(
      column: $table.recordedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  $$AttStudentsTableFilterComposer get studentId {
    final $$AttStudentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.studentId,
        referencedTable: $db.attStudents,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttStudentsTableFilterComposer(
              $db: $db,
              $table: $db.attStudents,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AttSessionsTableFilterComposer get sessionId {
    final $$AttSessionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionId,
        referencedTable: $db.attSessions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttSessionsTableFilterComposer(
              $db: $db,
              $table: $db.attSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AttRecordsTableOrderingComposer
    extends Composer<_$AttendanceDatabase, $AttRecordsTable> {
  $$AttRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get recordedAt => $composableBuilder(
      column: $table.recordedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  $$AttStudentsTableOrderingComposer get studentId {
    final $$AttStudentsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.studentId,
        referencedTable: $db.attStudents,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttStudentsTableOrderingComposer(
              $db: $db,
              $table: $db.attStudents,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AttSessionsTableOrderingComposer get sessionId {
    final $$AttSessionsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionId,
        referencedTable: $db.attSessions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttSessionsTableOrderingComposer(
              $db: $db,
              $table: $db.attSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AttRecordsTableAnnotationComposer
    extends Composer<_$AttendanceDatabase, $AttRecordsTable> {
  $$AttRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get recordedAt => $composableBuilder(
      column: $table.recordedAt, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$AttStudentsTableAnnotationComposer get studentId {
    final $$AttStudentsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.studentId,
        referencedTable: $db.attStudents,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttStudentsTableAnnotationComposer(
              $db: $db,
              $table: $db.attStudents,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AttSessionsTableAnnotationComposer get sessionId {
    final $$AttSessionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionId,
        referencedTable: $db.attSessions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttSessionsTableAnnotationComposer(
              $db: $db,
              $table: $db.attSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AttRecordsTableTableManager extends RootTableManager<
    _$AttendanceDatabase,
    $AttRecordsTable,
    AttRecord,
    $$AttRecordsTableFilterComposer,
    $$AttRecordsTableOrderingComposer,
    $$AttRecordsTableAnnotationComposer,
    $$AttRecordsTableCreateCompanionBuilder,
    $$AttRecordsTableUpdateCompanionBuilder,
    (AttRecord, $$AttRecordsTableReferences),
    AttRecord,
    PrefetchHooks Function({bool studentId, bool sessionId})> {
  $$AttRecordsTableTableManager(_$AttendanceDatabase db, $AttRecordsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AttRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AttRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AttRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> studentId = const Value.absent(),
            Value<int> sessionId = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> recordedAt = const Value.absent(),
            Value<String?> notes = const Value.absent(),
          }) =>
              AttRecordsCompanion(
            id: id,
            studentId: studentId,
            sessionId: sessionId,
            status: status,
            recordedAt: recordedAt,
            notes: notes,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int studentId,
            required int sessionId,
            required String status,
            Value<DateTime> recordedAt = const Value.absent(),
            Value<String?> notes = const Value.absent(),
          }) =>
              AttRecordsCompanion.insert(
            id: id,
            studentId: studentId,
            sessionId: sessionId,
            status: status,
            recordedAt: recordedAt,
            notes: notes,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$AttRecordsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({studentId = false, sessionId = false}) {
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
                if (studentId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.studentId,
                    referencedTable:
                        $$AttRecordsTableReferences._studentIdTable(db),
                    referencedColumn:
                        $$AttRecordsTableReferences._studentIdTable(db).id,
                  ) as T;
                }
                if (sessionId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.sessionId,
                    referencedTable:
                        $$AttRecordsTableReferences._sessionIdTable(db),
                    referencedColumn:
                        $$AttRecordsTableReferences._sessionIdTable(db).id,
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

typedef $$AttRecordsTableProcessedTableManager = ProcessedTableManager<
    _$AttendanceDatabase,
    $AttRecordsTable,
    AttRecord,
    $$AttRecordsTableFilterComposer,
    $$AttRecordsTableOrderingComposer,
    $$AttRecordsTableAnnotationComposer,
    $$AttRecordsTableCreateCompanionBuilder,
    $$AttRecordsTableUpdateCompanionBuilder,
    (AttRecord, $$AttRecordsTableReferences),
    AttRecord,
    PrefetchHooks Function({bool studentId, bool sessionId})>;
typedef $$AuditLogTableCreateCompanionBuilder = AuditLogCompanion Function({
  Value<int> id,
  Value<int?> userId,
  required String action,
  required String targetTable,
  required int recordId,
  Value<String?> oldValue,
  Value<String?> newValue,
  Value<DateTime> createdAt,
});
typedef $$AuditLogTableUpdateCompanionBuilder = AuditLogCompanion Function({
  Value<int> id,
  Value<int?> userId,
  Value<String> action,
  Value<String> targetTable,
  Value<int> recordId,
  Value<String?> oldValue,
  Value<String?> newValue,
  Value<DateTime> createdAt,
});

final class $$AuditLogTableReferences
    extends BaseReferences<_$AttendanceDatabase, $AuditLogTable, AuditEntry> {
  $$AuditLogTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AttUsersTable _userIdTable(_$AttendanceDatabase db) => db.attUsers
      .createAlias($_aliasNameGenerator(db.auditLog.userId, db.attUsers.id));

  $$AttUsersTableProcessedTableManager? get userId {
    if ($_item.userId == null) return null;
    final manager = $$AttUsersTableTableManager($_db, $_db.attUsers)
        .filter((f) => f.id($_item.userId!));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$AuditLogTableFilterComposer
    extends Composer<_$AttendanceDatabase, $AuditLogTable> {
  $$AuditLogTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get action => $composableBuilder(
      column: $table.action, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get targetTable => $composableBuilder(
      column: $table.targetTable, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get recordId => $composableBuilder(
      column: $table.recordId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get oldValue => $composableBuilder(
      column: $table.oldValue, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get newValue => $composableBuilder(
      column: $table.newValue, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$AttUsersTableFilterComposer get userId {
    final $$AttUsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.attUsers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttUsersTableFilterComposer(
              $db: $db,
              $table: $db.attUsers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AuditLogTableOrderingComposer
    extends Composer<_$AttendanceDatabase, $AuditLogTable> {
  $$AuditLogTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get action => $composableBuilder(
      column: $table.action, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get targetTable => $composableBuilder(
      column: $table.targetTable, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get recordId => $composableBuilder(
      column: $table.recordId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get oldValue => $composableBuilder(
      column: $table.oldValue, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get newValue => $composableBuilder(
      column: $table.newValue, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$AttUsersTableOrderingComposer get userId {
    final $$AttUsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.attUsers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttUsersTableOrderingComposer(
              $db: $db,
              $table: $db.attUsers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AuditLogTableAnnotationComposer
    extends Composer<_$AttendanceDatabase, $AuditLogTable> {
  $$AuditLogTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get targetTable => $composableBuilder(
      column: $table.targetTable, builder: (column) => column);

  GeneratedColumn<int> get recordId =>
      $composableBuilder(column: $table.recordId, builder: (column) => column);

  GeneratedColumn<String> get oldValue =>
      $composableBuilder(column: $table.oldValue, builder: (column) => column);

  GeneratedColumn<String> get newValue =>
      $composableBuilder(column: $table.newValue, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$AttUsersTableAnnotationComposer get userId {
    final $$AttUsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.attUsers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttUsersTableAnnotationComposer(
              $db: $db,
              $table: $db.attUsers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AuditLogTableTableManager extends RootTableManager<
    _$AttendanceDatabase,
    $AuditLogTable,
    AuditEntry,
    $$AuditLogTableFilterComposer,
    $$AuditLogTableOrderingComposer,
    $$AuditLogTableAnnotationComposer,
    $$AuditLogTableCreateCompanionBuilder,
    $$AuditLogTableUpdateCompanionBuilder,
    (AuditEntry, $$AuditLogTableReferences),
    AuditEntry,
    PrefetchHooks Function({bool userId})> {
  $$AuditLogTableTableManager(_$AttendanceDatabase db, $AuditLogTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuditLogTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuditLogTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AuditLogTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> userId = const Value.absent(),
            Value<String> action = const Value.absent(),
            Value<String> targetTable = const Value.absent(),
            Value<int> recordId = const Value.absent(),
            Value<String?> oldValue = const Value.absent(),
            Value<String?> newValue = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              AuditLogCompanion(
            id: id,
            userId: userId,
            action: action,
            targetTable: targetTable,
            recordId: recordId,
            oldValue: oldValue,
            newValue: newValue,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> userId = const Value.absent(),
            required String action,
            required String targetTable,
            required int recordId,
            Value<String?> oldValue = const Value.absent(),
            Value<String?> newValue = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              AuditLogCompanion.insert(
            id: id,
            userId: userId,
            action: action,
            targetTable: targetTable,
            recordId: recordId,
            oldValue: oldValue,
            newValue: newValue,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$AuditLogTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({userId = false}) {
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
                if (userId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.userId,
                    referencedTable: $$AuditLogTableReferences._userIdTable(db),
                    referencedColumn:
                        $$AuditLogTableReferences._userIdTable(db).id,
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

typedef $$AuditLogTableProcessedTableManager = ProcessedTableManager<
    _$AttendanceDatabase,
    $AuditLogTable,
    AuditEntry,
    $$AuditLogTableFilterComposer,
    $$AuditLogTableOrderingComposer,
    $$AuditLogTableAnnotationComposer,
    $$AuditLogTableCreateCompanionBuilder,
    $$AuditLogTableUpdateCompanionBuilder,
    (AuditEntry, $$AuditLogTableReferences),
    AuditEntry,
    PrefetchHooks Function({bool userId})>;
typedef $$AttSettingsTableCreateCompanionBuilder = AttSettingsCompanion
    Function({
  Value<int> id,
  required String key,
  required String value,
  Value<DateTime> updatedAt,
});
typedef $$AttSettingsTableUpdateCompanionBuilder = AttSettingsCompanion
    Function({
  Value<int> id,
  Value<String> key,
  Value<String> value,
  Value<DateTime> updatedAt,
});

class $$AttSettingsTableFilterComposer
    extends Composer<_$AttendanceDatabase, $AttSettingsTable> {
  $$AttSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$AttSettingsTableOrderingComposer
    extends Composer<_$AttendanceDatabase, $AttSettingsTable> {
  $$AttSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$AttSettingsTableAnnotationComposer
    extends Composer<_$AttendanceDatabase, $AttSettingsTable> {
  $$AttSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AttSettingsTableTableManager extends RootTableManager<
    _$AttendanceDatabase,
    $AttSettingsTable,
    AttSetting,
    $$AttSettingsTableFilterComposer,
    $$AttSettingsTableOrderingComposer,
    $$AttSettingsTableAnnotationComposer,
    $$AttSettingsTableCreateCompanionBuilder,
    $$AttSettingsTableUpdateCompanionBuilder,
    (
      AttSetting,
      BaseReferences<_$AttendanceDatabase, $AttSettingsTable, AttSetting>
    ),
    AttSetting,
    PrefetchHooks Function()> {
  $$AttSettingsTableTableManager(
      _$AttendanceDatabase db, $AttSettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AttSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AttSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AttSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              AttSettingsCompanion(
            id: id,
            key: key,
            value: value,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String key,
            required String value,
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              AttSettingsCompanion.insert(
            id: id,
            key: key,
            value: value,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AttSettingsTableProcessedTableManager = ProcessedTableManager<
    _$AttendanceDatabase,
    $AttSettingsTable,
    AttSetting,
    $$AttSettingsTableFilterComposer,
    $$AttSettingsTableOrderingComposer,
    $$AttSettingsTableAnnotationComposer,
    $$AttSettingsTableCreateCompanionBuilder,
    $$AttSettingsTableUpdateCompanionBuilder,
    (
      AttSetting,
      BaseReferences<_$AttendanceDatabase, $AttSettingsTable, AttSetting>
    ),
    AttSetting,
    PrefetchHooks Function()>;

class $AttendanceDatabaseManager {
  final _$AttendanceDatabase _db;
  $AttendanceDatabaseManager(this._db);
  $$AttStudentsTableTableManager get attStudents =>
      $$AttStudentsTableTableManager(_db, _db.attStudents);
  $$AttUsersTableTableManager get attUsers =>
      $$AttUsersTableTableManager(_db, _db.attUsers);
  $$AttStagesTableTableManager get attStages =>
      $$AttStagesTableTableManager(_db, _db.attStages);
  $$AttGradesTableTableManager get attGrades =>
      $$AttGradesTableTableManager(_db, _db.attGrades);
  $$AttSectionsTableTableManager get attSections =>
      $$AttSectionsTableTableManager(_db, _db.attSections);
  $$AttSubjectsTableTableManager get attSubjects =>
      $$AttSubjectsTableTableManager(_db, _db.attSubjects);
  $$AttSessionsTableTableManager get attSessions =>
      $$AttSessionsTableTableManager(_db, _db.attSessions);
  $$AttRecordsTableTableManager get attRecords =>
      $$AttRecordsTableTableManager(_db, _db.attRecords);
  $$AuditLogTableTableManager get auditLog =>
      $$AuditLogTableTableManager(_db, _db.auditLog);
  $$AttSettingsTableTableManager get attSettings =>
      $$AttSettingsTableTableManager(_db, _db.attSettings);
}
