import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'views/login_view.dart';
import 'views/register_view.dart';
import 'views/update_profile_view.dart';
import 'views/admin_landing_view.dart';
import 'views/user_landing_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return MaterialApp(
            title: 'BookMe',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            initialRoute: auth.isAuthenticated ? (auth.isAdmin ? '/admin' : '/user') : '/login',
            routes: {
              '/login': (context) => LoginView(),
              '/register': (context) => RegisterView(),
              '/profile': (context) => UpdateProfileView(),
              '/admin': (context) => AdminLandingView(),
              '/user': (context) => UserLandingView(),
            },
            onGenerateRoute: (settings) {
              if (auth.isAuthenticated) {
                if (auth.isAdmin && settings.name == '/admin') {
                  return MaterialPageRoute(builder: (context) => AdminLandingView());
                } else if (!auth.isAdmin && settings.name == '/user') {
                  return MaterialPageRoute(builder: (context) => UserLandingView());
                }
                // Redirect non-admins trying to access admin page
                if (!auth.isAdmin && settings.name == '/admin') {
                  return MaterialPageRoute(builder: (context) => UserLandingView());
                }
              }
              return MaterialPageRoute(builder: (context) => LoginView());
            },
          );
        },
      ),
    );
  }
}
