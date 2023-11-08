import 'package:employees_assignment_flutter/models/employee.dart';

abstract class EmployeeState {}

class EmployeesInitialState extends EmployeeState {}

class EmployeesLoadingState extends EmployeeState {}

class EmployeesSuccessState extends EmployeeState {
  List<Employee> currentEmployees;
  List<Employee> previousEmployees;

  EmployeesSuccessState(
      {required this.currentEmployees, required this.previousEmployees});
}

class ZeroEmployeesState extends EmployeesSuccessState {
  ZeroEmployeesState({required super.currentEmployees, required super.previousEmployees});
}

class EmployeesErrorState extends EmployeeState {
  String message;

  EmployeesErrorState(this.message);
}
