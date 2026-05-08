import 'package:school_schedule_app/core/utils/l10n_extension.dart';
import 'package:flutter/material.dart';

enum WorkDay {
  saturday,
  sunday,
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
}

enum TeacherType {
  primary,
  substitute,
  assistant,
}

enum ClassLevel {
  primary,
  middle,
  high,
}

enum SubjectPriority {
  high, // A
  medium, // B
  low, // C
}

enum SessionStatus {
  scheduled,
  completed,
  cancelled,
  pending,
}

enum ScheduleStatus {
  draft,
  active,
  archived,
}

enum GenerationMode {
  balanced,
  compact,
  priority,
}

enum RoomType {
  lecture,
  lab,
  workshop,
  gym,
  arts,
}

enum QualityGrade {
  excellent,
  good,
  acceptable,
  needsImprovement,
  poor,
}

extension WorkDayExtension on WorkDay {
  String getLocalizedName(BuildContext context) {
    switch (this) {
      case WorkDay.saturday: return context.l10n.saturday;
      case WorkDay.sunday: return context.l10n.sunday;
      case WorkDay.monday: return context.l10n.monday;
      case WorkDay.tuesday: return context.l10n.tuesday;
      case WorkDay.wednesday: return context.l10n.wednesday;
      case WorkDay.thursday: return context.l10n.thursday;
      case WorkDay.friday: return context.l10n.friday;
    }
  }

  String getArabicName(BuildContext context) {
    // For now, this returns the localized name, but the method name is required by the services.
    return getLocalizedName(context);
  }
}

extension ClassLevelExtension on ClassLevel {
  String getLocalizedName(BuildContext context) {
    switch (this) {
      case ClassLevel.primary: return context.l10n.primaryLevel;
      case ClassLevel.middle: return context.l10n.middleLevel;
      case ClassLevel.high: return context.l10n.highLevel;
    }
  }
}
