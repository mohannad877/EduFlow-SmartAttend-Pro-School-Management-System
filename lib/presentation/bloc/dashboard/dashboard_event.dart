import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class LoadDashboardStats extends DashboardEvent {
  final dynamic attendanceDb;
  const LoadDashboardStats({this.attendanceDb});

  @override
  List<Object?> get props => [attendanceDb];
}
