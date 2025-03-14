import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/property.dart';
import '../models/review.dart';
import '../providers/auth_provider.dart';
import 'booking/create_booking_view.dart';

class PropertyDetailPage extends StatelessWidget {
  final Property property;
  final String userId; // Add this line

  const PropertyDetailPage({required this.property, required this.userId}); // Update constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          property.title,
          style: TextStyle(color: Colors.white, fontFamily: 'Poppins', fontWeight: FontWeight.bold), // Set title color to white and font to Poppins
        ),
        backgroundColor: Colors.transparent, // Make AppBar transparent
        elevation: 0, // Remove shadow under AppBar
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Thumbnail
              FutureBuilder<String>(
                future: Provider.of<AuthProvider>(context, listen: false)
                    .fetchPropertyPhotoUrl(property.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      width: double.infinity,
                      height: 200,
                      color: Colors.grey,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (snapshot.hasError) {
                    return Container(
                      width: double.infinity,
                      height: 200,
                      color: Colors.grey,
                      child: Center(child: Icon(Icons.error, size: 50, color: Colors.red)),
                    );
                  } else if (snapshot.hasData) {
                    final photoUrl = snapshot.data!;
                    return Image.network(
                      photoUrl,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    );
                  } else {
                    return Container(
                      width: double.infinity,
                      height: 200,
                      color: Colors.grey,
                      child: Center(child: Icon(Icons.image, size: 50, color: Colors.white)),
                    );
                  }
                },
              ),
              SizedBox(height: 16),
              // Title
              Text(
                property.title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Poppins', color: Colors.white),
              ),
              Divider(color: Colors.grey[400]), // Divider
              SizedBox(height: 8),
              // Price
              RichText(
                text: TextSpan(
                  text: 'Prix par nuit: ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Poppins', color: Colors.white),
                  children: <TextSpan>[
                    TextSpan(
                      text: '\€${property.pricePerNight}',
                      style: TextStyle(fontSize: 18, color: Color(0xFFF7B818), fontFamily: 'Poppins'),
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.grey[400]), // Divider
              SizedBox(height: 16),
              // Description
              Text(
                'Description: ${property.description}',
                style: TextStyle(fontSize: 16, fontFamily: 'Poppins', color: Colors.white),
              ),
              Divider(color: Colors.grey[400]), // Divider
              SizedBox(height: 16),
              // Number of Bedrooms and Maximum Guests
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Chambres',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Poppins', color: Colors.white),
                      ),
                      Text(
                        '${property.numBedrooms}',
                        style: TextStyle(fontSize: 16, color: Color(0xFFF7B818), fontFamily: 'Poppins'),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Invitées',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Poppins', color: Colors.white),
                      ),
                      Text(
                        '${property.maxGuests}',
                        style: TextStyle(fontSize: 16, color: Color(0xFFF7B818), fontFamily: 'Poppins'),
                      ),
                    ],
                  ),
                ],
              ),
              Divider(color: Colors.grey[400]), // Divider
              SizedBox(height: 8),
              // Amenities
              Text(
                'Agréments: ${property.amenities}',
                style: TextStyle(fontSize: 16, fontFamily: 'Poppins', color: Colors.white),
              ),
              Divider(color: Colors.grey[400]), // Divider
              SizedBox(height: 16),
              // Reviews Section
              Text(
                'Commentaires:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Poppins', color: Colors.white),
              ),
              // Fetch and display reviews
              FutureBuilder<List<Review>>(
                future: Provider.of<AuthProvider>(context, listen: false).fetchReviews(property.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Échec du chargement des avis', style: TextStyle(fontFamily: 'Poppins', color: Colors.white)));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Aucun avis trouvé', style: TextStyle(fontFamily: 'Poppins', color: Colors.white)));
                  }

                  final reviews = snapshot.data!;
                  return Column(
                    children: reviews.map((review) {
                      return ListTile(
                        title: Text(review.comment, style: TextStyle(fontFamily: 'Poppins', color: Colors.white)),
                        subtitle: Text('Guest ID: ${review.guestId}', style: TextStyle(fontFamily: 'Poppins', color: Colors.white)),
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
                builder: (context) => CreateBookingView(property: property, userId: userId), // Pass userId
              ),
            );
          },
          child: Text(
            'Réserver maintenant',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Poppins'),
          ),
        ),
      ),
    );
  }
}
