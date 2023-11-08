import 'dart:async';

import 'package:employees_assignment_flutter/blocs/Employees_Bloc/employees_bloc.dart';
import 'package:employees_assignment_flutter/blocs/Employees_Bloc/employees_events.dart';
import 'package:employees_assignment_flutter/extensions/extensions.dart';
import 'package:employees_assignment_flutter/models/custom_icons.dart';
import 'package:employees_assignment_flutter/models/employee.dart';
import 'package:employees_assignment_flutter/theme/themes.dart';
import 'package:employees_assignment_flutter/widgets/action_item_modal_bottom_sheet.dart';
import 'package:employees_assignment_flutter/widgets/blue_text_button.dart';
import 'package:employees_assignment_flutter/widgets/calendar.dart';
import 'package:employees_assignment_flutter/widgets/divider_screen_width.dart';
import 'package:employees_assignment_flutter/widgets/light_blue_secondary_text_button.dart';
import 'package:employees_assignment_flutter/widgets/till_date_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class EmployeeDetailsForm extends StatefulWidget {
  Employee? employee;

  EmployeeDetailsForm({super.key, this.employee});

  @override
  State<EmployeeDetailsForm> createState() => _EmployeeDetailsFormState();
}

class _EmployeeDetailsFormState extends State<EmployeeDetailsForm> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController roleController = TextEditingController();

  final TextEditingController fromDateController = TextEditingController()
    ..text = "Today";
  final TextEditingController tillDateController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final _nameKey = GlobalKey(debugLabel: 'inputText');

  final _roleKey = GlobalKey(debugLabel: 'inputText');

  DateTime _selectedFromDay = DateTime.now();
  EmployeeRole? _selectedEmployeeRole;
  DateTime? _selectedTillDay;

  @override
  void initState() {
    // TODO: implement initState
    if (widget.employee != null) {
      nameController.text = widget.employee!.name;
      _selectedEmployeeRole = widget.employee!.employeeRole;
      roleController.text = getEmployeeRoleString(_selectedEmployeeRole!);
      _selectedFromDay = widget.employee!.fromDate;
      fromDateController.text = _selectedFromDay.day == DateTime.now().day
          ? "Today"
          : DateFormat(Themes.dateFormatStyle).format(_selectedFromDay);
      _selectedTillDay = widget.employee!.tillDate;
      if (_selectedTillDay != null) {
        tillDateController.text =
            DateFormat(Themes.dateFormatStyle).format(_selectedTillDay!);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              TextFormField(
                key: _nameKey,
                controller: nameController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFE5E5E5))),
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFE5E5E5))),
                  contentPadding: EdgeInsets.zero,
                  hintText: "Employee name",
                  hintStyle: TextStyle(color: Theme.of(context).hintColor),
                  prefixIcon: const Icon(Icons.person_outlined),
                  prefixIconColor: Theme.of(context).colorScheme.primary,
                ),
                textCapitalization: TextCapitalization.words,
                validator: (text) {
                  if (text!.isEmpty) {
                    return "Please enter name";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                key: _roleKey,
                controller: roleController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFE5E5E5))),
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFE5E5E5))),
                  contentPadding: EdgeInsets.zero,
                  hintText: "Select Role",
                  hintStyle: TextStyle(color: Theme.of(context).hintColor),
                  prefixIcon: const Icon(Icons.work_outline),
                  prefixIconColor: Theme.of(context).colorScheme.primary,
                  suffixIcon: const Icon(Icons.arrow_drop_down),
                  suffixIconColor: Theme.of(context).colorScheme.primary,
                ),
                readOnly: true,
                onTap: () async {
                  final employeeRole =
                      await showEmployeeRoleBottomSheet(context);
                  if (employeeRole != null) {
                    _selectedEmployeeRole = employeeRole;
                    roleController.text =
                        getEmployeeRoleString(_selectedEmployeeRole!);
                  }
                },
                validator: (_) {
                  if (_selectedEmployeeRole == null) {
                    return "Please select an employee role";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Flexible(
                    child: TextFormField(
                      controller: fromDateController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFE5E5E5))),
                        contentPadding: EdgeInsets.zero,
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFE5E5E5))),
                        prefixIcon: const Icon(CustomIcons.calendar),
                        prefixIconColor: Theme.of(context).colorScheme.primary,
                      ),
                      readOnly: true,
                      onTap: () => handleFromDateTap(context),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Icon(
                      CustomIcons.rightArrowIcon,
                      color: Theme.of(context).primaryColor,
                      size: 10,
                    ),
                  ),
                  Flexible(
                    child: TextFormField(
                      controller: tillDateController,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFE5E5E5))),
                          contentPadding: EdgeInsets.zero,
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFE5E5E5))),
                          prefixIcon: const Icon(CustomIcons.calendar),
                          prefixIconColor:
                              Theme.of(context).colorScheme.primary,
                          hintText: "No date",
                          hintStyle:
                              TextStyle(color: Theme.of(context).hintColor)),
                      readOnly: true,
                      onTap: () => handleTillDateTap(context),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            children: [
              const DividerScreenWidth(),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  LightBlueSecondaryTextButton(
                      text: 'Cancel',
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                  const SizedBox(width: 8),
                  BlueTextButton(
                      text: 'Save',
                      onPressed: () {
                        submitForm();
                      }),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  void submitForm() async {
    FocusScope.of(context).unfocus();
    if (!formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    if (widget.employee == null) {
      BlocProvider.of<EmployeesBloc>(context).add(AddEmployeeEvent(Employee(
          name: nameController.text.trim().capitalizeAllWords(),
          employeeRole: _selectedEmployeeRole!,
          fromDate: _selectedFromDay,
          tillDate: _selectedTillDay)));
    } else {
      BlocProvider.of<EmployeesBloc>(context).add(ModifyEmployeeEvent(Employee(
          id: widget.employee!.id,
          name: nameController.text,
          employeeRole: _selectedEmployeeRole!,
          fromDate: _selectedFromDay,
          tillDate: _selectedTillDay)));
    }
  }

  Future<void> handleFromDateTap(BuildContext context) async {
    final selectedDay = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return Calendar(
            selectedDay: _selectedFromDay,
          );
        });
    if (selectedDay != null) {
      _selectedFromDay = selectedDay;
      if (_selectedFromDay.day == DateTime.now().day) {
        fromDateController.text = "Today";
      } else {
        fromDateController.text =
            DateFormat(Themes.dateFormatStyle).format(_selectedFromDay);
      }
    }
  }

  Future<void> handleTillDateTap(BuildContext context) async {
    _selectedTillDay = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return TillDateCalendar(
            firstDay: _selectedFromDay,
            selectedDay: _selectedTillDay,
          );
        });
    if (_selectedTillDay != null) {
      if (_selectedTillDay!.day == DateTime.now().day) {
        tillDateController.text = "Today";
      } else {
        tillDateController.text =
            DateFormat(Themes.dateFormatStyle).format(_selectedTillDay!);
      }
    } else {
      tillDateController.clear();
    }
  }

  Future<T?> showEmployeeRoleBottomSheet<T>(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return const SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ActionItemModalBottomSheet(
                    employeeRole: EmployeeRole.productDesigner),
                Divider(),
                ActionItemModalBottomSheet(
                    employeeRole: EmployeeRole.flutterDeveloper),
                Divider(),
                ActionItemModalBottomSheet(employeeRole: EmployeeRole.qaTester),
                Divider(),
                ActionItemModalBottomSheet(
                    employeeRole: EmployeeRole.productOwner),
              ],
            ),
          );
        });
  }
}
