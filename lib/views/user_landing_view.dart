import 'package:flutter/material.dart';
import 'decouvrir_page.dart';
import 'update_profile_view.dart';
import 'booking/my_bookings_page.dart'; // Import MyBookingsPage
import 'search_properties_view.dart'; // Import the search view

class UserLandingView extends StatefulWidget {
  final String userId;

  UserLandingView({required this.userId});

  @override
  _UserLandingViewState createState() => _UserLandingViewState();
}

class _UserLandingViewState extends State<UserLandingView> {
  int _selectedIndex = 0;
  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      DecouvrirPage(userId: '',), // Display the DecouvrirPage here
      SearchPropertiesView(userId: widget.userId), // Pass userId to SearchPropertiesView
      MyBookingsPage(guestId: widget.userId, userId: '',), // Pass userId to MyBookingsPage as guestId
      UpdateProfileView(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF000000), Color(0xFF292A32)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0), // Margin for top, right, left, and bottom
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0), // Border radius
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed, // Ensures all items are displayed
            backgroundColor: Color(0x1FFFFFFF), // Background color
            unselectedItemColor: Colors.white, // Color of unselected items
            selectedItemColor: Colors.amber[800], // Color of selected item
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.explore),
                label: 'Decouvrir',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.book),
                label: 'Reservations', // Update icon and label for reservations
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
