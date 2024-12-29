import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/auth_provider.dart';
import 'add_property_view.dart';
import 'my_single_property.dart';

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
        _message = 'Échec du chargement des propriétés: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Announce', style: TextStyle(fontFamily: 'Poppins', color: Colors.white)),
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
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      color: Colors.grey[800]?.withOpacity(0.5), // Semi-transparent card
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        title: Text(
                          property['title'],
                          style: TextStyle(color: Colors.white, fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Emplacement: ${property['city']}, ${property['country']}',
                          style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                        ),
                        trailing: Icon(Icons.chevron_right, color: Color(0xFFF7B818)),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MySingleProperty(propertyId: property['id']),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddPropertyView()),
                  );
                },
                icon: Icon(Icons.add, color: Colors.white),
                label: Text('Ajouter une propriété', style: TextStyle(fontFamily: 'Poppins', color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFF7B818),
                  padding: EdgeInsets.all(16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
