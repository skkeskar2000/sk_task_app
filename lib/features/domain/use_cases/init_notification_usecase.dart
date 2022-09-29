import 'package:sk_task/features/domain/repositories/local_repository.dart';

class InitNotificationUseCase{
  final LocalRepository localRepository;

  InitNotificationUseCase({required this.localRepository});

  Future<void> call(){
    return localRepository.initNotification();
  }

}