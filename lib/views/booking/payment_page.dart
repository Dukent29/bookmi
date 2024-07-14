import 'package:flutter/material.dart';
import '../../models/booking.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class PaymentPage extends StatefulWidget {
  final Booking booking;

  PaymentPage({required this.booking});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String _paymentMethod = 'Credit Card'; // Example payment method
  String _paymentStatus = 'Pending';
  String _message = '';

  Future<void> _makePayment() async {
    try {
      await Provider.of<AuthProvider>(context, listen: false).createPayment(
        bookingId: widget.booking.id,
        amount: widget.booking.totalPrice,
        paymentMethod: _paymentMethod,
        paymentStatus: _paymentStatus,
      );

      setState(() {
        _message = 'Payment successful';
      });
    } catch (e) {
      setState(() {
        _message = 'Payment failed: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment for Booking ID: ${widget.booking.id}'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Total Price: \$${widget.booking.totalPrice.toStringAsFixed(2)}'),
            SizedBox(height: 16.0),
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
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _makePayment,
              child: Text('Make Payment'),
            ),
            SizedBox(height: 16.0),
            if (_message.isNotEmpty)
              Text(
                _message,
                style: TextStyle(color: _message.contains('failed') ? Colors.red : Colors.green),
              ),
          ],
        ),
      ),
    );
  }
}
