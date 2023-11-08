import 'package:employees_assignment_flutter/extensions/date_time_extensions.dart';
import 'package:employees_assignment_flutter/models/custom_icons.dart';
import 'package:employees_assignment_flutter/widgets/blue_text_button.dart';
import 'package:employees_assignment_flutter/widgets/divider_screen_width.dart';
import 'package:employees_assignment_flutter/widgets/light_blue_secondary_text_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class TillDateCalendar extends StatefulWidget {
  DateTime? selectedDay;
  DateTime firstDay;

  TillDateCalendar({super.key, this.selectedDay, required this.firstDay});

  @override
  State<TillDateCalendar> createState() => _TillDateCalendarState();
}

class _TillDateCalendarState extends State<TillDateCalendar> {
  void Function(void Function())? setLeftChevronIconState;
  late DateTime focusedDay;

  @override
  void initState() {
    // TODO: implement initState
    focusedDay = widget.firstDay;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
            constraints: BoxConstraints(
                maxWidth: orientation == Orientation.portrait
                    ? MediaQuery.of(context).size.width * 0.93
                    : MediaQuery.of(context).size.width * 0.6),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
            child: SingleChildScrollView(
              child: Material(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Expanded(
                                child: BlueTextButton(
                                    text: "No date",
                                    onPressed: () {
                                      setState(() {
                                        widget.selectedDay = null;
                                      });
                                    })),
                            const SizedBox(width: 12),
                            Expanded(
                                child: LightBlueSecondaryTextButton(
                                    text: 'Today',
                                    onPressed: () {
                                      setState(() {
                                        widget.selectedDay = DateTime.now();
                                        focusedDay = DateTime.now();
                                      });
                                    }))
                          ],
                        ),
                      ),
                      TableCalendar(
                        availableGestures: AvailableGestures.horizontalSwipe,
                        headerStyle: HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                          titleTextStyle: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                          leftChevronIcon:
                              StatefulBuilder(builder: (context, setState) {
                            setLeftChevronIconState = setState;
                            return Icon(Icons.arrow_left,
                                color: (focusedDay.month ==
                                            widget.firstDay.month &&
                                        focusedDay.year == widget.firstDay.year)
                                    ? const Color(
                                        0xFFE5E5E5) // disabled color when there's no earlier selectable month to swipe to
                                    : const Color(0xFF949C9E),
                                //enabled color
                                size: 30);
                          }),
                          rightChevronIcon: const Icon(Icons.arrow_right,
                              color: Color(0xFF949C9E), size: 30),
                          leftChevronPadding: EdgeInsets.zero,
                          rightChevronPadding: EdgeInsets.zero,
                        ),
                        firstDay: widget.firstDay,
                        lastDay: DateTime.utc(2070, 3, 14),
                        focusedDay: focusedDay,
                        calendarStyle: CalendarStyle(
                          selectedDecoration: const BoxDecoration(),
                          todayDecoration: const BoxDecoration(),
                          todayTextStyle: TextStyle(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .color),
                          selectedTextStyle:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        selectedDayPredicate: (day) {
                          return isSameDay(widget.selectedDay, day);
                        },
                        onDaySelected: (selectedDay, focusedDay_) {
                          setState(() {
                            widget.selectedDay = selectedDay;
                            focusedDay = focusedDay_;
                          });
                        },
                        onPageChanged: (focusedDay_) {
                          focusedDay = focusedDay_;
                          if (setLeftChevronIconState != null) {
                            setLeftChevronIconState!(() {});
                          }
                        },
                      ),
                      const SizedBox(height: 60),
                      const DividerScreenWidth(),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Row(
                              children: [
                                Icon(CustomIcons.calendar,
                                    color: Theme.of(context).primaryColor),
                                const SizedBox(width: 5),
                                Text(widget.selectedDay != null
                                    ? DateFormat("d MMM y")
                                        .format(widget.selectedDay!)
                                    : "No date"),
                              ],
                            ),
                            const Spacer(),
                            LightBlueSecondaryTextButton(
                                text: 'Cancel',
                                onPressed: () {
                                  Navigator.of(context).pop();
                                }),
                            const SizedBox(width: 12),
                            BlueTextButton(
                                text: 'Save',
                                onPressed: () {
                                  Navigator.of(context).pop(widget.selectedDay);
                                })
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
