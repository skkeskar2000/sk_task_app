import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sk_task/app_const.dart';
import 'package:sk_task/features/presentation/cubit/task_cubit.dart';
import 'package:sk_task/features/presentation/pages/complete_task_page.dart';
import 'package:sk_task/features/presentation/pages/home_page.dart';
import 'package:sk_task/features/presentation/widgets/theme/style.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final iconList = [
    Icons.home,
    Icons.task,
  ];

  List<Widget> get _pages => [HomePage(), CompleteTaskPage()];
  int _pageNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: colorC80863,
        onPressed: () {
          Navigator.pushNamed(context, PageConst.addNewTaskPage).then((value) {
            BlocProvider.of<TaskCubit>(context).getAllTask();
          });
        },
        child: const Icon(
          Icons.add,
          size: 40,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _bottomNavigationBar(),
      body: _pages[_pageNavIndex],
    );
  }

  Widget _bottomNavigationBar() {
    return AnimatedBottomNavigationBar(
      activeColor: color6FADE4,
      gapLocation: GapLocation.center,
      icons: iconList,
      activeIndex: _pageNavIndex,
      onTap: (index) {
        setState(() {
          _pageNavIndex = index;
        });
      },
    );
  }
}
