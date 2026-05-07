import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'enums.dart';

class Subject extends Equatable {
  final String id;
  final String name;
  final String code;
  final SubjectPriority priority;
  final int weeklyHours; // Legacy support
  final Map<String, int> classPeriods;
  final Color color;
  final bool requiresLab;
  final bool requiresProjector;
  final List<String> qualifiedTeacherIds;
  final List<String> prerequisiteSubjectIds;
  final RoomType requiredRoomType;

  const Subject({
    required this.id,
    required this.name,
    required this.code,
    required this.priority,
    this.weeklyHours = 0,
    required this.classPeriods,
    required this.color,
    required this.requiresLab,
    required this.requiresProjector,
    required this.qualifiedTeacherIds,
    this.prerequisiteSubjectIds = const [],
    this.requiredRoomType = RoomType.lecture,
  });

  int getHoursForClass(String classId) {
    if (classPeriods.containsKey(classId)) return classPeriods[classId]!;
    if (weeklyHours > 0 && classPeriods.isNotEmpty) {
      return weeklyHours ~/ classPeriods.length;
    }
    return weeklyHours;
  }

  @override
  List<Object?> get props => [
        id,
        name,
        code,
        priority,
        weeklyHours,
        classPeriods,
        color,
        requiresLab,
        requiresProjector,
        qualifiedTeacherIds,
        prerequisiteSubjectIds,
        requiredRoomType,
      ];
}
