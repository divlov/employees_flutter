import 'dart:developer';

import 'package:employees_assignment_flutter/models/employee.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper._();

  static final DBHelper _instance = DBHelper._();

  static const tableName = "user_employees";
  static const idColumn = "id";
  static const nameColumn = "name";
  static const roleColumn = "role";
  static const fromDateColumn = "from_date";
  static const tillDateColumn = "till_date";

  factory DBHelper.getInstance() {
    return _instance;
  }

  Future<Database> _database() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(join(dbPath, 'employees.db'), version: 1,
        onCreate: (db, version) {
      db.execute(
          'CREATE TABLE $tableName($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT NOT NULL, $roleColumn TEXT NOT NULL, $fromDateColumn TEXT NOT NULL, $tillDateColumn TEXT)');
    });
  }

  Future<void> insert(Employee employee) async {
    final sqlDB = await _database();
    String role = getEmployeeRoleString(employee.employeeRole);
    final data = {
      "name": employee.name,
      "role": role,
      "from_date": employee.fromDate.toIso8601String(),
      if (employee.tillDate != null)
        "till_date": employee.tillDate!.toIso8601String(),
    };
    final int code = await sqlDB.insert(tableName, data,
        conflictAlgorithm: ConflictAlgorithm.abort);

    //0 could be returned for some specific conflict algorithms if not inserted
    if (code == 0) {
      throw Exception("Some error occurred");
    }
  }

  Future<int> remove(int id) async {
    final sqlDB = await _database();
    return await sqlDB.delete(tableName, where: "id=?", whereArgs: [id]);
  }

  Future<int> update(Employee employee) async {
    final sqlDB = await _database();
    String role = getEmployeeRoleString(employee.employeeRole);
    final data = {
      "id": employee.id,
      "name": employee.name,
      "role": role,
      "from_date": employee.fromDate.toIso8601String(),
      if (employee.tillDate != null)
        "till_date": employee.tillDate!.toIso8601String(),
    };
    return await sqlDB
        .update(tableName, data, where: 'id = ?', whereArgs: [employee.id]);
  }

  Future<List<Employee>> getData() async {
    final sqlDB = await _database();
    final List<Employee> employees = [];
    final listOfMapsOfEmployeeData = await sqlDB.query(tableName);
    log("$listOfMapsOfEmployeeData", name: "DBHelper");
    log("${DateTime.parse("2023-11-08T03:59:22.562094")}", name: "DBHelper");
    for (var map in listOfMapsOfEmployeeData) {
      employees.add(Employee.fromMap(map));
    }
    log("$listOfMapsOfEmployeeData", name: "DBHelper");
    log("$employees", name: "DBHelper");
    return employees;
  }
}
