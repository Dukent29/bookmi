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
        _message = 'Veuillez sélectionner une date de début et de fin valide';
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
        _message = 'Dates bloquées avec succès';
        _fetchBlockedDates();
      });
      _showSuccessDialog();
    } catch (e) {
      setState(() {
        _message = 'Échec du blocage des dates: ${e.toString()}';
      });
    }
  }

  Future<void> _unblockDate(int blockedDateId) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.unblockDate(blockedDateId);
      setState(() {
        _message = 'Date de déblocage réussie';
        _fetchBlockedDates();
      });
    } catch (e) {
      setState(() {
        _message = 'Échec du déblocage de la date: ${e.toString()}';
      });
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Succès', style: TextStyle(fontFamily: 'Poppins')),
        content: Text('Dates bloquées avec succès', style: TextStyle(fontFamily: 'Poppins')),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Navigate back to the previous page
            },
            child: Text('OK', style: TextStyle(fontFamily: 'Poppins', color: Color(0xFFF7B818))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier le calendrier', style: TextStyle(fontFamily: 'Poppins')),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF000000), Color(0xFF292A32)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Background color of the calendar
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(16.0),
                child: TableCalendar(
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
                    todayTextStyle: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                    selectedTextStyle: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                    defaultTextStyle: TextStyle(color: Colors.black, fontFamily: 'Poppins'),
                  ),
                  headerStyle: HeaderStyle(
                    titleTextStyle: TextStyle(color: Colors.black, fontFamily: 'Poppins'),
                    formatButtonTextStyle: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                    formatButtonDecoration: BoxDecoration(
                      color: Colors.blue, // Change this color to your preferred one
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    leftChevronIcon: Icon(Icons.chevron_left, color: Colors.black),
                    rightChevronIcon: Icon(Icons.chevron_right, color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              if (_startDate != null && _endDate != null)
                Text(
                  'Modifier le calendrierDates sélectionnées: ${DateFormat('yyyy-MM-dd').format(_startDate!)} - ${DateFormat('yyyy-MM-dd').format(_endDate!)}',
                  style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                ),
              SizedBox(height: 16.0),
              ElevatedButton.icon(
                onPressed: _blockDate,
                icon: Icon(Icons.block, color: Colors.white),
                label: Text('Dates de blocage', style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFF7B818), // Background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                ),
              ),
              SizedBox(height: 16.0),
              if (_message.isNotEmpty)
                Text(
                  _message,
                  style: TextStyle(color: Colors.red, fontFamily: 'Poppins'),
                ),
              SizedBox(height: 16.0),
              Expanded(
                child: ListView.builder(
                  itemCount: _blockedDates.length,
                  itemBuilder: (context, index) {
                    final blockedDate = _blockedDates[index];
                    return ListTile(
                      title: Text(
                        'A partir de: ${blockedDate['start_date']} jusqu\'à: ${blockedDate['end_date']}',
                        style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                      ),
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
      ),
    );
  }
}
