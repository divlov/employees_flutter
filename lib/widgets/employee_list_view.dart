import 'package:employees_assignment_flutter/blocs/Employees_Bloc/employees_bloc.dart';
import 'package:employees_assignment_flutter/blocs/Employees_Bloc/employees_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../models/employee.dart';

class EmployeesListView extends StatelessWidget {
  final List<Employee> employees;
  final String title;
  final double? listHeight;
  final GlobalKey<AnimatedListState> listKey = GlobalKey();

  EmployeesListView({super.key, required this.employees, required this.title,this.listHeight});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
          child: Text(title, style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16,color: Theme.of(context).primaryColor)),
        ),
        SizedBox(
          height: listHeight,
          child: AnimatedList(
              key: listKey,
              shrinkWrap: true,
              initialItemCount: employees.length,
              itemBuilder: (ctx, index, animation) {
                final employee = employees[index];
                return Dismissible(
                  key: ValueKey(employee.id),
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
                    bool wantsToDelete = true;
                    Future.delayed(const Duration(seconds: 3, milliseconds: 20),
                        () {
                      if (wantsToDelete) {
                        BlocProvider.of<EmployeesBloc>(context)
                            .add(DeleteEmployeeEvent(employee.id!));
                      }
                    });
                    final deletedItem = employees.removeAt(index);
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
                          wantsToDelete = false;
                          employees.insert(index, deletedItem);
                          listKey.currentState!.insertItem(index);
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
                                    getEmployeeRoleString(employee.employeeRole),
                                    style: TextStyle(
                                        color: Theme.of(context).hintColor),
                                  ),
                                ),
                                Text(
                                  "From ${DateFormat("d MMM y").format(employee.fromDate)}",
                                  style:  TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(context).hintColor),
                                ),
                              ],
                            ),
                          ),
                          if (index != employees.length - 1)
                            const Divider(height: 1),
                        ],
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
