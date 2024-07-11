import 'package:flutter/material.dart';

class FavoritesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 10, // Replace with actual count
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Favorite Property Title', style: TextStyle(color: Colors.white)),
            subtitle: Text('Favorite Property Subtitle', style: TextStyle(color: Colors.white)),
            onTap: () {
              // Navigate to detail view
            },
          );
        },
      ),
    );
  }
}
