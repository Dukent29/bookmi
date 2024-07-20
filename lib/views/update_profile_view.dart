import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class UpdateProfileView extends StatefulWidget {
  @override
  _UpdateProfileViewState createState() => _UpdateProfileViewState();
}

class _UpdateProfileViewState extends State<UpdateProfileView> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _profilePictureController = TextEditingController();

  String _message = '';

  Future<void> _updateProfile() async {
    try {
      await Provider.of<AuthProvider>(context, listen: false).updateProfile(
        _firstNameController.text,
        _lastNameController.text,
        _bioController.text,
        _profilePictureController.text,
      );
      setState(() {
        _message = 'Mise à jour du profil réussie';
      });
    } catch (e) {
      setState(() {
        _message = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text('Modifier profile',style: TextStyle(fontFamily: 'Poppins', color: Colors.white)),
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
          children: <Widget>[
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(
                labelText: 'Prénom',
                labelStyle: TextStyle(fontFamily: 'Poppins'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(
                labelText: 'Nom de famille',
                labelStyle: TextStyle(fontFamily: 'Poppins'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _bioController,
              decoration: InputDecoration(
                labelText: 'Biographie',
                labelStyle: TextStyle(fontFamily: 'Poppins'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _profilePictureController,
              decoration: InputDecoration(
                labelText: 'Photo de profil',
                labelStyle: TextStyle(fontFamily: 'Poppins'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _updateProfile,
              child: Text(
                'Mettre à jour le profil',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Set the text color to white
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(vertical: 20.0), // Padding top and bottom
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              _message,
              style: TextStyle(color: Colors.red, fontFamily: 'Poppins'),
            ),
          ],
        ),
      ),
    );
  }
}
