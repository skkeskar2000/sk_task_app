
import 'package:sembast/sembast.dart';
import 'package:sk_task/features/domain/entities/task_entity.dart';

abstract class LocalRepository{
  Future<void> addNewTask(TaskEntity task);
  Future<bool> deleteTask(TaskEntity task);
  Future<void> updateTask(TaskEntity task);
  Future<List<TaskEntity>> getAllTask();
  Future<void> getNotification(TaskEntity task);
  Future<void> turnOnNotification(TaskEntity task);
  Future<Database> openDatabase();
  Future<void> initNotification();
}