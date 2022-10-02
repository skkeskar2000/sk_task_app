import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sk_task/features/data/data_sources/local_data_source.dart';
import 'package:sk_task/features/data/models/task_model.dart';
import 'package:sk_task/features/domain/entities/task_entity.dart';
import 'package:path/path.dart';

const String MAP_STORE = "MAP_STORE_TASK";

class LocalDataSourceImpl implements LocalDataSource {
  Completer<Database>? _dbOpenCompleter;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<Database> get _db async => _dbOpenCompleter!.future;
  final _taskStore = intMapStoreFactory.store(MAP_STORE);

  Future _initDatabase() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    final dbPath = join(appDocumentDir.path, "task.db");
    final database = databaseFactoryIo.openDatabase(dbPath);
    _dbOpenCompleter!.complete(database);
  }

  @override
  Future<void> addNewTask(TaskEntity task) async {

    final newTask = TaskModel(
            id: task.id,
            title: task.title,
            colorIndex: task.colorIndex,
            time: task.time,
            isCompleteTask: task.isCompleteTask,
            isNotification: task.isNotification,
            taskType: task.taskType)
        .toJson();
    print(newTask);
    _taskStore.add(await _db, newTask);
  }

  @override
  Future<bool> deleteTask(TaskEntity task) async {
    final finder = Finder(filter: Filter.byKey(task.id));
    _taskStore.delete(await _db, finder: finder).then((value) {
      return true;
    });
    return false;
  }

  @override
  Future<List<TaskEntity>> getAllTask() async {
    final finder = Finder(sortOrders: [SortOrder('id')]);
    final recordSnapshots = await _taskStore.find(await _db, finder: finder);

    return recordSnapshots.map((task) {
      TaskEntity taskData = TaskModel.fromJson(task.value);
      taskData.id = task.key;
      return taskData;
    }).toList();
  }

  @override
  Future<void> getNotification(TaskEntity task) async {
    if (task.isNotification == false) {
      //FIXME: show notification
      final dateTime = DateTime.parse(task.time);
      final androidChannel = AndroidNotificationDetails(
          task.id.toString(), "daily task notification",
          icon: "@mipmap/ic_launcher",
          playSound: true,
          importance: Importance.max,
          priority: Priority.high
      );
      const iosChannel = IOSNotificationDetails();

      final notificationDetails = NotificationDetails(
        android: androidChannel,
        iOS: iosChannel,
      );

      flutterLocalNotificationsPlugin.showDailyAtTime(
          task.id!,
          task.title,
          "It's Time for ${task.title}",
          Time(dateTime.hour, dateTime.minute, 0),
          notificationDetails);
    } else {
      flutterLocalNotificationsPlugin.cancel(task.id!);
    }
  }

  @override
  Future<Database> openDatabase() {
    _dbOpenCompleter ??= Completer();
    _initDatabase();
    return _dbOpenCompleter!.future;
  }

  @override
  Future<void> turnOnNotification(TaskEntity task) async {
    final finder = Finder(filter: Filter.byKey(task.id));
    final newTask = TaskModel(
            id: task.id,
            title: task.title,
            colorIndex: task.colorIndex,
            time: task.time,
            isCompleteTask: task.isCompleteTask,
            isNotification: task.isNotification == true ? false : true,
            taskType: task.taskType)
        .toJson();
    _taskStore.update(
      await _db,
      newTask,
      finder: finder,
    );
  }

  @override
  Future<void> updateTask(TaskEntity task) async {
    final finder = Finder(filter: Filter.byKey(task.id));
    final newTask = TaskModel(
            id: task.id,
            title: task.title,
            colorIndex: task.colorIndex,
            time: task.time,
            isCompleteTask: task.isCompleteTask == true ? false : true,
            isNotification: task.isNotification,
            taskType: task.taskType)
        .toJson();
    _taskStore.update(
      await _db,
      newTask,
      finder: finder,
    );
  }

  @override
  Future<void> initNotification() async{
    var initializationSettingAndroid = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingIOS = const IOSInitializationSettings();

    var initializationSettings = InitializationSettings(
      android: initializationSettingAndroid,iOS: initializationSettingIOS
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
}
