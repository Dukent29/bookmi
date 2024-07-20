import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/property.dart';
import '/widgets/searchBar.dart';
import 'property_detail_page.dart';
import 'booking/create_booking_view.dart';

class DecouvrirPage extends StatefulWidget {
  final String userId;

  DecouvrirPage({required this.userId});

  @override
  _DecouvrirPageState createState() => _DecouvrirPageState();
}

class _DecouvrirPageState extends State<DecouvrirPage> {
  List<Property> _properties = [];
  List<Property> _recentlyAddedProperties = [];

  @override
  void initState() {
    super.initState();
    _fetchAllProperties();
    _fetchRecentlyAddedProperties();
  }

  Future<void> _fetchAllProperties() async {
    try {
      final properties = await Provider.of<AuthProvider>(context, listen: false).fetchProperties();
      setState(() {
        _properties = properties;
      });
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _fetchRecentlyAddedProperties() async {
    try {
      final properties = await Provider.of<AuthProvider>(context, listen: false).fetchProperties();
      setState(() {
        _recentlyAddedProperties = properties.take(3).toList();
      });
    } catch (e) {
      // Handle error
    }
  }

  void _onSearchCompleted(List<Property> properties) {
    setState(() {
      _properties = properties;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          'Decouvrir',
          style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              // Handle notification icon tap
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF292A32), Color(0xFF000000)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomSearchBar(onSearchCompleted: _onSearchCompleted),
              SizedBox(height: 16.0),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _properties = _recentlyAddedProperties;
                        });
                      },
                      child: Text('Récemment ajouté', style: TextStyle(fontFamily: 'Poppins')),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFF7B818),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                    ),
                    SizedBox(width: 8.0),
                    ElevatedButton(
                      onPressed: () {
                        // Handle Top Rates button tap
                      },
                      child: Text('Meilleurs tarifs 🔥', style: TextStyle(fontFamily: 'Poppins')),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[850],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                    ),
                    SizedBox(width: 8.0),
                    ElevatedButton(
                      onPressed: () {
                        // Handle Best Offers button tap
                      },
                      child: Text('Meilleures offres', style: TextStyle(fontFamily: 'Poppins')),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[850],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                    ),
                    SizedBox(width: 8.0),
                    ElevatedButton(
                      onPressed: () {
                        // Handle Popular button tap
                      },
                      child: Text('Populaire', style: TextStyle(fontFamily: 'Poppins')),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[850],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              Expanded(
                child: _properties.isEmpty
                    ? Center(child: Text('Aucune propriété trouvée', style: TextStyle(fontFamily: 'Poppins', color: Colors.white)))
                    : ListView.builder(
                  itemCount: _properties.length,
                  itemBuilder: (context, index) {
                    final property = _properties[index];
                    return PropertyCard(property: property, userId: widget.userId);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PropertyCard extends StatelessWidget {
  final Property property;
  final String userId;

  const PropertyCard({required this.property, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0x57707070),
      margin: EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PropertyDetailPage(property: property, userId: userId),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<String>(
                future: Provider.of<AuthProvider>(context, listen: false).fetchPropertyPhotoUrl(property.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      height: 150,
                      color: Colors.grey,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (snapshot.hasError) {
                    return Container(
                      height: 150,
                      color: Colors.grey,
                      child: Center(child: Icon(Icons.error, size: 50, color: Colors.red)),
                    );
                  } else if (snapshot.hasData) {
                    final photoUrl = snapshot.data!;
                    return Image.network(
                      photoUrl,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    );
                  } else {
                    return Container(
                      height: 150,
                      color: Colors.grey,
                      child: Center(child: Icon(Icons.image, size: 50, color: Colors.white)),
                    );
                  }
                },
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
                              fontFamily: 'Poppins'),
                        ),
                        Text(property.address,
                            style: TextStyle(color: Colors.white70, fontFamily: 'Poppins')),
                        Text('1.8 km²',
                            style: TextStyle(color: Colors.white70, fontFamily: 'Poppins')),
                        Text('${property.pricePerNight}€/nuit',
                            style: TextStyle(color: Colors.white70, fontFamily: 'Poppins')),
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
                                  SnackBar(content: Text('Propriété ajoutée aux favoris')),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Échec de la mise à jour du statut de la propriété')),
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
                              builder: (context) => CreateBookingView(property: property, userId: userId),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFF7B818),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                        child: Text('Réserver maintenant', style: TextStyle(fontFamily: 'Poppins')),
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
