import 'package:bloc/bloc.dart';
import 'package:employees_assignment_flutter/blocs/Employees_Bloc/employees_events.dart';
import 'package:employees_assignment_flutter/blocs/Employees_Bloc/employees_states.dart';
import 'package:employees_assignment_flutter/helpers/db_helper.dart';
import 'package:employees_assignment_flutter/models/employee.dart';

class EmployeesBloc extends Bloc<EmployeesEvent, EmployeeState> {
  EmployeesBloc() : super(EmployeesInitialState()) {
    on<FetchEmployeesEvent>((event, emit) async {
      emit(EmployeesLoadingState());
      try {
        final List<Employee> employees = await DBHelper.getInstance().getData();
        final List<Employee> previousEmployees=[];
        if (employees.isEmpty) {
          emit(ZeroEmployeesState(currentEmployees: [], previousEmployees: []));
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
              previousEmployees: previousEmployees));
        }
      } catch (e) {
        emit(EmployeesErrorState("Some error occurred"));
      }
    });

    add(FetchEmployeesEvent());

    on<AddEmployeeEvent>((event, emit) async {
      emit(EmployeesLoadingState());
      try {
        await DBHelper.getInstance().insert(event.employee);
      } catch (e) {
        emit(EmployeesErrorState("Some error occurred"));
      } finally {
        add(FetchEmployeesEvent());
      }
    });

    on<DeleteEmployeeEvent>((event, emit) async {
      emit(EmployeesLoadingState());
      try {
        await DBHelper.getInstance().remove(event.id);
      } catch (e) {
        emit(EmployeesErrorState("Some error occurred"));
      }
      finally {
        add(FetchEmployeesEvent());
      }
    });

    on<ModifyEmployeeEvent>((event, emit) async {
      emit(EmployeesLoadingState());
      try {
        await DBHelper.getInstance().update(event.employee);
      } catch (e) {
        emit(EmployeesErrorState("Some error occurred"));
      }
      finally {
        add(FetchEmployeesEvent());
      }
    });
  }
}
