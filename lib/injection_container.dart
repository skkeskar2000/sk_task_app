import 'package:get_it/get_it.dart';
import 'package:sk_task/features/data/data_sources/local_data_source.dart';
import 'package:sk_task/features/data/data_sources/local_data_source_impl.dart';
import 'package:sk_task/features/data/repositories/local_repository_impl.dart';
import 'package:sk_task/features/domain/repositories/local_repository.dart';
import 'package:sk_task/features/domain/use_cases/add_task_usecase.dart';
import 'package:sk_task/features/domain/use_cases/delete_task_usecase.dart';
import 'package:sk_task/features/domain/use_cases/delete_task_usecase.dart';
import 'package:sk_task/features/domain/use_cases/get_all_task.dart';
import 'package:sk_task/features/domain/use_cases/get_notification_usecase.dart';
import 'package:sk_task/features/domain/use_cases/init_notification_usecase.dart';
import 'package:sk_task/features/domain/use_cases/open_database_usecase.dart';
import 'package:sk_task/features/domain/use_cases/turn_on_notification_usecase.dart';
import 'package:sk_task/features/domain/use_cases/update_usecase.dart';
import 'package:sk_task/features/presentation/cubit/task_cubit.dart';

GetIt sl = GetIt.instance;

Future<void> init() async {
  //bloc/Cubit
  sl.registerFactory<TaskCubit>(() => TaskCubit(
      addTaskUseCase: sl.call(),
      deleteTaskUseCase: sl.call(),
      getAllTaskUseCase: sl.call(),
      getNotificationUseCase: sl.call(),
      openDatabaseUseCase: sl.call(),
      turnOnNotificationUseCase: sl.call(),
      initNotificationUseCase: sl.call(),
      updateUseCase: sl.call()));

  //UseCases
  sl.registerLazySingleton<AddTaskUseCase>(
      () => AddTaskUseCase(localRepository: sl.call()));

  sl.registerLazySingleton<InitNotificationUseCase>(
          () => InitNotificationUseCase(localRepository: sl.call()));

  sl.registerLazySingleton<DeleteTaskUseCase>(
      () => DeleteTaskUseCase(localRepository: sl.call()));

  sl.registerLazySingleton<GetAllTaskUseCase>(
      () => GetAllTaskUseCase(localRepository: sl.call()));

  sl.registerLazySingleton<GetNotificationUseCase>(
      () => GetNotificationUseCase(localRepository: sl.call()));

  sl.registerLazySingleton<OpenDatabaseUseCase>(
      () => OpenDatabaseUseCase(localRepository: sl.call()));

  sl.registerLazySingleton<TurnOnNotificationUseCase>(
      () => TurnOnNotificationUseCase(localRepository: sl.call()));

  sl.registerLazySingleton<UpdateUseCase>(
      () => UpdateUseCase(localRepository: sl.call()));

  //Repository
  sl.registerLazySingleton<LocalRepository>(
      () => LocalRepositoryImpl(localDataSource: sl.call()));

  //RemoteDataSource
  sl.registerLazySingleton<LocalDataSource>(() => LocalDataSourceImpl());

  //External (http)
}
