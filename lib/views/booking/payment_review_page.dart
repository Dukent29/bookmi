import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/booking.dart';
import '../../models/property.dart';
import '../../providers/auth_provider.dart';
import 'payment_page.dart'; // Import PaymentPage

class PaymentReviewPage extends StatelessWidget {
  final Booking booking;
  final String userId;

  PaymentReviewPage({required this.booking, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Review'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: Provider.of<AuthProvider>(context, listen: false).getPropertyById(booking.propertyId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load property details'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Property not found'));
          }

          final property = Property.fromJson(snapshot.data!['property']);
          return FutureBuilder<String>(
            future: Provider.of<AuthProvider>(context, listen: false).fetchPropertyPhotoUrl(booking.propertyId),
            builder: (context, photoSnapshot) {
              if (photoSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (photoSnapshot.hasError) {
                return Center(child: Text('Failed to load property photo'));
              } else if (!photoSnapshot.hasData) {
                return Center(child: Text('No photo available'));
              }

              final photoUrl = photoSnapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(photoUrl, height: 200, fit: BoxFit.cover),
                    SizedBox(height: 16),
                    Text(
                      property.title,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${property.address}, ${property.city}, ${property.state}, ${property.country}',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    SizedBox(height: 16),
                    Text('Price per night: \$${property.pricePerNight}', style: TextStyle(fontSize: 16)),
                    Text('Total price: \$${booking.totalPrice}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 16),
                    Text('Amenities: ${property.amenities}', style: TextStyle(fontSize: 16)),
                    Divider(),
                    Text('Booking Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text('Check-in: ${booking.startDate}', style: TextStyle(fontSize: 16)),
                    Text('Check-out: ${booking.endDate}', style: TextStyle(fontSize: 16)),
                    Text('Number of guests: ${booking.numPeople}', style: TextStyle(fontSize: 16)),
                    Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentPage(booking: booking, userId: userId),
                          ),
                        );
                      },
                      child: Text('Proceed to Payment'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
