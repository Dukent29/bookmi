import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart'; // Adjust the import according to your project structure
import 'decouvrir_page.dart';
import 'update_profile_view.dart';
import 'booking/my_bookings_page.dart';
import 'search_properties_view.dart';
import 'auth/login_view.dart'; // Assuming you have a LoginView to navigate after logout

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
      ProfilePage(), // Use ProfilePage for the profile tab
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
                label: 'Profil',
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

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil', style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
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
                  _showLogoutConfirmation(context);
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

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF292A32),
          title: Text('Confirmation', style: TextStyle(fontFamily: 'Poppins', color: Colors.white)),
          content: Text('Êtes-vous sûr de vouloir vous déconnecter ?', style: TextStyle(fontFamily: 'Poppins', color: Colors.white)),
          actions: <Widget>[
            TextButton(
              child: Text('Annuler', style: TextStyle(fontFamily: 'Poppins', color: Color(0xFFF7B818))),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Déconnexion', style: TextStyle(fontFamily: 'Poppins', color: Colors.red)),
              onPressed: () {
                Provider.of<AuthProvider>(context, listen: false).logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginView()),
                );
              },
            ),
          ],
        );
      },
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
