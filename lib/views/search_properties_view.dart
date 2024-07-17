import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/property.dart';
import 'property_detail_page.dart';
import '../../widgets/searchBar.dart';

class SearchPropertiesView extends StatefulWidget {
  final String userId; // Add this line

  SearchPropertiesView({required this.userId}); // Update constructor

  @override
  _SearchPropertiesViewState createState() => _SearchPropertiesViewState();
}

class _SearchPropertiesViewState extends State<SearchPropertiesView> {
  List<Property> _properties = [];
  String _message = '';

  @override
  void initState() {
    super.initState();
    _fetchRecentlyAddedProperties();
  }

  Future<void> _fetchRecentlyAddedProperties() async {
    try {
      final properties = await Provider.of<AuthProvider>(context, listen: false).fetchProperties();
      setState(() {
        _properties = properties.take(3).toList(); // Limit to 3 properties
      });
    } catch (e) {
      setState(() {
        _message = 'Échec du chargement des propriétés: ${e.toString()}';
      });
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
      appBar: AppBar(
        title: Text('Accueil'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Handle notification icon tap
            },
          ),
        ],
      ),
      body: Padding(
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
                    onPressed: _fetchRecentlyAddedProperties,
                    child: Text('Récemment ajouté'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
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
                    child: Text('Meilleurs tarifs 🔥'),
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
                    child: Text('Meilleures offres'),
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
                    child: Text('Populaire'),
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
            Text(
              'Récemment ajoutées',
              style: TextStyle(fontSize: 24, color: Colors.black),
            ),
            SizedBox(height: 16.0),
            if (_message.isNotEmpty) ...[
              Text(
                _message,
                style: TextStyle(color: Colors.red),
              ),
              SizedBox(height: 16.0),
            ],
            if (_properties.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _properties.length,
                  itemBuilder: (context, index) {
                    final property = _properties[index];
                    return Card(
                      color: Colors.grey[850],
                      margin: EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PropertyDetailPage(property: property, userId: widget.userId), // Pass userId
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FutureBuilder<String>(
                                future: Provider.of<AuthProvider>(context, listen: false)
                                    .fetchPropertyPhotoUrl(property.id),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Center(child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Icon(Icons.error, color: Colors.red);
                                  } else {
                                    return Image.network(
                                      snapshot.data!,
                                      width: double.infinity,
                                      height: 150,
                                      fit: BoxFit.cover,
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
                                              color: Colors.white),
                                        ),
                                        Text(property.address,
                                            style: TextStyle(color: Colors.white70)),
                                        Text('1.8 km',
                                            style: TextStyle(color: Colors.white70)),
                                        Text('${property.pricePerNight}€/nuit',
                                            style: TextStyle(color: Colors.white70)),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Icon(Icons.star_border, color: Colors.white),
                                      SizedBox(height: 8.0),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => PropertyDetailPage(property: property, userId: widget.userId), // Pass userId
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
                                        child: Text('Reserve maintenant', style: TextStyle(color: Colors.white)),
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
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
