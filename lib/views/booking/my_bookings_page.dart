import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/booking.dart';
import '../../providers/auth_provider.dart';
import 'booking_details_page.dart';

class MyBookingsPage extends StatefulWidget {
  final String guestId;

  MyBookingsPage({required this.guestId});

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
            print('Error: ${snapshot.error}'); // Debugging line
            return Center(child: Text('Failed to load bookings'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            print('No bookings found'); // Debugging line
            return Center(child: Text('No bookings found'));
          }

          final bookings = snapshot.data!;
          print('Bookings received: $bookings'); // Debugging line
          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              return Card(
                color: Colors.grey[800]?.withOpacity(0.5), // Semi-transparent card
                child: ListTile(
                  title: Text(
                    'Booking ID: ${booking.id}',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    'Property: ${booking.propertyTitle}\n'
                        'Address: ${booking.propertyAddress}, ${booking.propertyCity}, ${booking.propertyCountry}\n'
                        'From: ${booking.startDate}\n'
                        'To: ${booking.endDate}\n'
                        'Total Price: \$${booking.totalPrice}\n'
                        'Number of People: ${booking.numPeople}\n'
                        'Amenities: ${booking.propertyAmenities}',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingDetailPage(booking: booking),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
