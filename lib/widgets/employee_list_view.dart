import 'package:employees_assignment_flutter/blocs/Employees_Bloc/employees_bloc.dart';
import 'package:employees_assignment_flutter/blocs/Employees_Bloc/employees_events.dart';
import 'package:employees_assignment_flutter/screens/Edit_Employee/edit_employee_screen.dart';
import 'package:employees_assignment_flutter/theme/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../models/employee.dart';

class EmployeesListView extends StatefulWidget {
  List<Employee> employees;
  final String title;
  final double? listHeight;
  final BuildContext parentContext;

  EmployeesListView(
      {super.key,
      required this.employees,
      required this.title,
      required context,
      this.listHeight})
      : parentContext = context;

  @override
  State<EmployeesListView> createState() => _EmployeesListViewState();
}

class _EmployeesListViewState extends State<EmployeesListView> {
   GlobalKey<AnimatedListState> listKey = GlobalKey();
   late final bool isCurrentEmployeesList;

   @override
  void initState() {
     if(widget.employees[0].tillDate==null){
       isCurrentEmployeesList=true;
     }else if(widget.employees[0].tillDate!.isAfter(DateTime.now())){
       isCurrentEmployeesList=true;
     }else {
       isCurrentEmployeesList = false;
     }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant EmployeesListView oldWidget) {
    if(oldWidget.employees.length!=widget.employees.length){
      listKey=GlobalKey();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Text(
            widget.title,
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Theme.of(context).primaryColor),
          ),
        ),
        SizedBox(
          height: widget.listHeight,
          child: AnimatedList(
              key: listKey,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              initialItemCount: widget.employees.length,
              itemBuilder: (ctx, index, animation) {
                final employee = widget.employees[index];
                return Dismissible(
                  key: ValueKey(employee.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: const Color(0xFFF34642),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const ImageIcon(
                      AssetImage('assets/icons/delete.png'),
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (dismissDirection) {
                    BlocProvider.of<EmployeesBloc>(context)
                        .add(DeleteEmployeeEvent(employee.id!));
                    final deletedItem = widget.employees.removeAt(index);
                    listKey.currentState!
                        .removeItem(index, (context, animation) => Container());
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text(
                        'Employee data has been deleted',
                        style: TextStyle(fontSize: 15),
                      ),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () {
                          BlocProvider.of<EmployeesBloc>(widget.parentContext)
                              .add(AddEmployeeEvent(deletedItem));
                          widget.employees.insert(index, deletedItem);
                          listKey.currentState?.insertItem(index);
                          HapticFeedback.selectionClick();
                        },
                      ),
                      duration: const Duration(seconds: 3),
                    ));
                  },
                  confirmDismiss: (_) {
                    HapticFeedback.selectionClick();
                    return Future.value(true);
                  },
                  child: SizeTransition(
                    sizeFactor: animation,
                    child: InkWell(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>EditEmployeeScreen(employee: employee)));
                      },
                      child: DecoratedBox(
                        decoration: const BoxDecoration(color: Colors.white),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ListTile(
                              title: Text(
                                employee.name,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 6),
                                    child: Text(
                                      getEmployeeRoleString(
                                          employee.employeeRole),
                                      style: TextStyle(
                                          color: Theme.of(context).hintColor),
                                    ),
                                  ),
                                  Text( isCurrentEmployeesList?
                                    "From ${DateFormat(Themes.dateFormatStyle).format(employee.fromDate)}":
                                    "${DateFormat(Themes.dateFormatStyle).format(employee.fromDate)} - ${DateFormat(Themes.dateFormatStyle).format(employee.tillDate!)}",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Theme.of(context).hintColor),
                                  ),
                                ],
                              ),
                            ),
                            if (index != widget.employees.length - 1)
                              const Divider(height: 1),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }
}
