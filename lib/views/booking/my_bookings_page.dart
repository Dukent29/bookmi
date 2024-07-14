import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/booking.dart';
import '../../providers/auth_provider.dart';
import 'booking_details_page.dart';

class MyBookingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.userId;

    if (userId == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('My Bookings'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
          child: Text('User ID is null. Please log in again.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('My Bookings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder<List<Booking>>(
        future: authProvider.getBookingsByUser(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load bookings: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No bookings found'));
          }

          final bookings = snapshot.data!;
          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              return ListTile(
                title: Text('Booking ID: ${booking.id}'),
                subtitle: Text('Property ID: ${booking.propertyId}\nFrom: ${booking.startDate}\nTo: ${booking.endDate}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingDetailPage(booking: booking),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
