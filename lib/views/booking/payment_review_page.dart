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
        title: Text('Review Payment', style: TextStyle(fontFamily: 'Poppins', color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: Provider.of<AuthProvider>(context, listen: false).getPropertyById(booking.propertyId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load property details', style: TextStyle(color: Colors.white, fontFamily: 'Poppins')));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Property not found', style: TextStyle(color: Colors.white, fontFamily: 'Poppins')));
          }

          final property = Property.fromJson(snapshot.data!['property']);
          return FutureBuilder<String>(
            future: Provider.of<AuthProvider>(context, listen: false).fetchPropertyPhotoUrl(booking.propertyId),
            builder: (context, photoSnapshot) {
              if (photoSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (photoSnapshot.hasError) {
                return Center(child: Text('Failed to load property photo', style: TextStyle(color: Colors.white, fontFamily: 'Poppins')));
              } else if (!photoSnapshot.hasData) {
                return Center(child: Text('No photo available', style: TextStyle(color: Colors.white, fontFamily: 'Poppins')));
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
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Poppins', color: Colors.white),
                    ),
                    Text(
                      '${property.address}, ${property.city}, ${property.state}, ${property.country}',
                      style: TextStyle(fontSize: 16, color: Colors.grey, fontFamily: 'Poppins'),
                    ),
                    SizedBox(height: 16),
                    Text('Price per night:', style: TextStyle(fontSize: 16, fontFamily: 'Poppins', color: Colors.white)),
                    Text('\$${property.pricePerNight}', style: TextStyle(fontSize: 16, fontFamily: 'Poppins', color: Color(0xFFF7B818))),
                    Text('Total price:', style: TextStyle(fontSize: 16, fontFamily: 'Poppins', fontWeight: FontWeight.bold, color: Colors.white)),
                    Text('\$${booking.totalPrice}', style: TextStyle(fontSize: 16, fontFamily: 'Poppins', color: Color(0xFFF7B818))),
                    SizedBox(height: 16),
                    Text('Amenities:', style: TextStyle(fontSize: 16, fontFamily: 'Poppins', color: Colors.white)),
                    Text('${property.amenities}', style: TextStyle(fontSize: 16, fontFamily: 'Poppins', color: Colors.white)),
                    Divider(color: Colors.grey),
                    Text('Booking Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Poppins', color: Colors.white)),
                    Text('Check-in: ${booking.startDate}', style: TextStyle(fontSize: 16, fontFamily: 'Poppins', color: Colors.white)),
                    Text('Check-out: ${booking.endDate}', style: TextStyle(fontSize: 16, fontFamily: 'Poppins', color: Colors.white)),
                    Text('Number of guests: ${booking.numPeople}', style: TextStyle(fontSize: 16, fontFamily: 'Poppins', color: Colors.white)),
                    Spacer(),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentPage(booking: booking, userId: userId),
                          ),
                        );
                      },
                      icon: Icon(Icons.payment, color: Colors.white),
                      label: Text('Procéder au paiement', style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFF7B818),
                        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
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
