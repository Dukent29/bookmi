import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../models/booking.dart';
import '../../../providers/auth_provider.dart';
import 'my_bookings_page.dart';

class EditMyBookingPage extends StatefulWidget {
  final Booking booking;

  EditMyBookingPage({required this.booking});

  @override
  _EditMyBookingPageState createState() => _EditMyBookingPageState();
}

class _EditMyBookingPageState extends State<EditMyBookingPage> {
  late DateTime _startDate;
  late DateTime _endDate;
  late int _numPeople;
  String _message = '';

  @override
  void initState() {
    super.initState();
    _startDate = DateTime.parse(widget.booking.startDate);
    _endDate = DateTime.parse(widget.booking.endDate);
    _numPeople = widget.booking.numPeople;
  }

  Future<void> _updateBooking() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.updateBooking(
        bookingId: widget.booking.id,
        startDate: _startDate,
        endDate: _endDate,
        numPeople: _numPeople,
      );
      setState(() {
        _message = 'Booking updated successfully';
      });

      // Show success animation and navigate back to MyBookingsPage
      showDialog(
        context: context,
        builder: (BuildContext context) {
          Future.delayed(Duration(seconds: 2), () {
            Navigator.of(context).pop(true);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MyBookingsPage(
                  guestId: authProvider.userId ?? '', // Handle nullability
                ),
              ),
            );
          });
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: Column(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 50),
                SizedBox(height: 16),
                Text(
                  'Booking Updated Successfully!',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          );
        },
      );
    } catch (e) {
      setState(() {
        _message = 'Failed to update booking: $e';
      });
    }
  }

  void _onDateSelected(DateTimeRange dateRange) {
    setState(() {
      _startDate = dateRange.start;
      _endDate = dateRange.end;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Booking', style: TextStyle(fontFamily: 'Poppins')),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Edit Booking for ${widget.booking.propertyTitle}',
              style: TextStyle(
                color: Color(0xFFF7B818),
                fontWeight: FontWeight.bold,
                fontSize: 24,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Current Dates: ${DateFormat('yyyy-MM-dd').format(_startDate)} - ${DateFormat('yyyy-MM-dd').format(_endDate)}',
              style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Poppins'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                final DateTimeRange? picked = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                  initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
                );
                if (picked != null && picked != DateTimeRange(start: _startDate, end: _endDate)) {
                  _onDateSelected(picked);
                }
              },
              child: Text('Select New Dates'),
            ),
            SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'Number of People',
                labelStyle: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
              onChanged: (value) {
                setState(() {
                  _numPeople = int.parse(value);
                });
              },
              controller: TextEditingController(text: _numPeople.toString()),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _updateBooking,
              child: Text('Update Booking'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Color(0xFFF7B818),
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
          ],
        ),
      ),
    );
  }
}
