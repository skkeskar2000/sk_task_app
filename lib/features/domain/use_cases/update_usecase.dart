
import 'package:sk_task/features/domain/entities/task_entity.dart';
import 'package:sk_task/features/domain/repositories/local_repository.dart';

class UpdateUseCase{
  final LocalRepository localRepository;
  UpdateUseCase({required this.localRepository});

  Future<void> call(TaskEntity task){
    return localRepository.updateTask(task);
  }
}