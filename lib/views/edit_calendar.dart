import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'block_property.dart';

class EditCalendarPage extends StatefulWidget {
  @override
  _EditCalendarPageState createState() => _EditCalendarPageState();
}

class _EditCalendarPageState extends State<EditCalendarPage> {
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
        title: Text('Edit Calendar'),
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
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlockProperty(propertyId: property['id']),
                            ),
                          );
                        },
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
