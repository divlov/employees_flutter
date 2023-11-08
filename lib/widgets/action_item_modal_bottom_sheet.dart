import 'package:employees_assignment_flutter/models/employee.dart';
import 'package:flutter/material.dart';

class ActionItemModalBottomSheet extends StatelessWidget {
  final EmployeeRole employeeRole;

  const ActionItemModalBottomSheet({super.key, required this.employeeRole});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop(employeeRole);
      },
      child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            getEmployeeRoleString(employeeRole),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          )),
    );
  }
}
