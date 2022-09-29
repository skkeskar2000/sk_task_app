import 'package:sk_task/features/data/models/task_model.dart';

class TaskEntity {
  late int? id;
  final String title;
  final String colorIndex;
  final String time;
  final bool isCompleteTask;
  final bool isNotification;
  final String taskType;

  TaskEntity(
      {this.id,
      required this.taskType,
      required this.title,
      required this.colorIndex,
      required this.time,
      required this.isCompleteTask,
      required this.isNotification});
}
