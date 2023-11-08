import 'package:employees_assignment_flutter/models/employee.dart';

enum Operation{
  add,
  fetch,
  modify,
  delete
}
abstract class EmployeeState {}

class EmployeesInitialState extends EmployeeState {}

class EmployeesLoadingState extends EmployeeState {}

class EmployeesSuccessState extends EmployeeState {
  List<Employee> currentEmployees;
  List<Employee> previousEmployees;
  Operation operation;

  EmployeesSuccessState(
      {required this.currentEmployees, required this.previousEmployees,required this.operation});
}

class ZeroEmployeesState extends EmployeesSuccessState {
  ZeroEmployeesState({required super.currentEmployees, required super.previousEmployees,required super.operation});
}

class EmployeesErrorState extends EmployeeState {
  String message;

  EmployeesErrorState(this.message);
}
