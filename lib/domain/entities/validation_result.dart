import 'package:equatable/equatable.dart';

class ValidationResult extends Equatable {
  final List<String> errors;
  final List<String> warnings;

  const ValidationResult({
    this.errors = const [],
    this.warnings = const [],
  });

  bool get isValid => errors.isEmpty;

  factory ValidationResult.valid() => const ValidationResult();

  ValidationResult copyWith({
    List<String>? errors,
    List<String>? warnings,
  }) {
    return ValidationResult(
      errors: errors ?? this.errors,
      warnings: warnings ?? this.warnings,
    );
  }

  @override
  List<Object?> get props =>
      [errors, warnings, DateTime.now()]; // Hack to force update?
  // No, let's just rely on content equality.
  // If content is same, we don't strictly need to show dialog again if it's already showing?
  // But if user closed dialog, then clicked validate again...
  // The state didn't change, so listener won't fire.
  // We need a timestamp or "triggerId" in state to force events.
  // Or just emit a "ValidationLoading" state before result?
  // ScheduleLoading replaces the UI. We don't want that.
}
