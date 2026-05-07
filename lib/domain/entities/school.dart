import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'enums.dart';

class School extends Equatable {
  final String id;
  final String name;
  final String address;
  final String phone;
  final String email;
  final int dailySessions;
  final List<WorkDay> workDays;
  final TimeOfDay firstSessionTime;
  final int sessionDuration; // in minutes
  final String academicYear;

  const School({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.email,
    required this.dailySessions,
    required this.workDays,
    required this.firstSessionTime,
    required this.sessionDuration,
    required this.academicYear,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        address,
        phone,
        email,
        dailySessions,
        workDays,
        firstSessionTime,
        sessionDuration,
        academicYear,
      ];
}
