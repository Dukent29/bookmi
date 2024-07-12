import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/property.dart';
import 'property_detail_page.dart';

class SearchPropertiesView extends StatefulWidget {
  @override
  _SearchPropertiesViewState createState() => _SearchPropertiesViewState();
}

class _SearchPropertiesViewState extends State<SearchPropertiesView> {
  final TextEditingController _addressController = TextEditingController();
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
        _properties = properties;
      });
    } catch (e) {
      setState(() {
        _message = 'Failed to load properties: ${e.toString()}';
      });
    }
  }

  Future<void> _searchProperties() async {
    try {
      final properties = await Provider.of<AuthProvider>(context, listen: false)
          .searchProperties(address: _addressController.text);

      setState(() {
        _properties = properties;
        _message = properties.isEmpty ? 'Appartement non trouvable' : '';
      });
    } catch (e) {
      setState(() {
        _message = 'Failed to load properties: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home/Rechercher ...'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Handle notification icon tap
            },
          ),
        ], // Set the background color to black
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Address',
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search, color: Colors.black),
              ),
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _searchProperties,
              child: Text('Search'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
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
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 150,
                              color: Colors.grey,
                              child: Center(
                                  child: Icon(Icons.image, size: 50, color: Colors.white)),
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
                                            builder: (context) => PropertyDetailPage(property: property),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange,
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
