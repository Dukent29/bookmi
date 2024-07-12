import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/property.dart';
import '../views/property_detail_page.dart';
import '../views/booking/create_booking_view.dart';

class PropertyCard extends StatelessWidget {
  final Property property;

  const PropertyCard({required this.property});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[850],
      margin: EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PropertyDetailPage(property: property),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 150,
                color: Colors.grey,
                child: Center(child: Icon(Icons.image, size: 50, color: Colors.white)),
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          property.title,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(property.address, style: TextStyle(color: Colors.white70)),
                        Text('1.8 km', style: TextStyle(color: Colors.white70)),
                        Text('${property.pricePerNight}€/nuit', style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Consumer<AuthProvider>(
                        builder: (context, authProvider, child) {
                          return IconButton(
                            icon: Icon(Icons.star_border, color: Colors.white),
                            onPressed: () async {
                              try {
                                await authProvider.updatePropertyStatusToFavoris(property.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Property added to favoris')),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Failed to update property status')),
                                );
                              }
                            },
                          );
                        },
                      ),
                      SizedBox(height: 8.0),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateBookingView(property: property),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                        child: Text('Réserver maintenant'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
