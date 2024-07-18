import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/property.dart';
import 'edit_property_page.dart';
import 'announce_view.dart';

class MySingleProperty extends StatefulWidget {
  final int propertyId;

  MySingleProperty({required this.propertyId});

  @override
  _MySinglePropertyState createState() => _MySinglePropertyState();
}

class _MySinglePropertyState extends State<MySingleProperty> {
  late Future<Map<String, dynamic>> _propertyDetailFuture;

  @override
  void initState() {
    super.initState();
    _propertyDetailFuture = _fetchPropertyDetails();
  }

  Future<Map<String, dynamic>> _fetchPropertyDetails() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final propertyDetails = await authProvider.fetchPropertyDetails(widget.propertyId);
      return propertyDetails;
    } catch (e) {
      throw Exception('Échec de la récupération des détails de la propriété: $e');
    }
  }

  Future<String> _fetchPropertyPhotoUrl() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return await authProvider.fetchPropertyPhotoUrl(widget.propertyId);
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Supprimer', style: TextStyle(fontFamily: 'Poppins')),
        content: Text('Êtes-vous sûr de vouloir supprimer cet article?', style: TextStyle(fontFamily: 'Poppins')),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteProperty();
            },
            child: Text('OK', style: TextStyle(fontFamily: 'Poppins', color: Color(0xFFF7B818))),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Annuler', style: TextStyle(fontFamily: 'Poppins', color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteProperty() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.deleteProperty(widget.propertyId);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => AnnounceView()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Échec de la suppression de la propriété: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de la propriété', style: TextStyle(fontFamily: 'Poppins')),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: _showDeleteConfirmationDialog,
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _propertyDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Échec du chargement des détails de la propriété: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Aucun détail de propriété trouvé'));
          } else {
            final property = Property.fromJson(snapshot.data!);
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FutureBuilder<String>(
                      future: _fetchPropertyPhotoUrl(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Container(
                            width: double.infinity,
                            height: 200,
                            color: Colors.grey,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        } else if (snapshot.hasError) {
                          return Container(
                            width: double.infinity,
                            height: 200,
                            color: Colors.grey,
                            child: Center(child: Icon(Icons.error, size: 50, color: Colors.red)),
                          );
                        } else if (snapshot.hasData) {
                          final photoUrl = snapshot.data!;
                          return Image.network(
                            photoUrl,
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          );
                        } else {
                          return Container(
                            width: double.infinity,
                            height: 200,
                            color: Colors.grey,
                            child: Center(child: Icon(Icons.image, size: 50, color: Colors.white)),
                          );
                        }
                      },
                    ),
                    SizedBox(height: 16),
                    Text(
                      property.title,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Poppins', color: Colors.white),
                    ),
                    Divider(color: Colors.grey[400]),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Description:',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Poppins', color: Colors.white),
                          ),
                          SizedBox(height: 8),
                          Text(
                            property.description,
                            style: TextStyle(fontSize: 16, fontFamily: 'Poppins', color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Divider(color: Colors.grey[400]),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Adresse:',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Poppins', color: Colors.white),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '${property.address}, ${property.city}, ${property.country}',
                            style: TextStyle(fontSize: 16, fontFamily: 'Poppins', color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Divider(color: Colors.grey[400]),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Prix par nuit:',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Poppins', color: Color(0xFFF7B818)),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '€${property.pricePerNight}',
                            style: TextStyle(fontSize: 16, fontFamily: 'Poppins', color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Divider(color: Colors.grey[400]),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nombre maximum d\'invités:',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Poppins', color: Colors.white),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '${property.maxGuests}',
                            style: TextStyle(fontSize: 16, fontFamily: 'Poppins', color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Divider(color: Colors.grey[400]),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Chambres:',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Poppins', color: Colors.white),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '${property.numBedrooms}',
                            style: TextStyle(fontSize: 16, fontFamily: 'Poppins', color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Divider(color: Colors.grey[400]),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Salles de bains:',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Poppins', color: Colors.white),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '${property.numBathrooms}',
                            style: TextStyle(fontSize: 16, fontFamily: 'Poppins', color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Divider(color: Colors.grey[400]),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Agréments:',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Poppins', color: Colors.white),
                          ),
                          SizedBox(height: 8),
                          Text(
                            property.amenities,
                            style: TextStyle(fontSize: 16, fontFamily: 'Poppins', color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditPropertyPage(property: property),
                          ),
                        );
                      },
                      icon: Icon(Icons.edit, color: Colors.white),
                      label: Text('Modifier mon annonce', style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFF7B818),
                        padding: EdgeInsets.all(16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
