import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'update_profile_view.dart';
import 'announce_view.dart';
import 'booking/booking_list.dart';

class AdminLandingView extends StatefulWidget {
  @override
  _AdminLandingViewState createState() => _AdminLandingViewState();
}

class _AdminLandingViewState extends State<AdminLandingView> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Retrieve and store the property ID for the admin
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final propertyId = 42; // Replace this with actual logic to get the property ID

    final List<Widget> _widgetOptions = <Widget>[
      Text('Aujourd\'hui Page'),
      BookingListPage(propertyId: propertyId), // Pass the propertyId here
      AnnounceView(),
      Text('Messages Page'),
      UpdateProfileView(),
    ];

    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.today),
            label: 'Aujourd\'hui',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendrier',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.announcement),
            label: 'Annonces',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
