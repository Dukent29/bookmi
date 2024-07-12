import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/property.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_date_picker.dart';
import '../search_properties_view.dart';

class CreateBookingView extends StatefulWidget {
  final Property property;

  CreateBookingView({required this.property});

  @override
  _CreateBookingViewState createState() => _CreateBookingViewState();
}

class _CreateBookingViewState extends State<CreateBookingView> {
  DateTime? _startDate;
  DateTime? _endDate;
  int _numPeople = 1;  // Add this line
  String _message = '';

  Future<void> _createBooking() async {
    if (_startDate == null || _endDate == null || !_startDate!.isBefore(_endDate!)) {
      setState(() {
        _message = 'Please select a start and end date';
      });
      return;
    }

    try {
      await Provider.of<AuthProvider>(context, listen: false).createBooking(
        propertyId: widget.property.id,
        startDate: DateFormat('yyyy-MM-dd').format(_startDate!),
        endDate: DateFormat('yyyy-MM-dd').format(_endDate!),
        numPeople: _numPeople,  // Add this line
      );
      setState(() {
        _message = 'Booking created successfully';
      });
    } catch (e) {
      setState(() {
        _message = 'Booking failed: ${e.toString()}';
      });
    }
  }

  void _onDateSelected(DateTime startDate, DateTime endDate) {
    setState(() {
      _startDate = startDate;
      _endDate = endDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Create Booking for ${widget.property.title}'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomDatePicker(onDateSelected: _onDateSelected),
            SizedBox(height: 16.0),
            if (_startDate != null && _endDate != null)
              Text('Selected dates: ${DateFormat('yyyy-MM-dd').format(_startDate!)} - ${DateFormat('yyyy-MM-dd').format(_endDate!)}'),
            SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(labelText: 'Number of People'),  // Add this block
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _numPeople = int.parse(value);
                });
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _createBooking,
              child: Text('Validate Reservation'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchPropertiesView(),
                  ),
                );
              },
              child: Text('Cancel'),
            ),
            SizedBox(height: 16.0),
            if (_message.isNotEmpty)
              Text(
                _message,
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
