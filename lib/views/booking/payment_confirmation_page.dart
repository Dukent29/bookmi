import 'package:flutter/material.dart';
import 'my_bookings_page.dart';

class PaymentConfirmationPage extends StatelessWidget {
  final String userId;

  PaymentConfirmationPage({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirmation de Paiement', style: TextStyle(fontFamily: 'Poppins', color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white), // Ensure back button is white
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF000000), Color(0xFF292A32)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, color: Color(0xFFF7B818), size: 100),
              SizedBox(height: 16),
              Text(
                'Paiement Réussi!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Poppins', color: Colors.white),
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MyBookingsPage(guestId: userId)),
                  );
                },
                child: Text('Voir Mes Réservations', style: TextStyle(fontFamily: 'Poppins', color: Color(0xFFF7B818))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
