import 'package:flutter/material.dart';
import 'decouvrir_page.dart';
import 'update_profile_view.dart';
import 'booking/my_bookings_page.dart';
import 'search_properties_view.dart';

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
      DecouvrirPage(userId: widget.userId),
      SearchPropertiesView(userId: widget.userId),
      MyBookingsPage(guestId: widget.userId),
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
        margin: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0), // Border radius
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Color(0x15FFFFFF),
            unselectedItemColor: Colors.white,
            selectedItemColor: Colors.amber[800],
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.explore),
                label: 'Decouvrir',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Accueil',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.book),
                label: 'Mes Reservations', // Update icon and label for reservations
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
