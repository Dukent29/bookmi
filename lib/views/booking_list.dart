import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class BookingListPage extends StatefulWidget {
  final int propertyId;

  BookingListPage({required this.propertyId});

  @override
  _BookingListPageState createState() => _BookingListPageState();
}

class _BookingListPageState extends State<BookingListPage> {
  late Future<List<Map<String, dynamic>>> _bookings;

  @override
  void initState() {
    super.initState();
    // Initialize _bookings with the fetchBookings method
    _bookings = _fetchBookings();
  }

  Future<List<Map<String, dynamic>>> _fetchBookings() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return await authProvider.fetchBookings(widget.propertyId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookings List'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _bookings,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No bookings found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final booking = snapshot.data![index];
                return ListTile(
                  title: Text('Booking ID: ${booking['id']}'),
                  subtitle: Text('Guest ID: ${booking['guest_id']}'),
                  trailing: Text('Status: ${booking['status']}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
