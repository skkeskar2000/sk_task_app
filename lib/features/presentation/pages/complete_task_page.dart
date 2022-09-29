import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:sk_task/features/domain/entities/task_entity.dart';
import 'package:sk_task/features/presentation/cubit/task_cubit.dart';
import 'package:sk_task/features/presentation/widgets/common.dart';
import 'package:sk_task/features/presentation/widgets/theme/style.dart';

class CompleteTaskPage extends StatefulWidget {
  const CompleteTaskPage({Key? key}) : super(key: key);

  @override
  State<CompleteTaskPage> createState() => _CompleteTaskPageState();
}

class _CompleteTaskPageState extends State<CompleteTaskPage> {
  List<TaskEntity> _taskData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TaskCubit, TaskState>(builder: (context, state) {
        if (state is TaskLoaded) {
          List<TaskEntity> completeTask = state.taskData
              .where((element) => element.isCompleteTask == true)
              .toList();
          return Column(
            children: [
              _headerWidget(completeTask),
              completeTask.isEmpty && _taskData.isNotEmpty
                  ? Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 100,
                              child: Opacity(
                                opacity: 0.5,
                                child: Image.asset('assets/tasks.png'),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'You do not hav any task',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                color: Colors.black.withOpacity(.4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : _listTaskWidget(_taskData.isEmpty?completeTask:_taskData),
            ],
          );
        }
        return CircularProgressIndicator();
      }),
    );
  }

  _headerWidget(List<TaskEntity> taskData) {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.indigo,
            color6FADE4,
          ],
          end: Alignment.topLeft,
          begin: Alignment.topRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Complete Tasks",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "you have completed ${taskData.length} task",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withOpacity(.8),
                      ),
                    ),
                  ],
                ),
                PopupMenuButton<String>(
                  itemBuilder: (_) => taskTypeList.map((value) {
                    return PopupMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onSelected: (String value) {
                    setState(() {
                      if (value == "Other"){
                        _taskData=taskData;
                      }else{
                        _taskData=taskData.where((element) => element.taskType==value).toList();
                      }
                    });
                  },
                  child: const Icon(
                    Icons.filter_list_outlined,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _listTaskWidget(List<TaskEntity> taskData) {
    return Expanded(
      child: ListView.builder(
          itemCount: taskData.length,
          itemBuilder: (context, index) {
            return _listItem(taskData[index]);
          }),
    );
  }

  _listItem(TaskEntity task) {
    return Slidable(
      enabled: true,
      closeOnScroll: true,
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          GestureDetector(
            onTap: () {},
            child: FittedBox(
              child: Container(
                height: 40,
                width: 40,
                margin: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.delete,
                      size: 16,
                      color: Colors.white,
                    ),
                    Text(
                      "Delete",
                      style: TextStyle(fontSize: 7, color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      child: Container(
        height: 60,
        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
        width: double.infinity,
        child: GestureDetector(
          onTap: () {
            AwesomeDialog(
              context: context,
              borderSide: BorderSide(color: taskTypeListColor[0], width: 2),
              width: 280,
              buttonsBorderRadius: const BorderRadius.all(Radius.circular(2)),
              headerAnimationLoop: true,
              animType: AnimType.TOPSLIDE,
              title: task.title,
              desc:
                  '${task.title}\n${DateFormat("hh:mm a").format(DateTime.parse(task.time))}',
              showCloseIcon: false,
              dialogType: DialogType.INFO,
              btnOkOnPress: () {},
            ).show();
          },
          child: Card(
            elevation: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      height: 60,
                      width: 4,
                      decoration: BoxDecoration(
                          color: taskTypeListColor[int.parse(task.colorIndex)],
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8))),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          color: true == false ? Colors.white : Colors.green,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(40),
                          ),
                          border: Border.all(color: Colors.grey)),
                      child: true == false
                          ? const Icon(
                              Icons.done,
                              color: Colors.grey,
                            )
                          : const Icon(
                              Icons.done,
                              color: Colors.white,
                            ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      DateFormat("hh:mm a").format(DateTime.parse(task.time)),
                      style: TextStyle(color: Colors.black.withOpacity(.4)),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width / 2.1,
                        child: Text(
                          task.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.black,
                              decoration: true == false
                                  ? TextDecoration.none
                                  : TextDecoration.lineThrough),
                        )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
