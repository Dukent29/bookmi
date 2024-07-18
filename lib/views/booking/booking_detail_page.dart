import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '/models/booking.dart';
import '/providers/auth_provider.dart';

class BookingDetailPage extends StatelessWidget {
  final Booking booking;
  final String guestUsername;

  BookingDetailPage({required this.booking, required this.guestUsername});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Booking Details',
          style: TextStyle(color: Colors.white, fontFamily: 'Poppins', fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Thumbnail
              FutureBuilder<String>(
                future: Provider.of<AuthProvider>(context, listen: false)
                    .fetchPropertyPhotoUrl(booking.propertyId),
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
                    final photoUrl = snapshot.data ?? '';
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
              // Property Title
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  booking.propertyTitle,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Poppins', color: Colors.white),
                ),
              ),
              Divider(color: Colors.grey[400]),
              // Guest Info
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  children: [
                    Icon(Icons.person, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Guest: $guestUsername',
                      style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.grey[400]),
              // Amount Paid
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Amount Paid: \$${booking.totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 20, color: Color(0xFFF7B818), fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                ),
              ),
              Divider(color: Colors.grey[400]),
              // Dates of Stay
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Stay: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(booking.startDate))} - ${DateFormat('yyyy-MM-dd').format(DateTime.parse(booking.endDate))}',
                      style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              // Confirm and Decline Buttons
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Add functionality for confirm button
                    },
                    child: Text('Approuver', style: TextStyle(fontFamily: 'Poppins', color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow[700], // Background color
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      // Add functionality for decline button
                    },
                    child: Text('Décliner', style: TextStyle(fontFamily: 'Poppins', color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Background color
                      padding: EdgeInsets.symmetric(vertical: 18.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
