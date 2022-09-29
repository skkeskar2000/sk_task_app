
import 'package:sk_task/features/domain/entities/task_entity.dart';
import 'package:sk_task/features/domain/repositories/local_repository.dart';

class GetAllTaskUseCase{
  final LocalRepository localRepository;

  GetAllTaskUseCase({required this.localRepository});

  Future<List<TaskEntity>> call()async{
    return await localRepository.getAllTask();
  }
}