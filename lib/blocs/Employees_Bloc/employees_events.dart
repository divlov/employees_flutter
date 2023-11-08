import 'package:employees_assignment_flutter/blocs/Employees_Bloc/employees_states.dart';
import 'package:employees_assignment_flutter/models/employee.dart';

abstract class EmployeesEvent{}

class FetchEmployeesEvent extends EmployeesEvent{
  Operation? operation;
  FetchEmployeesEvent({this.operation});
}

class AddEmployeeEvent extends EmployeesEvent{
  Employee employee;
  AddEmployeeEvent(this.employee);
}

class DeleteEmployeeEvent extends EmployeesEvent{
  int id;
  DeleteEmployeeEvent(this.id);
}

class ModifyEmployeeEvent extends EmployeesEvent{
  Employee employee;
  ModifyEmployeeEvent(this.employee);
}