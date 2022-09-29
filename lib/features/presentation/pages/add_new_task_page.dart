import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sk_task/features/domain/entities/task_entity.dart';
import 'package:sk_task/features/presentation/cubit/task_cubit.dart';
import 'package:sk_task/features/presentation/widgets/common.dart';
import 'package:intl/intl.dart';
import 'package:sk_task/features/presentation/widgets/theme/style.dart';

class AddNewTaskPage extends StatefulWidget {
  const AddNewTaskPage({Key? key}) : super(key: key);

  @override
  State<AddNewTaskPage> createState() => _AddNewTaskPageState();
}

class _AddNewTaskPageState extends State<AddNewTaskPage> {
  final TextEditingController _taskTextController = TextEditingController();

  int _selectedTaskTypeIndex = 0;
  DateTime _selectedTime = DateTime.now();
  bool _taskAdded = false;

  @override
  void dispose() {
    _taskTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Task'),
      ),
      body: !_taskAdded
          ? Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _addNewTaskWidget(),
                  _divider(),
                  _taskTypeWidget(),
                  _divider(),
                  _chooseTimeWidget(),
                  _addTaskButtonWidget(),
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  _addNewTaskWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.blueGrey.withOpacity(.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Scrollbar(
        thickness: 6,
        child: TextField(
          controller: _taskTextController,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: "e.g morning walk",
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  _divider() {
    return Column(
      children: const [
        SizedBox(height: 10),
        Divider(thickness: 1.5),
        SizedBox(height: 10),
      ],
    );
  }

  _taskTypeWidget() {
    return SizedBox(
      height: 20,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: taskTypeList.map((name) {
          var index = taskTypeList.indexOf(name);
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedTaskTypeIndex = index;
              });
            },
            child: _selectedTaskTypeIndex == index
                ? Container(
                    padding: const EdgeInsets.only(left: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        color: taskTypeListColor[index],
                      ),
                      child: Text(
                        name,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                      children: [
                        Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            color: taskTypeListColor[index],
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          name,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
          );
        }).toList(),
      ),
    );
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked_s = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child!,
          );
        });

    if (picked_s != null &&
        picked_s !=
            TimeOfDay(hour: _selectedTime.hour, minute: _selectedTime.minute)) {
      setState(() {
        _selectedTime = DateTime(_selectedTime.year, _selectedTime.month,
            _selectedTime.day, picked_s.hour, picked_s.minute);
      });
    }
  }

  _chooseTimeWidget() {
    return GestureDetector(
      onTap: () {
        _selectTime();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Choose Time",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
              "${DateFormat("hh:mm a").format(DateTime.now())} - ${DateFormat("hh:mm a").format(_selectedTime)}"),
        ],
      ),
    );
  }

  _addTaskButtonWidget() {
    return Expanded(
        child: GestureDetector(
      onTap: submitNewTask,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 50,
          alignment: Alignment.center,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(
              colors: [
                Colors.indigo,
                color6FADE4,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Text(
            'Add task',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    ));
  }

  void submitNewTask() {
    if (_taskTextController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Type Something",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    BlocProvider.of<TaskCubit>(context).addNewTask(
      task: TaskEntity(
        taskType: taskTypeList[_selectedTaskTypeIndex],
        title: _taskTextController.text,
        colorIndex: _selectedTaskTypeIndex.toString(),
        time: _selectedTime.toString(),
        isCompleteTask: false,
        isNotification: false,
      ),
    );
    setState((){
      _taskAdded = true;
    });
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: "Task Added Successfully..",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0);
    });
  }
}
