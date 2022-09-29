import 'package:sk_task/features/domain/entities/task_entity.dart';

class TaskModel extends TaskEntity {
  TaskModel({
    int? id,
    required final String title,
    required final String colorIndex,
    required final String time,
    required final bool isCompleteTask,
    required final bool isNotification,
    required final String taskType,
  }) : super(time: time,
      isCompleteTask: isCompleteTask,
      colorIndex: colorIndex,
      title: title,
      isNotification: isNotification,
  taskType: taskType);

  static TaskModel fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      colorIndex: json['colorIndex'],
      time: json['time'],
      isCompleteTask: json['isCompleteTask'],
      isNotification: json['isNotification'],
      taskType: json['taskType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'colorIndex': colorIndex,
      'time': time,
      'isCompleteTask': isCompleteTask,
      'isNotification': isNotification,
      'taskType': taskType,
    };
  }

}
