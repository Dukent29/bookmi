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
        title: Text('Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Price: \$${widget.booking.totalPrice}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text('Select Payment Method', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: _paymentMethod,
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
                    SnackBar(content: Text('Payment successful!')),
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => PaymentConfirmationPage(userId: widget.userId)),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Payment failed: ${e.toString()}')),
                  );
                }
              },
              child: Text('Confirm Payment'),
            ),
          ],
        ),
      ),
    );
  }
}
