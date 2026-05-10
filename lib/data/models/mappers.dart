import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:school_schedule_app/domain/entities/school.dart';
import 'package:school_schedule_app/domain/entities/subject.dart';
import 'package:school_schedule_app/domain/entities/classroom.dart';
import 'package:school_schedule_app/domain/entities/session.dart';
import 'package:school_schedule_app/domain/entities/schedule.dart';
import 'package:school_schedule_app/domain/entities/teacher.dart';
import 'package:school_schedule_app/data/datasources/local/app_database.dart';

// Teacher Mappers
extension TeacherMapper on Teacher {
  TeacherDto toDto() {
    return TeacherDto(
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
      workDays: workDays, // ✅ إضافة workDays
    );
  }
}

extension TeacherDtoMapper on TeacherDto {
  Teacher toDomain() {
    return Teacher(
      id: id,
      fullName: fullName,
      qualification: qualification ?? '',
      specialization: specialization,
      phone: phone,
      email: email ?? '',
      maxWeeklyHours: maxWeeklyHours,
      maxDailyHours: maxDailyHours,
      unavailablePeriods: unavailablePeriods,
      subjectIds: subjectIds,
      classIds: classIds,
      type: type,
      workDays: workDays, // ✅ إضافة workDays
    );
  }
}

// School Mappers
extension SchoolMapper on School {
  SchoolDto toDto() {
    return SchoolDto(
      id: id,
      name: name,
      address: address,
      phone: phone,
      email: email,
      dailySessions: dailySessions,
      workDays: workDays,
      firstSessionTime: firstSessionTime.hour * 60 + firstSessionTime.minute,
      sessionDuration: sessionDuration,
      academicYear: academicYear,
    );
  }
}

extension SchoolDtoMapper on SchoolDto {
  School toDomain() {
    return School(
      id: id,
      name: name,
      address: address,
      phone: phone,
      email: email,
      dailySessions: dailySessions,
      workDays: workDays,
      firstSessionTime: TimeOfDay(
          hour: firstSessionTime ~/ 60, minute: firstSessionTime % 60),
      sessionDuration: sessionDuration,
      academicYear: academicYear,
    );
  }
}

// Subject Mappers
extension SubjectMapper on Subject {
  SubjectDto toDto() {
    return SubjectDto(
      id: id,
      name: name,
      code: code,
      priority: priority,
      weeklyHours: weeklyHours,
      classPeriods: classPeriods,
      color: color.value,
      requiresLab: requiresLab,
      requiresProjector: requiresProjector,
      qualifiedTeacherIds: qualifiedTeacherIds,
    );
  }
}

extension SubjectDtoMapper on SubjectDto {
  Subject toDomain() {
    return Subject(
      id: id,
      name: name,
      code: code ?? '',
      priority: priority,
      weeklyHours: weeklyHours,
      classPeriods: classPeriods ?? const {},
      color: Color(color),
      requiresLab: requiresLab,
      requiresProjector: requiresProjector,
      qualifiedTeacherIds: qualifiedTeacherIds,
    );
  }
}

// Classroom Mappers
extension ClassroomMapper on Classroom {
  ClassroomDto toDto() {
    return ClassroomDto(
      id: id,
      name: name,
      section: section,
      studentCount: studentCount,
      roomNumber: roomNumber,
      level: level,
      supervisorId: supervisorId,
      subjectIds: subjects.map((s) => s.id).toList(),
    );
  }
}

extension ClassroomDtoMapper on ClassroomDto {
  Classroom toDomain({List<Subject> subjects = const []}) {
    return Classroom(
      id: id,
      name: name,
      section: section,
      studentCount: studentCount,
      roomNumber: roomNumber,
      level: level,
      supervisorId: supervisorId,
      subjects: subjects,
    );
  }
}

// Session Mappers
extension SessionMapper on Session {
  SessionDto toDto(String scheduleId) {
    return SessionDto(
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
    );
  }
}

extension SessionDtoMapper on SessionDto {
  Session toDomain() {
    return Session(
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
    );
  }
}

// Schedule Mappers
extension ScheduleMapper on Schedule {
  ScheduleDto toDto() {
    return ScheduleDto(
      id: id,
      name: name,
      creationDate: creationDate,
      startDate: startDate,
      endDate: endDate,
      schoolId: schoolId,
      creatorId: creatorId,
      status: status,
      metadata: metadata != null ? jsonEncode(metadata) : null,
    );
  }
}

extension ScheduleDtoMapper on ScheduleDto {
  Schedule toDomain({List<Session> sessions = const []}) {
    return Schedule(
      id: id,
      name: name,
      creationDate: creationDate,
      startDate: startDate,
      endDate: endDate,
      schoolId: schoolId,
      creatorId: creatorId,
      status: status,
      sessions: sessions,
      metadata: metadata != null ? jsonDecode(metadata!) : const {},
    );
  }
}
