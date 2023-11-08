import 'package:employees_assignment_flutter/models/employee.dart';

abstract class EmployeesEvent{}

class FetchEmployeesEvent extends EmployeesEvent{}

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