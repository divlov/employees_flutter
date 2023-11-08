import 'package:bloc/bloc.dart';
import 'package:employees_assignment_flutter/blocs/Employees_Bloc/employees_events.dart';
import 'package:employees_assignment_flutter/blocs/Employees_Bloc/employees_states.dart';
import 'package:employees_assignment_flutter/models/employee.dart';
import 'package:employees_assignment_flutter/repositories/db_helper.dart';

class EmployeesBloc extends Bloc<EmployeesEvent, EmployeeState> {
  EmployeesBloc() : super(EmployeesInitialState()) {
    on<FetchEmployeesEvent>((event, emit) async {
      // not emitting loading state since loading from local db is fairly quick
      // emit(EmployeesLoadingState());
      final operation=event.operation??Operation.fetch;
      try {
        final List<Employee> employees = await DBHelper.getInstance().getData();
        final List<Employee> previousEmployees=[];
        if (employees.isEmpty) {
          emit(ZeroEmployeesState(currentEmployees: [], previousEmployees: [],operation: operation));
        } else {
          final currentEmployees = employees.where((employee) {
           if(employee.tillDate == null) {
             return true;
           } else if(employee.tillDate!.isAfter(DateTime.now())){
             return true;
           }
           else {
             previousEmployees.add(employee);
              return false;
            }
          }).toList();
          emit(EmployeesSuccessState(currentEmployees: currentEmployees,
              previousEmployees: previousEmployees,operation: operation));
        }
      } catch (e) {
        emit(EmployeesErrorState("Some error occurred"));
      }
    });

    add(FetchEmployeesEvent());

    on<AddEmployeeEvent>((event, emit) async {
      // emit(EmployeesLoadingState());
      try {
        await DBHelper.getInstance().insert(event.employee);
      } catch (e) {
        emit(EmployeesErrorState("Some error occurred"));
      } finally {
        add(FetchEmployeesEvent(operation: Operation.add));
      }
    });

    on<DeleteEmployeeEvent>((event, emit) async {
      // emit(EmployeesLoadingState());
      try {
        await DBHelper.getInstance().remove(event.id);
      } catch (e) {
        emit(EmployeesErrorState("Some error occurred"));
      }
      finally {
        add(FetchEmployeesEvent(operation: Operation.delete));
      }
    });

    on<ModifyEmployeeEvent>((event, emit) async {
      // emit(EmployeesLoadingState());
      try {
        await DBHelper.getInstance().update(event.employee);
      } catch (e) {
        emit(EmployeesErrorState("Some error occurred"));
      }
      finally {
        add(FetchEmployeesEvent(operation: Operation.modify));
      }
    });
  }
}
