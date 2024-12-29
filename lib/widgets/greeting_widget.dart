import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class GreetingWidget extends StatelessWidget {
  final String userId;

  GreetingWidget({required this.userId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: Provider.of<AuthProvider>(context, listen: false).fetchUsernameById(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Échec du chargement du nom d\'utilisateur', style: TextStyle(color: Colors.red));
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bonjour, ${snapshot.data}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(height: 32),
              Text(
                'Comment allez vous aujourd\'hui?',
                style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'Poppins'),
              ),
              SizedBox(height: 16),
            ],
          );
        }
      },
    );
  }
}
