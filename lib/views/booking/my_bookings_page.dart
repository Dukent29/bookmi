import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/booking.dart';
import '../../providers/auth_provider.dart';
import 'booking_details_page.dart';

class MyBookingsPage extends StatefulWidget {
  final String guestId;

  MyBookingsPage({required this.guestId, required String userId});

  @override
  _MyBookingsPageState createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends State<MyBookingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Bookings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder<List<Booking>>(
        future: Provider.of<AuthProvider>(context, listen: false).getBookingsByUser(widget.guestId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load bookings'));
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
