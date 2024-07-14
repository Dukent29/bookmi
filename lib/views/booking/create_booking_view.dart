import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert'; // Add this import
import '../../models/property.dart';
import '../../models/booking.dart'; // Add this import
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_date_picker.dart';
import '../search_properties_view.dart';
import 'payment_page.dart'; // Add this import

class CreateBookingView extends StatefulWidget {
  final Property property;

  CreateBookingView({required this.property});

  @override
  _CreateBookingViewState createState() => _CreateBookingViewState();
}

class _CreateBookingViewState extends State<CreateBookingView> {
  DateTime? _startDate;
  DateTime? _endDate;
  int _numPeople = 1;
  String _message = '';

  Future<void> _createBooking() async {
    if (_startDate == null || _endDate == null || !_startDate!.isBefore(_endDate!)) {
      setState(() {
        _message = 'Please select a start and end date';
      });
      return;
    }

    try {
      final response = await Provider.of<AuthProvider>(context, listen: false).createBooking(
        propertyId: widget.property.id,
        startDate: DateFormat('yyyy-MM-dd').format(_startDate!),
        endDate: DateFormat('yyyy-MM-dd').format(_endDate!),
        numPeople: _numPeople,
      );

      final bookingData = jsonDecode(response);
      final bookingId = bookingData['bookingId'];

      final booking = Booking(
        id: bookingId,
        propertyId: widget.property.id,
        startDate: _startDate.toString(),
        endDate: _endDate.toString(),
        totalPrice: widget.property.pricePerNight * (_endDate!.difference(_startDate!).inDays + 1),
        numPeople: _numPeople,
      );

      setState(() {
        _message = 'Booking created successfully';
      });

      // Navigate to PaymentPage
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentPage(booking: booking),
        ),
      );
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
              decoration: InputDecoration(labelText: 'Number of People'),
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
