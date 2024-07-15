import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../providers/auth_provider.dart';

class BlockProperty extends StatefulWidget {
  final int propertyId;

  BlockProperty({required this.propertyId});

  @override
  _BlockPropertyState createState() => _BlockPropertyState();
}

class _BlockPropertyState extends State<BlockProperty> {
  DateTime? _startDate;
  DateTime? _endDate;
  String _message = '';
  List<Map<String, dynamic>> _blockedDates = [];

  @override
  void initState() {
    super.initState();
    _fetchBlockedDates();
  }

  Future<void> _fetchBlockedDates() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final blockedDates = await authProvider.getBlockedDates(widget.propertyId);
      setState(() {
        _blockedDates = blockedDates;
      });
    } catch (e) {
      setState(() {
        _message = 'Failed to load blocked dates: ${e.toString()}';
      });
    }
  }

  void _onDateSelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      if (_startDate == null || (_startDate != null && _endDate != null)) {
        _startDate = selectedDay;
        _endDate = null;
      } else if (_startDate != null && _endDate == null) {
        if (selectedDay.isBefore(_startDate!)) {
          _startDate = selectedDay;
        } else {
          _endDate = selectedDay;
        }
      }
    });
  }

  Future<void> _blockDate() async {
    if (_startDate == null || _endDate == null || !_startDate!.isBefore(_endDate!)) {
      setState(() {
        _message = 'Please select a valid start and end date';
      });
      return;
    }

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.addBlockedDate(
        propertyId: widget.propertyId,
        startDate: _startDate!,
        endDate: _endDate!,
      );
      setState(() {
        _message = 'Dates blocked successfully';
        _fetchBlockedDates();
      });
    } catch (e) {
      setState(() {
        _message = 'Failed to block dates: ${e.toString()}';
      });
    }
  }

  Future<void> _unblockDate(int blockedDateId) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.unblockDate(blockedDateId);
      setState(() {
        _message = 'Date unblocked successfully';
        _fetchBlockedDates();
      });
    } catch (e) {
      setState(() {
        _message = 'Failed to unblock date: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Calendar'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 1, 1),
              focusedDay: DateTime.now(),
              selectedDayPredicate: (day) {
                return (_startDate != null && isSameDay(_startDate, day)) ||
                    (_endDate != null && isSameDay(_endDate, day));
              },
              onDaySelected: _onDateSelected,
              rangeStartDay: _startDate,
              rangeEndDay: _endDate,
              calendarStyle: CalendarStyle(
                rangeHighlightColor: Colors.orange.withOpacity(0.5),
                rangeStartDecoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
                rangeEndDecoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            if (_startDate != null && _endDate != null)
              Text('Selected dates: ${DateFormat('yyyy-MM-dd').format(_startDate!)} - ${DateFormat('yyyy-MM-dd').format(_endDate!)}'),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _blockDate,
              child: Text('Block Dates'),
            ),
            SizedBox(height: 16.0),
            if (_message.isNotEmpty)
              Text(
                _message,
                style: TextStyle(color: Colors.red),
              ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: _blockedDates.length,
                itemBuilder: (context, index) {
                  final blockedDate = _blockedDates[index];
                  return ListTile(
                    title: Text('From: ${blockedDate['start_date']} To: ${blockedDate['end_date']}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _unblockDate(blockedDate['id']);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
