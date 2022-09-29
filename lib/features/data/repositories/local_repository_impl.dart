

import 'package:sembast/sembast.dart';
import 'package:sk_task/features/data/data_sources/local_data_source.dart';
import 'package:sk_task/features/domain/entities/task_entity.dart';
import 'package:sk_task/features/domain/repositories/local_repository.dart';

class LocalRepositoryImpl implements LocalRepository{
  final LocalDataSource localDataSource;

  LocalRepositoryImpl({required this.localDataSource});

  @override
  Future<void> addNewTask(TaskEntity task) async =>
      localDataSource.addNewTask(task);

  @override
  Future<bool> deleteTask(TaskEntity task) async =>
      localDataSource.deleteTask(task);

  @override
  Future<List<TaskEntity>> getAllTask() => localDataSource.getAllTask();

  @override
  Future<void> getNotification(TaskEntity task) async =>
      localDataSource.getNotification(task);

  @override
  Future<Database> openDatabase() async => localDataSource.openDatabase();

  @override
  Future<void> turnOnNotification(TaskEntity task) async => localDataSource.turnOnNotification(task);

  @override
  Future<void> updateTask(TaskEntity task) async => localDataSource.updateTask(task);

  @override
  Future<void> initNotification() async => localDataSource.initNotification();
}