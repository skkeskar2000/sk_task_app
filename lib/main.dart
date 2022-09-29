import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sk_task/features/presentation/cubit/task_cubit.dart';
import 'package:sk_task/features/presentation/screens/home_screen.dart';
import 'package:sk_task/on_generate_route.dart';
import 'injection_container.dart' as di;

void main() async {
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<TaskCubit>(
      create: (context) => di.sl<TaskCubit>()..openDatabase()..initNotification(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: Colors.indigoAccent,
        ),
        onGenerateRoute: OnGenerateRoute.route,
        routes: {
          "/": (context) {
            return const HomeScreen();
          }
        },
      ),
    );
  }
}
