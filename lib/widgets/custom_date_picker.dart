// widgets/custom_date_picker.dart
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomDatePicker extends StatefulWidget {
  final Function(DateTime, DateTime) onDateSelected;

  CustomDatePicker({required this.onDateSelected});

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime? _startDate;
  DateTime? _endDate;

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      if (_startDate == null || (selectedDay.isBefore(_startDate!) && _endDate == null)) {
        _startDate = selectedDay;
        _endDate = null;
      } else if (_endDate == null && selectedDay.isAfter(_startDate!)) {
        _endDate = selectedDay;
        widget.onDateSelected(_startDate!, _endDate!);
      } else {
        _startDate = selectedDay;
        _endDate = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          firstDay: DateTime.now(),
          lastDay: DateTime(2100),
          focusedDay: DateTime.now(),
          selectedDayPredicate: (day) => isSameDay(_startDate, day) || isSameDay(_endDate, day),
          onDaySelected: _onDaySelected,
          calendarFormat: CalendarFormat.month,
          startingDayOfWeek: StartingDayOfWeek.monday,
          availableCalendarFormats: const {
            CalendarFormat.month: 'Mois',
          },
        ),
        if (_startDate != null && _endDate != null)
          Text('Dates sélectionnées: ${_startDate!.toLocal()} - ${_endDate!.toLocal()}'),
      ],
    );
  }
}
