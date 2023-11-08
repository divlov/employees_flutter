import 'package:employees_assignment_flutter/blocs/Employees_Bloc/employees_bloc.dart';
import 'package:employees_assignment_flutter/screens/Employee_List/employee_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>EmployeesBloc(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF1DA1F2),
              primary: const Color(0xFF1DA1F2)),
          appBarTheme: Theme.of(context).appBarTheme.copyWith(
              color: const Color(0xFF1DA1F2),
              foregroundColor: Colors.white,
              titleTextStyle:
                  const TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
          textTheme: Theme.of(context).textTheme.copyWith(
            titleMedium: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold
            )
          ),
          scaffoldBackgroundColor: const Color(0xFFF2F2F2),
          floatingActionButtonTheme: Theme.of(context)
              .floatingActionButtonTheme
              .copyWith(
                  backgroundColor: const Color(0xFF1DA1F2),
                  foregroundColor: Colors.white),
          useMaterial3: true,
          hintColor: const Color(0xFF949C9E),
        ),
        home: EmployeeListScreen(),
      ),
    );
  }
}
