
import 'package:sk_task/features/domain/entities/task_entity.dart';
import 'package:sk_task/features/domain/repositories/local_repository.dart';

class DeleteTaskUseCase{
  final LocalRepository localRepository;

  DeleteTaskUseCase({required this.localRepository});

  Future<bool>call(TaskEntity task){
    return localRepository.deleteTask(task);
  }
}
