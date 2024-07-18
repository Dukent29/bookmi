import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert'; // Add this import
import '../../models/property.dart';
import '../../models/booking.dart'; // Add this import
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_date_picker.dart';
import '../search_properties_view.dart';
import 'payment_review_page.dart'; // Add this import

class CreateBookingView extends StatefulWidget {
  final Property property;
  final String userId; // Add userId

  CreateBookingView({required this.property, required this.userId}); // Update constructor

  @override
  _CreateBookingViewState createState() => _CreateBookingViewState();
}

class _CreateBookingViewState extends State<CreateBookingView> {
  DateTime? _startDate;
  DateTime? _endDate;
  int _numPeople = 1;
  String _message = '';

  Future<void> _createBooking() async {
    if (_startDate == null || _endDate == null || !_startDate!.isBefore(_endDate!)) {
      setState(() {
        _message = 'Veuillez sélectionner une date de début et de fin';
      });
      return;
    }

    try {
      final response = await Provider.of<AuthProvider>(context, listen: false).createBooking(
        propertyId: widget.property.id,
        startDate: DateFormat('yyyy-MM-dd').format(_startDate!),
        endDate: DateFormat('yyyy-MM-dd').format(_endDate!),
        numPeople: _numPeople,
      );

      final bookingData = jsonDecode(response);
      final bookingId = bookingData['bookingId'];

      final booking = Booking(
        id: bookingId,
        propertyId: widget.property.id,
        guestId: int.parse(widget.userId),
        startDate: _startDate.toString(),
        endDate: _endDate.toString(),
        totalPrice: widget.property.pricePerNight * (_endDate!.difference(_startDate!).inDays + 1),
        numPeople: _numPeople,
        status: 'active', // You might want to set the status dynamically
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        propertyTitle: widget.property.title,
        propertyDescription: widget.property.description,
        propertyAddress: widget.property.address,
        propertyCity: widget.property.city,
        propertyState: widget.property.state,
        propertyCountry: widget.property.country,
        propertyZipCode: widget.property.zipCode,
        propertyPricePerNight: widget.property.pricePerNight,
        propertyMaxGuests: widget.property.maxGuests,
        propertyNumBedrooms: widget.property.numBedrooms,
        propertyNumBathrooms: widget.property.numBathrooms,
        propertyAmenities: widget.property.amenities,
      );

      setState(() {
        _message = 'Réservation créée avec succès';
      });

      // Navigate to PaymentReviewPage
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentReviewPage(booking: booking, userId: widget.userId), // Pass userId
        ),
      );
    } catch (e) {
      setState(() {
        _message = 'Échec de la réservation: ${e.toString()}';
      });
    }
  }

  void _onDateSelected(DateTime startDate, DateTime endDate) {
    setState(() {
      _startDate = startDate;
      _endDate = endDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Créer une réservation pour ${widget.property.title}', style: TextStyle(fontFamily: 'Poppins')),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white, // Set background color for the date picker
                borderRadius: BorderRadius.circular(8.0), // Rounded corners
              ),
              child: CustomDatePicker(onDateSelected: _onDateSelected),
            ),
            SizedBox(height: 16.0),
            if (_startDate != null && _endDate != null)
              Text(
                'Dates sélectionnées: ${DateFormat('yyyy-MM-dd').format(_startDate!)} - ${DateFormat('yyyy-MM-dd').format(_endDate!)}',
                style: TextStyle(color: Color(0xFFF7B818), fontFamily: 'Poppins'),
              ),
            SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'Nombre d\'invités',
                labelStyle: TextStyle(color: Color(0xFFF7B818), fontFamily: 'Poppins'), // Set label color and font
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0), // Rounded corners
                  borderSide: BorderSide(
                    color: Color(0xFFF7B818), // Set border color
                  ),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _numPeople = int.parse(value);
                });
              },
              style: TextStyle(fontFamily: 'Poppins'), // Set font
            ),
            SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _createBooking,
                child: Text('Valider la réservation', style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFF7B818), // Set background color
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchPropertiesView(userId: widget.userId), // Pass userId
                  ),
                );
              },
              child: Text('Annuler', style: TextStyle(color: Colors.red, fontFamily: 'Poppins')),
            ),
            SizedBox(height: 16.0),
            if (_message.isNotEmpty)
              Text(
                _message,
                style: TextStyle(color: Colors.red, fontFamily: 'Poppins'),
              ),
          ],
        ),
      ),
    );
  }
}
