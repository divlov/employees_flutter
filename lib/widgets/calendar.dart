import 'package:employees_assignment_flutter/extensions/date_time_extensions.dart';
import 'package:employees_assignment_flutter/models/custom_icons.dart';
import 'package:employees_assignment_flutter/widgets/blue_text_button.dart';
import 'package:employees_assignment_flutter/widgets/divider_screen_width.dart';
import 'package:employees_assignment_flutter/widgets/light_blue_secondary_text_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  DateTime selectedDay;

  Calendar({super.key, required this.selectedDay});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late DateTime focusedDay;

  @override
  void initState() {
    focusedDay = widget.selectedDay;
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
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: LightBlueSecondaryTextButton(
                                        text: "Today",
                                        onPressed: () {
                                          setState(() {
                                            widget.selectedDay = DateTime.now();
                                            focusedDay = DateTime.now();
                                          });
                                        })),
                                const SizedBox(width: 12),
                                Expanded(
                                    child: BlueTextButton(
                                        text: 'Next Monday',
                                        onPressed: () {
                                          setState(() {
                                            widget.selectedDay = DateTime.now()
                                                .next(DateTime.monday);
                                            focusedDay = DateTime.now()
                                                .next(DateTime.monday);
                                          });
                                        }))
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Expanded(
                                    child: LightBlueSecondaryTextButton(
                                        text: "Next Tuesday",
                                        onPressed: () {
                                          setState(() {
                                            widget.selectedDay = DateTime.now()
                                                .next(DateTime.tuesday);
                                            focusedDay = DateTime.now()
                                                .next(DateTime.tuesday);
                                          });
                                        })),
                                const SizedBox(width: 12),
                                Expanded(
                                    child: LightBlueSecondaryTextButton(
                                        text: 'After 1 week',
                                        onPressed: () {
                                          setState(() {
                                            widget.selectedDay = DateTime.now()
                                                .add(const Duration(days: 7));
                                            focusedDay = DateTime.now()
                                                .add(const Duration(days: 7));
                                          });
                                        }))
                              ],
                            ),
                          ],
                        ),
                      ),
                      TableCalendar(
                        availableGestures: AvailableGestures.horizontalSwipe,
                        headerStyle: const HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                          titleTextStyle: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                          leftChevronIcon: Icon(Icons.arrow_left,
                              color: Color(0xFF949C9E), size: 30),
                          rightChevronIcon: Icon(Icons.arrow_right,
                              color: Color(0xFF949C9E), size: 30),
                          leftChevronPadding: EdgeInsets.zero,
                          rightChevronPadding: EdgeInsets.zero,
                        ),
                        firstDay: DateTime.utc(2010, 10, 16),
                        lastDay: DateTime.utc(2030, 3, 14),
                        focusedDay: focusedDay,
                        calendarStyle: CalendarStyle(
                          selectedDecoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.circle,
                          ),
                          todayTextStyle:
                              TextStyle(color: Theme.of(context).primaryColor),
                          todayDecoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                                color: Theme.of(context).primaryColor),
                            shape: BoxShape.circle,
                          ),
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
                                Text(DateFormat("d MMM y")
                                    .format(widget.selectedDay)),
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
