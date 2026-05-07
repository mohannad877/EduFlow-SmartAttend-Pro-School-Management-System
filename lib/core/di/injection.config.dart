// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:math' as _i407;

import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../data/datasources/local/app_database.dart' as _i483;
import '../../data/repositories/classroom_repository_impl.dart' as _i35;
import '../../data/repositories/schedule_repository_impl.dart' as _i1052;
import '../../data/repositories/school_repository_impl.dart' as _i642;
import '../../data/repositories/subject_repository_impl.dart' as _i274;
import '../../data/repositories/teacher_repository_impl.dart' as _i748;
import '../../domain/repositories/i_classroom_repository.dart' as _i198;
import '../../domain/repositories/i_schedule_repository.dart' as _i671;
import '../../domain/repositories/i_school_repository.dart' as _i98;
import '../../domain/repositories/i_subject_repository.dart' as _i853;
import '../../domain/repositories/i_teacher_repository.dart' as _i796;
import '../../domain/services/event_bus_service.dart' as _i261;
import '../../domain/usecases/algorithm/conflict_resolver.dart' as _i493;
import '../../domain/usecases/algorithm/intelligent_schedule_generator.dart'
    as _i552;
import '../../domain/usecases/algorithm/schedule_validator.dart' as _i708;
import '../../domain/usecases/schedule/generate_schedule_usecase.dart' as _i230;
import '../../presentation/bloc/classroom/classroom_bloc.dart' as _i674;
import '../../presentation/bloc/dashboard/dashboard_bloc.dart' as _i360;
import '../../presentation/bloc/schedule/schedule_bloc.dart' as _i510;
import '../../presentation/bloc/schedule/schedule_event.dart' as _i259;
import '../../presentation/bloc/school/school_bloc.dart' as _i388;
import '../../presentation/bloc/subject/subject_bloc.dart' as _i121;
import '../../presentation/bloc/teacher/teacher_bloc.dart' as _i1001;
import '../services/excel_export_service.dart' as _i365;
import '../services/pdf_export_service.dart' as _i988;
import '../utils/logger.dart' as _i221;
import '../utils/metrics_collector.dart' as _i717;
import '../utils/undo_stack.dart' as _i810;
import 'core_module.dart' as _i154;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    final coreModule = _$CoreModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.factory<_i493.ConflictResolver>(() => _i493.ConflictResolver());
    gh.lazySingleton<_i510.BlocConfig>(() => coreModule.blocConfig);
    gh.lazySingleton<_i810.UndoStack<_i259.ScheduleEvent>>(
        () => coreModule.undoStack);
    gh.lazySingleton<_i483.AppDatabase>(() => registerModule.appDatabase);
    gh.lazySingleton<_i365.ExcelExportService>(
        () => _i365.ExcelExportService());
    gh.lazySingleton<_i988.PdfExportService>(() => _i988.PdfExportService());
    gh.lazySingleton<_i221.Logger>(() => _i221.Logger());
    gh.lazySingleton<_i717.MetricsCollector>(() => _i717.MetricsCollector());
    gh.lazySingleton<_i98.ISchoolRepository>(
        () => _i642.SchoolRepositoryImpl(gh<_i483.AppDatabase>()));
    gh.lazySingleton<_i853.ISubjectRepository>(
        () => _i274.SubjectRepositoryImpl(gh<_i483.AppDatabase>()));
    gh.lazySingleton<_i198.IClassroomRepository>(
        () => _i35.ClassroomRepositoryImpl(gh<_i483.AppDatabase>()));
    gh.lazySingleton<_i796.ITeacherRepository>(
        () => _i748.TeacherRepositoryImpl(gh<_i483.AppDatabase>()));
    gh.factory<_i388.SchoolBloc>(
        () => _i388.SchoolBloc(gh<_i98.ISchoolRepository>()));
    gh.lazySingleton<_i671.IScheduleRepository>(
        () => _i1052.ScheduleRepositoryImpl(gh<_i483.AppDatabase>()));
    gh.factory<_i674.ClassroomBloc>(
        () => _i674.ClassroomBloc(gh<_i198.IClassroomRepository>()));
    gh.factory<_i121.SubjectBloc>(
        () => _i121.SubjectBloc(gh<_i853.ISubjectRepository>()));
    gh.lazySingleton<_i708.ScheduleValidator>(() => _i708.ScheduleValidator(
          defaultConfig: gh<_i708.ValidationConfig>(),
          logger: gh<_i708.Logger>(),
          metricsCollector: gh<_i717.MetricsCollector>(),
        ));
    gh.factory<_i1001.TeacherBloc>(
        () => _i1001.TeacherBloc(gh<_i796.ITeacherRepository>()));
    gh.factory<_i360.DashboardBloc>(() => _i360.DashboardBloc(
          gh<_i796.ITeacherRepository>(),
          gh<_i198.IClassroomRepository>(),
          gh<_i853.ISubjectRepository>(),
          gh<_i98.ISchoolRepository>(),
        ));
    gh.lazySingleton<_i552.IntelligentScheduleGenerator>(
        () => _i552.IntelligentScheduleGenerator(
              gh<_i796.ITeacherRepository>(),
              gh<_i198.IClassroomRepository>(),
              gh<_i853.ISubjectRepository>(),
              gh<_i671.IScheduleRepository>(),
              gh<_i708.ScheduleValidator>(),
              logger: gh<_i221.Logger>(),
              metricsCollector: gh<_i717.MetricsCollector>(),
              random: gh<_i407.Random>(),
            ));
    gh.lazySingleton<_i230.GenerateScheduleUseCase>(
        () => _i230.GenerateScheduleUseCase(
              gh<_i671.IScheduleRepository>(),
              gh<_i796.ITeacherRepository>(),
              gh<_i853.ISubjectRepository>(),
              gh<_i198.IClassroomRepository>(),
              gh<_i552.IntelligentScheduleGenerator>(),
              gh<_i261.EventBusService>(),
              logger: gh<_i221.Logger>(),
              metricsCollector: gh<_i717.MetricsCollector>(),
              config: gh<_i230.UseCaseConfig>(),
            ));
    gh.lazySingleton<_i510.ScheduleBloc>(() => _i510.ScheduleBloc(
          gh<_i671.IScheduleRepository>(),
          gh<_i796.ITeacherRepository>(),
          gh<_i853.ISubjectRepository>(),
          gh<_i98.ISchoolRepository>(),
          gh<_i198.IClassroomRepository>(),
          gh<_i230.GenerateScheduleUseCase>(),
          gh<_i988.PdfExportService>(),
          gh<_i365.ExcelExportService>(),
          gh<_i708.ScheduleValidator>(),
          undoStack: gh<_i810.UndoStack<_i259.ScheduleEvent>>(),
          logger: gh<_i221.Logger>(),
          metricsCollector: gh<_i717.MetricsCollector>(),
          config: gh<_i510.BlocConfig>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}

class _$CoreModule extends _i154.CoreModule {}
