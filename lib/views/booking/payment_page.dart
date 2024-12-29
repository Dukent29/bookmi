import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/booking.dart';
import '../../providers/auth_provider.dart';
import 'payment_confirmation_page.dart'; // Add this import

class PaymentPage extends StatefulWidget {
  final Booking booking;
  final String userId;

  PaymentPage({required this.booking, required this.userId});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String _paymentMethod = 'Credit Card';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paiement', style: TextStyle(fontFamily: 'Poppins', color: Colors.white)),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Prix Total: \$${widget.booking.totalPrice}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Poppins', color: Colors.white),
              ),
              SizedBox(height: 16),
              Text(
                'Sélectionner le mode de paiement',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Poppins', color: Colors.white),
              ),
              DropdownButton<String>(
                value: _paymentMethod,
                dropdownColor: Colors.grey[800],
                style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                onChanged: (String? newValue) {
                  setState(() {
                    _paymentMethod = newValue!;
                  });
                },
                items: <String>['Credit Card', 'PayPal', 'Bank Transfer']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await Provider.of<AuthProvider>(context, listen: false).createPayment(
                      bookingId: widget.booking.id,
                      amount: widget.booking.totalPrice,
                      paymentMethod: _paymentMethod,
                      paymentStatus: 'Completed',
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Paiement réussi!')),
                    );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => PaymentConfirmationPage(userId: widget.userId)),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Échec du paiement: ${e.toString()}')),
                    );
                  }
                },
                child: Text('Confirmer le paiement', style: TextStyle(fontFamily: 'Poppins', color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFF7B818),
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  minimumSize: Size(double.infinity, 50), // Full width button
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
