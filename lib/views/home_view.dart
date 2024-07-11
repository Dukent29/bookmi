import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Bienvenue l\'utilisateur connecté actuelle', style: TextStyle(fontSize: 24, color: Colors.white)),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Search',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.search, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 3, // Replace with actual count
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Property Title', style: TextStyle(color: Colors.white)),
                  subtitle: Text('Property Subtitle', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    // Navigate to detail view
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
