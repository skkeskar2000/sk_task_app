
import 'package:sk_task/features/domain/entities/task_entity.dart';
import 'package:sk_task/features/domain/repositories/local_repository.dart';

class TurnOnNotificationUseCase{
  final LocalRepository localRepository;

  TurnOnNotificationUseCase({required this.localRepository});

  Future<void> call(TaskEntity task){
    return localRepository.turnOnNotification(task);
  }

}