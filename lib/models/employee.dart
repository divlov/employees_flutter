import 'package:employees_assignment_flutter/repositories/db_helper.dart';

enum EmployeeRole { productDesigner, flutterDeveloper, qaTester, productOwner }

String getEmployeeRoleString(EmployeeRole employeeRole) {
  switch (employeeRole) {
    case EmployeeRole.flutterDeveloper:
      return "Flutter Developer";
    case EmployeeRole.productDesigner:
      return "Product Designer";
    case EmployeeRole.productOwner:
      return "Product Owner";
    case EmployeeRole.qaTester:
      return "QA Tester";
  }
}

EmployeeRole getEmployeeRole(String employeeRole) {
  switch (employeeRole) {
    case "Flutter Developer":
      return EmployeeRole.flutterDeveloper;
    case "Product Designer":
      return EmployeeRole.productDesigner;
    case "Product Owner":
      return EmployeeRole.productOwner;
    //since the only role left is qa tester
    default:
      return EmployeeRole.qaTester;
  }
}

class Employee {
  final int? id;
  final String name;
  final EmployeeRole employeeRole;
  final DateTime fromDate;
  final DateTime? tillDate;

  const Employee(
      {required this.name,
      required this.employeeRole,
      required this.fromDate,
      this.tillDate,
      this.id});

  Employee.fromMap(Map<String, Object?> map)
      : name = map[DBHelper.nameColumn] as String,
        employeeRole = getEmployeeRole(map[DBHelper.roleColumn] as String),
        fromDate = DateTime.parse(map[DBHelper.fromDateColumn] as String),
        tillDate =map[DBHelper.tillDateColumn]!=null? DateTime.parse(map[DBHelper.tillDateColumn] as String):null,
        id = map[DBHelper.idColumn] as int?;
}
