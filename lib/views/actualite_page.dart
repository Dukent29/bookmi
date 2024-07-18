import 'package:flutter/material.dart';
import '../widgets/greeting_widget.dart';
import '../widgets/bookings_list_widget.dart';

class ActualitePage extends StatefulWidget {
  final String userId;

  ActualitePage({required this.userId});

  @override
  _ActualitePageState createState() => _ActualitePageState();
}

class _ActualitePageState extends State<ActualitePage> {
  void _navigateToComingSoon(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ComingSoonPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Actualité', style: TextStyle(fontFamily: 'Poppins')),
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
              GreetingWidget(userId: widget.userId),  // Use GreetingWidget here
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Logic for Actualités button
                      },
                      child: Text('Actualités', style: TextStyle(fontFamily: 'Poppins')),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {

                      },
                      child: Text('En attente', style: TextStyle(fontFamily: 'Poppins')),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[850],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {

                      },
                      child: Text('Reserv passé', style: TextStyle(fontFamily: 'Poppins')),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[850],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {

                      },
                      child: Text('Annulées', style: TextStyle(fontFamily: 'Poppins')),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[850],
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
              SizedBox(height: 16),
              Expanded(
                child: BookingsListWidget(userId: widget.userId),  // Use BookingsListWidget here
              ),
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () => _navigateToComingSoon(context),
                      child: Row(
                        children: [
                          Icon(Icons.contact_support, color: Colors.white),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Contactez le service à la clientèle',
                              style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    InkWell(
                      onTap: () => _navigateToComingSoon(context),
                      child: Row(
                        children: [
                          Icon(Icons.security, color: Colors.white),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Centre de ressources sur la sécurité',
                              style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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
