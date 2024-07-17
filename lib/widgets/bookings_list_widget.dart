import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/booking.dart';
import '/views/booking/booking_detail_page.dart';

class BookingsListWidget extends StatelessWidget {
  final String userId;

  BookingsListWidget({required this.userId});

  Future<List<Map<String, dynamic>>> _fetchBookings(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final bookings = await authProvider.fetchBookingsByUserProperties(userId);
    bookings.sort((a, b) => b['start_date'].compareTo(a['start_date']));
    return bookings.take(4).toList(); // Limit to 4 most recent bookings
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchBookings(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Failed to load bookings: ${snapshot.error}', style: TextStyle(color: Colors.red, fontFamily: 'Poppins'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No bookings found', style: TextStyle(color: Colors.white, fontFamily: 'Poppins'));
        } else {
          final bookings = snapshot.data!;
          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingDetailPage(
                        booking: Booking.fromJson(booking),
                        guestUsername: booking['guest_username'], // Pass guest_username here
                      ),
                    ),
                  );
                },
                child: Card(
                  margin: EdgeInsets.all(10),
                  color: Colors.grey[800]?.withOpacity(0.5), // Semi-transparent card
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        FutureBuilder<String>(
                          future: Provider.of<AuthProvider>(context, listen: false)
                              .fetchPropertyPhotoUrl(booking['property_id']),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Icon(Icons.error, color: Colors.red);
                            } else {
                              return snapshot.hasData
                                  ? Image.network(snapshot.data!, width: 100, height: 100, fit: BoxFit.cover)
                                  : Icon(Icons.image, color: Colors.white);
                            }
                          },
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                booking['property_title'],
                                style: TextStyle(color: Colors.white, fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Invitée: ${booking['guest_username']}',
                                style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: Color(0xFFF7B818),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
