import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../providers/auth_provider.dart';

class BlockDatesView extends StatefulWidget {
  @override
  _BlockDatesViewState createState() => _BlockDatesViewState();
}

class _BlockDatesViewState extends State<BlockDatesView> {
  DateTime? _startDate;
  DateTime? _endDate;
  Map<DateTime, List> _events = {};
  String _message = '';

  @override
  void initState() {
    super.initState();
  }


  Future<void> _blockDates() async {
    if (_startDate == null || _endDate == null) {
      setState(() {
        _message = 'Veuillez sélectionner les dates de début et de fin';
      });
      return;
    }

    try {
      await Provider.of<AuthProvider>(context, listen: false).blockDates(
        propertyId: 1, // Replace with dynamic property ID as needed
        startDate: _startDate!,
        endDate: _endDate!,
      );
      setState(() {
        _message = 'Dates bloquées avec succès';
      });
    } catch (e) {
      setState(() {
        _message = 'Échec du blocage des dates: ${e.toString()}';
      });
    }
  }

  void _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _startDate)
      setState(() {
        _startDate = picked;
      });
  }

  void _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _endDate)
      setState(() {
        _endDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Blocker les dates', style: TextStyle(color: Colors.white, fontFamily: 'Poppins'))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TableCalendar(
              focusedDay: DateTime.now(),
              firstDay: DateTime(2020),
              lastDay: DateTime(2101),
              calendarFormat: CalendarFormat.month,
              eventLoader: (day) {
                return _events[day] ?? [];
              },
            ),
            ElevatedButton(
              onPressed: () => _selectStartDate(context),
              child: Text('Sélectionnez la date de début'),
            ),
            Text(_startDate == null ? 'Aucune date de début sélectionnée' : _startDate.toString()),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _selectEndDate(context),
              child: Text('Sélectionnez la date de fin'),
            ),
            Text(_endDate == null ? 'Aucune date de fin sélectionnée' : _endDate.toString()),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _blockDates,
              child: Text('Dates de blocage'),
            ),
            SizedBox(height: 16.0),
            if (_message.isNotEmpty)
              Text(
                _message,
                style: TextStyle(color: _message.contains('success') ? Colors.green : Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
