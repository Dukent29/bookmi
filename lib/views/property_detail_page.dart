// views/property_detail_page.dart

import 'package:flutter/material.dart';
import '../models/property.dart';
import '../models/review.dart';
import '../providers/auth_provider.dart';
import 'booking/create_booking_view.dart';
import 'package:provider/provider.dart';

class PropertyDetailPage extends StatelessWidget {
  final Property property;

  const PropertyDetailPage({required this.property});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(property.title),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Thumbnail
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/istockphoto-1365649825-612x612.jpg'), // Use the image thumbnail
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 16),
              // Title
              Text(
                property.title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Divider(color: Colors.grey[400]), // Divider
              SizedBox(height: 8),
              // Price
              Text(
                'Price per night: \$${property.pricePerNight}',
                style: TextStyle(fontSize: 20, color: Colors.orange),
              ),
              Divider(color: Colors.grey[400]), // Divider
              SizedBox(height: 16),
              // Description
              Text(
                property.description,
                style: TextStyle(fontSize: 16),
              ),
              Divider(color: Colors.grey[400]), // Divider
              SizedBox(height: 16),
              // Number of Bedrooms
              Text(
                'Number of Bedrooms: ${property.numBedrooms}',
                style: TextStyle(fontSize: 16),
              ),
              Divider(color: Colors.grey[400]), // Divider
              SizedBox(height: 8),
              // Maximum Guests
              Text(
                'Maximum Guests: ${property.maxGuests}',
                style: TextStyle(fontSize: 16),
              ),
              Divider(color: Colors.grey[400]), // Divider
              SizedBox(height: 8),
              // Amenities
              Text(
                'Amenities: ${property.amenities}',
                style: TextStyle(fontSize: 16),
              ),
              Divider(color: Colors.grey[400]), // Divider
              SizedBox(height: 16),
              // Reviews Section
              Text(
                'Reviews:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              // Fetch and display reviews
              FutureBuilder<List<Review>>(
                future: Provider.of<AuthProvider>(context, listen: false).fetchReviews(property.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Failed to load reviews'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No reviews found'));
                  }

                  final reviews = snapshot.data!;
                  return Column(
                    children: reviews.map((review) {
                      return ListTile(
                        title: Text(review.comment),
                        subtitle: Text('Guest ID: ${review.guestId}'),
                      );
                    }).toList(),
                  );
                },
              ),
              Divider(color: Colors.grey[400]), // Divider
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange, // Background color
            minimumSize: Size(double.infinity, 50), // Full-width button
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0), // Rounded corners
            ),
            elevation: 5,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateBookingView(property: property),
              ),
            );
          },
          child: Text(
            'Réserver maintenant',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
