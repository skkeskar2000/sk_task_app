part of 'task_cubit.dart';

abstract class TaskState extends Equatable {
  const TaskState();
}

class TaskInitial  extends TaskState {
  @override
  List<Object> get props => [];
}

class TaskLoading  extends TaskState {
  @override

  List<Object> get props => [];
}

class TaskLoaded  extends TaskState {
  final List<TaskEntity> taskData;

  TaskLoaded({required this.taskData});
  @override
  List<Object> get props => [];
}

class TaskFailure  extends TaskState {
  @override
  List<Object> get props => [];
}

