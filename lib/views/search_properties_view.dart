import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart'; // Update the import here
import '../models/property.dart';
import 'create_booking_view.dart'; // Import the booking view

class SearchPropertiesView extends StatefulWidget {
  @override
  _SearchPropertiesViewState createState() => _SearchPropertiesViewState();
}

class _SearchPropertiesViewState extends State<SearchPropertiesView> {
  final TextEditingController _addressController = TextEditingController();
  List<Property> _properties = [];
  String _message = '';

  Future<void> _searchProperties() async {
    try {
      final properties = await Provider.of<AuthProvider>(context, listen: false)
          .searchProperties(address: _addressController.text); // Ensure this method is in AuthProvider

      setState(() {
        _properties = properties;
        _message = properties.isEmpty ? 'No properties found' : '';
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
        title: Text('Search Properties'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _searchProperties,
              child: Text('Search'),
            ),
            SizedBox(height: 16.0),
            if (_message.isNotEmpty) ...[
              Text(
                _message,
                style: TextStyle(color: Colors.red),
              ),
              SizedBox(height: 16.0),
            ],
            Expanded(
              child: ListView.builder(
                itemCount: _properties.length,
                itemBuilder: (context, index) {
                  final property = _properties[index];
                  return ListTile(
                    title: Text(property.title),
                    subtitle: Text(property.address),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateBookingView(property: property),
                        ),
                      );
                    },
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
