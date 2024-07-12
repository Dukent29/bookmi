import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/property.dart';
import 'property_detail_page.dart';
import 'booking/create_booking_view.dart';

class DecouvrirPage extends StatefulWidget {
  @override
  _DecouvrirPageState createState() => _DecouvrirPageState();
}

class _DecouvrirPageState extends State<DecouvrirPage> {
  late Future<List<Property>> _propertiesFuture;

  @override
  void initState() {
    super.initState();
    _propertiesFuture = Provider.of<AuthProvider>(context, listen: false).fetchProperties();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Decouvrir'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Handle notification icon tap
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Property>>(
        future: _propertiesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load properties'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No properties found'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final property = snapshot.data![index];
              return PropertyCard(property: property);
            },
          );
        },
      ),
    );
  }
}

class PropertyCard extends StatefulWidget {
  final Property property;

  const PropertyCard({required this.property});

  @override
  _PropertyCardState createState() => _PropertyCardState();
}

class _PropertyCardState extends State<PropertyCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PropertyDetailPage(property: widget.property),
          ),
        );
      },
      child: Card(
        color: Colors.grey[850],
        margin: EdgeInsets.all(8.0),
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
                          widget.property.title,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Text(widget.property.address, style: TextStyle(color: Colors.white70)),
                        Text('1.8 km', style: TextStyle(color: Colors.white70)),
                        Text('${widget.property.pricePerNight}€/nuit', style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Icon(Icons.star_border, color: Colors.white),
                      SizedBox(height: 8.0),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        onEnter: (_) => setState(() => _hovering = true),
                        onExit: (_) => setState(() => _hovering = false),
                        child: AnimatedScale(
                          scale: _hovering ? 1.05 : 1.0,
                          duration: Duration(milliseconds: 200),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CreateBookingView(property: widget.property),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFF7B818), // Background color
                              textStyle: TextStyle(color: Colors.white), // Text color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              elevation: 0,
                              shadowColor: Colors.transparent,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromRGBO(99, 99, 99, 0.2),
                                    offset: Offset(0, 2),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              child: Text(
                                'Réserver maintenant',
                                style: TextStyle(color: Colors.white), // Ensures the text color is white
                              ),
                            ),
                          ),
                        ),
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
