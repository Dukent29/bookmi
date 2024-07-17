import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../views/update_profile_view.dart';
import '../views/announce_view.dart';
import '../views/actualite_page.dart';
import '../views/edit_calendar.dart';

class AdminLandingView extends StatefulWidget {
  @override
  _AdminLandingViewState createState() => _AdminLandingViewState();
}

class _AdminLandingViewState extends State<AdminLandingView> {
  int _selectedIndex = 0;
  String _userId = '';

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getString('userId') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      ActualitePage(userId: _userId), // Pass userId to ActualitePage
      EditCalendarPage(), // Navigate to EditCalendarPage
      AnnounceView(),
      Text('Messagerie'),
      UpdateProfileView(),
    ];

    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    return Scaffold(
      backgroundColor: Colors.transparent, // Add this line
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Administratif'),
      ),
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
        color: Colors.transparent, // Apply background color to the whole container
        child: Container(
          margin: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0), // Margin for all sides
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0), // Border radius
            child: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.event),
                  label: 'Actualité',
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
                  label: 'Profil',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.amber[800],
              unselectedItemColor: Colors.white,
              onTap: _onItemTapped,
              backgroundColor: Colors.grey.withOpacity(0.5), // Semi-transparent background
              elevation: 0, // Remove shadow/elevation
              type: BottomNavigationBarType.fixed,
            ),
          ),
        ),
      ),
    );
  }
}
