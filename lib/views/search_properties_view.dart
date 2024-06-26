import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/property.dart';

class SearchPropertiesView extends StatefulWidget {
  @override
  _SearchPropertiesViewState createState() => _SearchPropertiesViewState();
}

class _SearchPropertiesViewState extends State<SearchPropertiesView> {
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  List<Property> _properties = [];
  String _message = '';

  Future<void> _search() async {
    try {
      final city = _cityController.text;
      final country = _countryController.text;

      final properties = await Provider.of<AuthProvider>(context, listen: false)
          .searchProperties(city: city, country: country);

      setState(() {
        _properties = properties;
        _message = '';
      });
    } catch (e) {
      setState(() {
        _message = 'Failed to load properties: $e';
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _cityController,
              decoration: InputDecoration(labelText: 'City'),
            ),
            TextField(
              controller: _countryController,
              decoration: InputDecoration(labelText: 'Country'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _search,
              child: Text('Search'),
            ),
            SizedBox(height: 16),
            _message.isNotEmpty
                ? Text(
              _message,
              style: TextStyle(color: Colors.red),
            )
                : Expanded(
              child: ListView.builder(
                itemCount: _properties.length,
                itemBuilder: (context, index) {
                  final property = _properties[index];
                  return ListTile(
                    title: Text(property.title),
                    subtitle: Text(property.description),
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
