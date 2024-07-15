import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class ActualitePage extends StatefulWidget {
  final String userId;

  ActualitePage({required this.userId});

  @override
  _ActualitePageState createState() => _ActualitePageState();
}

class _ActualitePageState extends State<ActualitePage> {
  List<Map<String, dynamic>> _bookings = [];
  String _message = '';

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final bookings = await authProvider.fetchBookingsByUserProperties(widget.userId);
      setState(() {
        _bookings = bookings;
      });
    } catch (e) {
      setState(() {
        _message = 'Failed to load bookings: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Actualité'),
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
              if (_message.isNotEmpty)
                Text(
                  _message,
                  style: TextStyle(color: Colors.red),
                ),
              if (_bookings.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: _bookings.length > 2 ? 2 : _bookings.length,
                    itemBuilder: (context, index) {
                      final booking = _bookings[index];
                      return FutureBuilder<String>(
                        future: Provider.of<AuthProvider>(context, listen: false)
                            .fetchPropertyPhotoUrl(booking['property_id']),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error loading image');
                          } else {
                            return Card(
                              color: Colors.grey[800]?.withOpacity(0.5), // Semi-transparent card
                              child: ListTile(
                                leading: snapshot.hasData
                                    ? Image.network(snapshot.data!)
                                    : null,
                                title: Text(
                                  'Booking ID: ${booking['id']}',
                                  style: TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(
                                  'Guest: ${booking['guest_username']}\nFrom: ${booking['start_date']}\nTo: ${booking['end_date']}\nProperty: ${booking['property_title']}',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      // Navigate to Contact Customer Service
                    },
                    child: Column(
                      children: [
                        Icon(Icons.contact_support, color: Colors.white),
                        Text('Contact customer Service', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  VerticalDivider(color: Colors.white),
                  InkWell(
                    onTap: () {
                      // Navigate to Safety Resource Centre
                    },
                    child: Column(
                      children: [
                        Icon(Icons.security, color: Colors.white),
                        Text('Safety resource centre', style: TextStyle(color: Colors.white)),
                      ],
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
