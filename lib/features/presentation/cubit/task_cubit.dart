import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sk_task/features/domain/entities/task_entity.dart';
import 'package:sk_task/features/domain/use_cases/add_task_usecase.dart';
import 'package:sk_task/features/domain/use_cases/delete_task_usecase.dart';
import 'package:sk_task/features/domain/use_cases/get_all_task.dart';
import 'package:sk_task/features/domain/use_cases/get_notification_usecase.dart';
import 'package:sk_task/features/domain/use_cases/init_notification_usecase.dart';
import 'package:sk_task/features/domain/use_cases/open_database_usecase.dart';
import 'package:sk_task/features/domain/use_cases/turn_on_notification_usecase.dart';
import 'package:sk_task/features/domain/use_cases/update_usecase.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final AddTaskUseCase addTaskUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;
  final GetAllTaskUseCase getAllTaskUseCase;
  final GetNotificationUseCase getNotificationUseCase;
  final OpenDatabaseUseCase openDatabaseUseCase;
  final TurnOnNotificationUseCase turnOnNotificationUseCase;
  final UpdateUseCase updateUseCase;
  final InitNotificationUseCase initNotificationUseCase;

  TaskCubit({
    required this.initNotificationUseCase,
    required this.addTaskUseCase,
    required this.deleteTaskUseCase,
    required this.getAllTaskUseCase,
    required this.getNotificationUseCase,
    required this.openDatabaseUseCase,
    required this.turnOnNotificationUseCase,
    required this.updateUseCase,
  }) : super(TaskInitial());

  Future<void> addNewTask({required TaskEntity task}) async {
    try {
      addTaskUseCase.call(task);
    } catch (error) {
      print(error);
      //FIXME : emit failure
    }
  }

  Future<void> deleteTask(TaskEntity task) async {
    try {
      deleteTaskUseCase.call(task);
      Future.delayed(const Duration(seconds: 1), () {
        getAllTask();
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> initNotification() async {
    try {
      await initNotificationUseCase.call();
    } catch (error) {
      print(error);
    }
  }

  Future<void> getAllTask() async {
    emit(TaskLoading());
    try {
      final taskData = await getAllTaskUseCase.call();
      emit(TaskLoaded(taskData: taskData));
    } catch (error) {
      emit(TaskFailure());
    }
  }

  Future<void> openDatabase() async {
    try {
      await openDatabaseUseCase();
    } catch (error) {
      print(error);
    }
  }

  Future<void> getNotification(TaskEntity task) async {
    try {
      await getNotificationUseCase.call(task);
    } catch (error) {
      print(error);
      emit(TaskFailure());
    }
  }

  Future<void> turnOnNotification(TaskEntity task) async {
    emit(TaskLoading());
    try {
      await turnOnNotificationUseCase.call(task);
      Future.delayed(const Duration(seconds: 1), () {
        getAllTask();
      });
    } catch (error) {
      print(error);
      emit(TaskFailure());
    }
  }

  Future<void> updateTask(TaskEntity task) async {
    emit(TaskLoading());
    try {
      await updateUseCase.call(task);
      Future.delayed(const Duration(seconds: 1), () {
        getAllTask();
      });
    } catch (error) {
      print(error);
      emit(TaskFailure());
    }
  }
}
