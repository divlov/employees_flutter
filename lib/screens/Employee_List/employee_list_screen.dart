import 'package:employees_assignment_flutter/blocs/Employees_Bloc/employees_bloc.dart';
import 'package:employees_assignment_flutter/blocs/Employees_Bloc/employees_events.dart';
import 'package:employees_assignment_flutter/blocs/Employees_Bloc/employees_states.dart';
import 'package:employees_assignment_flutter/screens/Add_Employee/add_employee_screen.dart';
import 'package:employees_assignment_flutter/widgets/blue_text_button.dart';
import 'package:employees_assignment_flutter/widgets/employee_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeListScreen extends StatelessWidget {
  EmployeeListScreen({super.key});
  GlobalKey currentEmployeesListKey=GlobalKey();
  GlobalKey previousEmployeesListKey=GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Employee List"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (ctx) => const AddEmployeeScreen()));
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<EmployeesBloc, EmployeeState>(builder: (ctx, state) {
        if (state is EmployeesLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        else if (state is ZeroEmployeesState) {
          return Center(
            child: Image.asset(
              'assets/images/not_found.png',
              width: 261.79,
              height: 244.38,
            ),
          );
        } else if (state is EmployeesSuccessState) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.currentEmployees.isNotEmpty)
                  EmployeesListView(
                    key: currentEmployeesListKey,
                      employees: state.currentEmployees,
                      title: "Current Employees",
                  context: context,),
                if (state.previousEmployees.isNotEmpty)
                  EmployeesListView(
                    key: previousEmployeesListKey,
                      employees: state.previousEmployees,
                      title: "Previous Employees",
                  context: context,),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15, top: 10,bottom: 30),
                  child: Text(
                    'Swipe left to delete',
                    style: TextStyle(color: Theme.of(context).hintColor),
                  ),
                ),
              ],
            ),
          );
        } else if(state is EmployeesErrorState) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text("Some error occurred",
                    style: Theme.of(context).textTheme.headlineMedium),
              ),
              const SizedBox(height: 10),
              BlueTextButton(
                  text: 'Try again',
                  onPressed: () {
                    BlocProvider.of<EmployeesBloc>(context)
                        .add(FetchEmployeesEvent());
                  })
            ],
          );
        } else{
          return const SizedBox();
        }
      }),
    );
  }
}
