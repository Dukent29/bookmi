import 'package:flutter/material.dart';
import '../../models/booking.dart';

class BookingDetailPage extends StatelessWidget {
  final Booking booking;

  BookingDetailPage({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Details'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Booking ID: ${booking.id}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 8),
            Text('Property ID: ${booking.propertyId}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Start Date: ${booking.startDate}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('End Date: ${booking.endDate}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Total Price: ${booking.totalPrice}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Number of People: ${booking.numPeople}', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
