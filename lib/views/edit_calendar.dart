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
        _message = 'Échec du chargement des propriétés: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier le calendrier', style: TextStyle(fontFamily: 'Poppins', color: Colors.white)),
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
                  style: TextStyle(color: Colors.red, fontFamily: 'Poppins'),
                ),
              ),
            if (_properties.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _properties.length,
                  itemBuilder: (context, index) {
                    final property = _properties[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      padding: const EdgeInsets.all(12.8),
                      decoration: BoxDecoration(
                        color: Colors.grey[800]?.withOpacity(0.5), // Semi-transparent background
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(8.0),
                        title: Text(
                          property['title'],
                          style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                        ),
                        subtitle: Text(
                          'Location: ${property['city']}, ${property['country']}',
                          style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                        ),
                        trailing: Icon(Icons.chevron_right, color: Color(0xFFF7B818)),
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
