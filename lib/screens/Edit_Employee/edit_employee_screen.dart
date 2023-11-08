import 'package:employees_assignment_flutter/blocs/Employees_Bloc/employees_bloc.dart';
import 'package:employees_assignment_flutter/blocs/Employees_Bloc/employees_events.dart';
import 'package:employees_assignment_flutter/blocs/Employees_Bloc/employees_states.dart';
import 'package:employees_assignment_flutter/models/employee.dart';
import 'package:employees_assignment_flutter/widgets/employee_details_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditEmployeeScreen extends StatelessWidget {
  final Employee employee;
  const EditEmployeeScreen({super.key,required this.employee});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Employee Details"),
        automaticallyImplyLeading: false,
        actions:  [Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: IconButton(
            onPressed: (){
              BlocProvider.of<EmployeesBloc>(context).add(DeleteEmployeeEvent(employee.id!));
            },
            icon: const ImageIcon(
              AssetImage('assets/icons/delete.png'),
              size: 18,
              color: Colors.white,
            ),
          ),
        )],
      ),
      body: BlocListener<EmployeesBloc,EmployeeState>(
        listener: (ctx,state){
          if(state is EmployeesSuccessState){
            String message=state.operation==Operation.delete?"Employee deleted!":"Employee modified!";
            ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text(message)));
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
                  child: EmployeeDetailsForm(employee: employee,),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
