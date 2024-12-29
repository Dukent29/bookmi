import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text('John Doe', style: TextStyle(color: Colors.white)),
          ),
          ListTile(
            title: Text('Gérer votre compte', style: TextStyle(color: Colors.white)),
            onTap: () {
              // Navigate to manage account page
            },
          ),
          ListTile(
            title: Text('Récompense et portefeuille', style: TextStyle(color: Colors.white)),
            onTap: () {
              // Navigate to reward & wallet page
            },
          ),
          // Add other list tiles for other options
        ],
      ),
    );
  }
}
