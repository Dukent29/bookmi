import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/booking.dart';
import '../../models/property.dart';
import '../../providers/auth_provider.dart';
import 'payment_page.dart'; // Import PaymentPage

class PaymentReviewPage extends StatelessWidget {
  final Booking booking;
  final String userId;

  PaymentReviewPage({required this.booking, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vérifier le paiement', style: TextStyle(fontFamily: 'Poppins', color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: Provider.of<AuthProvider>(context, listen: false).getPropertyById(booking.propertyId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Échec du chargement des détails de la propriété', style: TextStyle(color: Colors.white, fontFamily: 'Poppins')));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Propriété introuvable', style: TextStyle(color: Colors.white, fontFamily: 'Poppins')));
          }

          final property = Property.fromJson(snapshot.data!['property']);
          return FutureBuilder<String>(
            future: Provider.of<AuthProvider>(context, listen: false).fetchPropertyPhotoUrl(booking.propertyId),
            builder: (context, photoSnapshot) {
              if (photoSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (photoSnapshot.hasError) {
                return Center(child: Text('Échec du chargement de la photo de la propriété', style: TextStyle(color: Colors.white, fontFamily: 'Poppins')));
              } else if (!photoSnapshot.hasData) {
                return Center(child: Text('Aucune photo disponible', style: TextStyle(color: Colors.white, fontFamily: 'Poppins')));
              }

              final photoUrl = photoSnapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(photoUrl, height: 200, fit: BoxFit.cover),
                    SizedBox(height: 16),
                    Text(
                      property.title,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Poppins', color: Colors.white),
                    ),
                    Text(
                      '${property.address}, ${property.city}, ${property.state}, ${property.country}',
                      style: TextStyle(fontSize: 16, color: Colors.grey, fontFamily: 'Poppins'),
                    ),
                    SizedBox(height: 16),
                    Text('Prix par nuit:', style: TextStyle(fontSize: 16, fontFamily: 'Poppins', color: Colors.white)),
                    Text('\€${property.pricePerNight}', style: TextStyle(fontSize: 16, fontFamily: 'Poppins', color: Color(0xFFF7B818))),
                    Text('Prix total:', style: TextStyle(fontSize: 16, fontFamily: 'Poppins', fontWeight: FontWeight.bold, color: Colors.white)),
                    Text('\€${booking.totalPrice}', style: TextStyle(fontSize: 16, fontFamily: 'Poppins', color: Color(0xFFF7B818))),
                    SizedBox(height: 16),
                    Text('Agréments:', style: TextStyle(fontSize: 16, fontFamily: 'Poppins', color: Colors.white)),
                    Text('${property.amenities}', style: TextStyle(fontSize: 16, fontFamily: 'Poppins', color: Colors.white)),
                    Divider(color: Colors.grey),
                    Text('Les détails de réservation', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Poppins', color: Colors.white)),
                    Text('Enregistrement: ${booking.startDate}', style: TextStyle(fontSize: 16, fontFamily: 'Poppins', color: Colors.white)),
                    Text('Vérifier: ${booking.endDate}', style: TextStyle(fontSize: 16, fontFamily: 'Poppins', color: Colors.white)),
                    Text('Nombre d\'invités: ${booking.numPeople}', style: TextStyle(fontSize: 16, fontFamily: 'Poppins', color: Colors.white)),
                    Spacer(),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentPage(booking: booking, userId: userId),
                          ),
                        );
                      },
                      icon: Icon(Icons.payment, color: Colors.white),
                      label: Text('Procéder au paiement', style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFF7B818),
                        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
