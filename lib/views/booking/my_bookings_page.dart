import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/booking.dart';
import '../../providers/auth_provider.dart';
import 'my_booking_detail_page.dart';

class MyBookingsPage extends StatefulWidget {
  final String guestId;

  MyBookingsPage({required this.guestId});

  @override
  _MyBookingsPageState createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends State<MyBookingsPage> {
  String _selectedFilter = 'Bookings'; // Variable to track the selected filter

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mes reservations', style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedFilter = 'Bookings';
                      });
                    },
                    child: Text('Reservations'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedFilter == 'Bookings' ? Colors.orange : Colors.grey[850],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedFilter = 'Past';
                      });
                    },
                    child: Text('passé'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedFilter == 'Past' ? Colors.orange : Colors.grey[850],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedFilter = 'Canceled';
                      });
                    },
                    child: Text('Annulé'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedFilter == 'Canceled' ? Colors.orange : Colors.grey[850],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Booking>>(
              future: Provider.of<AuthProvider>(context, listen: false).getBookingsByUser(widget.guestId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Échec du chargement des réservations', style: TextStyle(color: Colors.white)));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Aucune réservation trouvée', style: TextStyle(color: Colors.white)));
                }

                final bookings = snapshot.data!;
                final filteredBookings = bookings.where((booking) {
                  if (_selectedFilter == 'Bookings') {
                    return booking.status == 'active';
                  } else if (_selectedFilter == 'Past') {
                    return DateTime.parse(booking.endDate).isBefore(DateTime.now());
                  } else if (_selectedFilter == 'Canceled') {
                    return booking.status == 'cancelled';
                  }
                  return false;
                }).toList();

                return ListView.builder(
                  itemCount: filteredBookings.length,
                  itemBuilder: (context, index) {
                    final booking = filteredBookings[index];
                    return Card(
                      color: Colors.grey[850],
                      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: ListTile(
                        leading: FutureBuilder<String>(
                          future: Provider.of<AuthProvider>(context, listen: false)
                              .fetchPropertyPhotoUrl(booking.propertyId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Icon(Icons.error, color: Colors.red);
                            } else {
                              return Image.network(snapshot.data!, width: 90, height: 130, fit: BoxFit.cover);
                            }
                          },
                        ),
                        title: Text(
                          booking.propertyTitle,
                          style: TextStyle(
                            color: Color(0xFFF7B818),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              booking.propertyAddress,
                              style: TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'Poppins'),
                            ),
                            SizedBox(height: 4.0),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontFamily: 'Poppins',
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Rester: ',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text:
                                    '${DateFormat('yyyy-MM-dd').format(DateTime.parse(booking.startDate))} - ${DateFormat('yyyy-MM-dd').format(DateTime.parse(booking.endDate))}',
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              'Prix: \€${booking.totalPrice.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                        trailing: Icon(
                          Icons.chevron_right,
                          color: Color(0xFFF7B818),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyBookingDetailPage(booking: booking),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
