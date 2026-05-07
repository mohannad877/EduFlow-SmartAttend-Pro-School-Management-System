import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:school_schedule_app/domain/entities/enums.dart';

class WorkDayListConverter extends TypeConverter<List<WorkDay>, String> {
  const WorkDayListConverter();

  @override
  List<WorkDay> fromSql(String? fromDb) {
    if (fromDb == null) return [];
    final List<dynamic> list = jsonDecode(fromDb);
    return list.map((e) => WorkDay.values[e as int]).toList();
  }

  @override
  String toSql(List<WorkDay>? value) {
    if (value == null) return '[]';
    return jsonEncode(value.map((e) => e.index).toList());
  }
}

class StringListConverter extends TypeConverter<List<String>, String> {
  const StringListConverter();

  @override
  List<String> fromSql(String? fromDb) {
    if (fromDb == null) return [];
    return List<String>.from(jsonDecode(fromDb));
  }

  @override
  String toSql(List<String>? value) {
    if (value == null) return '[]';
    return jsonEncode(value);
  }
}

class IntListMapConverter
    extends TypeConverter<Map<WorkDay, List<int>>, String> {
  const IntListMapConverter();

  @override
  Map<WorkDay, List<int>> fromSql(String? fromDb) {
    if (fromDb == null) return {};
    final Map<String, dynamic> map = jsonDecode(fromDb);
    return map.map((key, value) {
      return MapEntry(WorkDay.values[int.parse(key)], List<int>.from(value));
    });
  }

  @override
  String toSql(Map<WorkDay, List<int>>? value) {
    if (value == null) return '{}';
    final map =
        value.map((key, value) => MapEntry(key.index.toString(), value));
    return jsonEncode(map);
  }
}

class StringIntMapConverter extends TypeConverter<Map<String, int>, String> {
  const StringIntMapConverter();

  @override
  Map<String, int> fromSql(String? fromDb) {
    if (fromDb == null) return {};
    final Map<String, dynamic> map = jsonDecode(fromDb);
    return map.map((key, value) => MapEntry(key, value as int));
  }

  @override
  String toSql(Map<String, int>? value) {
    if (value == null) return '{}';
    return jsonEncode(value);
  }
}
