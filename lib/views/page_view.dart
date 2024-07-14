import 'package:flutter/material.dart';
import '../models/property.dart';
import 'booking/create_booking_view.dart';

class PropertyDetailPage extends StatefulWidget {
  final Property property;
  final String userId; // Add userId

  const PropertyDetailPage({required this.property, required this.userId}); // Update constructor

  @override
  _PropertyDetailPageState createState() => _PropertyDetailPageState();
}

class _PropertyDetailPageState extends State<PropertyDetailPage> {
  bool _showBookingForm = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.property.title),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        color: Color(0xFF292A32), // Solid dark grey background color
        padding: const EdgeInsets.all(16.0),
        child: _showBookingForm ? _buildBookingForm() : _buildPropertyDetails(),
      ),
    );
  }

  Widget _buildPropertyDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.property.title,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        Text(widget.property.address, style: TextStyle(color: Colors.white)),
        Text('Price per night: \$${widget.property.pricePerNight}', style: TextStyle(color: Colors.white)),
        SizedBox(height: 16),
        Text(widget.property.description, style: TextStyle(color: Colors.white)),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _showBookingForm = true;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange, // Change button color if needed
          ),
          child: Text('Book Now', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildBookingForm() {
    return CreateBookingView(property: widget.property, userId: widget.userId); // Pass userId to CreateBookingView
  }
}
