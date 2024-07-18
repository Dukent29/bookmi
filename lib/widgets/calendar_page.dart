import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../providers/auth_provider.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  Map<DateTime, List<dynamic>> _bookings = {};
  List<dynamic> _selectedEvents = [];
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Fetch properties owned by the admin
    final properties = await authProvider.fetchProperties();

    if (properties.isNotEmpty) {
      final int propertyId = properties.first.id;
      final bookings = await authProvider.fetchBookings(propertyId);

      setState(() {
        _bookings = {};
        for (var booking in bookings) {
          final DateTime startDate = DateTime.parse(booking['start_date']);
          final DateTime endDate = DateTime.parse(booking['end_date']);
          for (var day = startDate; day.isBefore(endDate) || day.isAtSameMomentAs(endDate); day = day.add(Duration(days: 1))) {
            if (_bookings[day] == null) _bookings[day] = [];
            _bookings[day]!.add(booking);
          }
        }
      });
    }
  }

  List<dynamic> _getEventsForDay(DateTime day) {
    return _bookings[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendrier de réservation'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            eventLoader: _getEventsForDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
                _selectedEvents = _getEventsForDay(selectedDay);
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ListView.builder(
              itemCount: _selectedEvents.length,
              itemBuilder: (context, index) {
                final event = _selectedEvents[index];
                return ListTile(
                  title: Text('Booking ID: ${event['id']}'),
                  subtitle: Text('From: ${event['start_date']} To: ${event['end_date']}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
