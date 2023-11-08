import 'package:employees_assignment_flutter/blocs/Employees_Bloc/employees_bloc.dart';
import 'package:employees_assignment_flutter/blocs/Employees_Bloc/employees_states.dart';
import 'package:employees_assignment_flutter/widgets/employee_details_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddEmployeeScreen extends StatelessWidget {
  const AddEmployeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Employee Details"),
        automaticallyImplyLeading: false,
      ),
      body: BlocListener<EmployeesBloc,EmployeeState>(
          listener: (ctx,state){
            if(state is EmployeesSuccessState){
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Employee added!")));
              Navigator.of(context).pop();
            }
            else if(state is EmployeesErrorState){
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Some error occurred!")));
            }
          },
        child: LayoutBuilder(
          builder:(ctx,constraint)=> SafeArea(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraint.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                  child: EmployeeDetailsForm(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
