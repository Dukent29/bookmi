import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/auth_provider.dart';
import 'add_property_view.dart';

class AnnounceView extends StatefulWidget {
  @override
  _AnnounceViewState createState() => _AnnounceViewState();
}

class _AnnounceViewState extends State<AnnounceView> {
  List<Map<String, dynamic>> _properties = [];
  String _message = '';

  @override
  void initState() {
    super.initState();
    _fetchProperties();
  }

  Future<void> _fetchProperties() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId') ?? '';

      final properties = await authProvider.fetchMyProperties(userId);
      setState(() {
        _properties = properties;
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
        title: Text('Announce'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF000000), Color(0xFF292A32)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            if (_message.isNotEmpty)
              Center(
                child: Text(
                  _message,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            if (_properties.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _properties.length,
                  itemBuilder: (context, index) {
                    final property = _properties[index];
                    return Card(
                      color: Colors.grey[800]?.withOpacity(0.5), // Semi-transparent card
                      child: ListTile(
                        title: Text(
                          property['title'],
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          'Location: ${property['city']}, ${property['country']}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddPropertyView()),
                  );
                },
                child: Text('Add Property'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
