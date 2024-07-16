import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/booking.dart';
import '../../providers/auth_provider.dart';
import './edit_mybooking_page.dart';

class MyBookingDetailPage extends StatelessWidget {
  final Booking booking;

  MyBookingDetailPage({required this.booking});

  Future<void> _cancelBooking(BuildContext context) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.cancelBooking(booking.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking canceled successfully')),
      );
      Navigator.pop(context); // Go back to the previous page
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to cancel booking: $e')),
      );
    }
  }

  void _editBooking(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditMyBookingPage(booking: booking),
      ),
    );
  }

  Widget buildSection(Widget child) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0), // Equal padding top and bottom
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          child,
          SizedBox(height: 8.0), // Add space between content and divider
          Divider(color: Colors.grey), // Gray border separator
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Details', style: TextStyle(fontFamily: 'Poppins')),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<String>(
                future: Provider.of<AuthProvider>(context, listen: false)
                    .fetchPropertyPhotoUrl(booking.propertyId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Icon(Icons.error, color: Colors.red);
                  } else {
                    return Image.network(
                      snapshot.data!,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    );
                  }
                },
              ),
              SizedBox(height: 16.0),
              buildSection(
                Text(
                  booking.propertyTitle,
                  style: TextStyle(
                    color: Color(0xFFF7B818),
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              buildSection(
                Text(
                  booking.propertyAddress,
                  style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Poppins'),
                ),
              ),
              buildSection(
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'start',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        Text(
                          DateFormat('EEEE dd MMM').format(DateTime.parse(booking.startDate)),
                          style: TextStyle(color: Color(0xFFF7B818), fontSize: 16, fontFamily: 'Poppins'),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'end',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        Text(
                          DateFormat('EEEE dd MMM').format(DateTime.parse(booking.endDate)),
                          style: TextStyle(color: Color(0xFFF7B818), fontSize: 16, fontFamily: 'Poppins'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              buildSection(
                Text(
                  'Price: \$${booking.totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              buildSection(
                Text(
                  booking.propertyDescription,
                  style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Poppins'),
                ),
              ),
              buildSection(
                Text(
                  'Amenities: ${booking.propertyAmenities}',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Poppins'),
                ),
              ),
              buildSection(
                Text(
                  'Number of Guests: ${booking.numPeople}',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Poppins'),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () => _cancelBooking(context),
                child: Text('Cancel Reservation'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  shadowColor: Colors.black.withOpacity(0.5),
                  elevation: 5,
                  minimumSize: Size(double.infinity, 50), // Full width
                ),
              ),
              SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: () => _editBooking(context),
                child: Text('Edit My Booking'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Color(0xFFF7B818),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  shadowColor: Colors.black.withOpacity(0.5),
                  elevation: 5,
                  minimumSize: Size(double.infinity, 50), // Full width
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
