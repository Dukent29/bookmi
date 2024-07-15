import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/property.dart';
import 'edit_property_page.dart';

class MySingleProperty extends StatefulWidget {
  final int propertyId;

  MySingleProperty({required this.propertyId});

  @override
  _MySinglePropertyState createState() => _MySinglePropertyState();
}

class _MySinglePropertyState extends State<MySingleProperty> {
  late Future<Map<String, dynamic>> _propertyDetailFuture;

  @override
  void initState() {
    super.initState();
    _propertyDetailFuture = _fetchPropertyDetails();
  }

  Future<Map<String, dynamic>> _fetchPropertyDetails() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final propertyDetails = await authProvider.fetchPropertyDetails(widget.propertyId);
      return propertyDetails;
    } catch (e) {
      throw Exception('Failed to fetch property details: $e');
    }
  }

  Future<String> _fetchPropertyPhotoUrl() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return await authProvider.fetchPropertyPhotoUrl(widget.propertyId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Property Details'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _propertyDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load property details: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No property details found'));
          } else {
            final property = Property.fromJson(snapshot.data!);
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FutureBuilder<String>(
                    future: _fetchPropertyPhotoUrl(),
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
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          property.title,
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(property.description),
                        SizedBox(height: 10),
                        Text('Address: ${property.address}, ${property.city}, ${property.country}'),
                        SizedBox(height: 10),
                        Text('Price per night: \$${property.pricePerNight}'),
                        SizedBox(height: 10),
                        Text('Max guests: ${property.maxGuests}'),
                        SizedBox(height: 10),
                        Text('Bedrooms: ${property.numBedrooms}'),
                        SizedBox(height: 10),
                        Text('Bathrooms: ${property.numBathrooms}'),
                        SizedBox(height: 10),
                        Text('Amenities: ${property.amenities}'),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditPropertyPage(property: property),
                              ),
                            );
                          },
                          child: Text('Modifier mon annonce'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
