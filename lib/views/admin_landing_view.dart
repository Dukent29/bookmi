import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/auth_provider.dart';
import '../views/update_profile_view.dart';
import '../views/announce_view.dart';
import '../views/actualite_page.dart';
import '../views/edit_calendar.dart';
import '../views/auth/login_view.dart'; // Assuming you have a LoginView to navigate after logout

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
      ActualitePage(userId: _userId),
      EditCalendarPage(),
      AnnounceView(),
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.message, size: 50, color: Colors.grey),
            SizedBox(height: 10),
            Text('Arrive bientôt', style: TextStyle(color: Colors.white, fontSize: 24, fontFamily: 'Poppins')),
          ],
        ),
      ),
      ProfilePage(),
    ];

    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    return Scaffold(
      backgroundColor: Colors.transparent, // Add this line
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
        color: Colors.transparent,
        child: Container(
          margin: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
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
              backgroundColor: Colors.grey.withOpacity(0.5),
              elevation: 0,
              type: BottomNavigationBarType.fixed,
            ),
          ),
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil', style: TextStyle(fontFamily: 'Poppins', color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
              _buildProfileOption(
                context,
                icon: Icons.person,
                label: 'Gérer votre compte',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UpdateProfileView()),
                  );
                },
              ),
              _buildProfileOption(
                context,
                icon: Icons.card_giftcard,
                label: 'Récompense et portefeuille',
                onTap: () => _navigateToComingSoon(context),
              ),
              _buildProfileOption(
                context,
                icon: Icons.favorite,
                label: 'Sauvegardé',
                onTap: () => _navigateToComingSoon(context),
              ),
              _buildProfileOption(
                context,
                icon: Icons.rate_review,
                label: 'Commentaires',
                onTap: () => _navigateToComingSoon(context),
              ),
              _buildProfileOption(
                context,
                icon: Icons.question_answer,
                label: 'FAQ',
                onTap: () => _navigateToComingSoon(context),
              ),
              SizedBox(height: 20),
              Text(
                'Aide et soutien',
                style: TextStyle(color: Colors.white, fontFamily: 'Poppins', fontWeight: FontWeight.bold),
              ),
              _buildProfileOption(
                context,
                icon: Icons.contact_support,
                label: 'Contacter le service client',
                onTap: () => _navigateToComingSoon(context),
              ),
              _buildProfileOption(
                context,
                icon: Icons.security,
                label: 'Centre de ressources sur la sécurité',
                onTap: () => _navigateToComingSoon(context),
              ),
              SizedBox(height: 20),
              Text(
                'Paramètres et légal',
                style: TextStyle(color: Colors.white, fontFamily: 'Poppins', fontWeight: FontWeight.bold),
              ),
              _buildProfileOption(
                context,
                icon: Icons.settings,
                label: 'Paramètres',
                onTap: () => _navigateToComingSoon(context),
              ),
              _buildProfileOption(
                context,
                icon: Icons.gavel,
                label: 'Légal',
                onTap: () => _navigateToComingSoon(context),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  Provider.of<AuthProvider>(context, listen: false).logout();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginView()),
                  );
                },
                child: Text(
                  'Déconnexion',
                  style: TextStyle(color: Colors.red, fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption(BuildContext context, {required IconData icon, required String label, required Function() onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToComingSoon(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ComingSoonPage()),
    );
  }
}

class ComingSoonPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Arrive bientôt', style: TextStyle(fontFamily: 'Poppins')),
      ),
      body: Center(
        child: Text(
          'Arrive bientôt :)',
          style: TextStyle(fontSize: 24, fontFamily: 'Poppins'),
        ),
      ),
    );
  }
}
