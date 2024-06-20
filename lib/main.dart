import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'views/login_view.dart';
import 'views/register_view.dart';
import 'views/update_profile_view.dart';
import 'views/admin_landing_view.dart';
import 'views/user_landing_view.dart';
import 'views/add_property_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: MaterialApp(
        title: 'Bookmi',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => LoginView(),
          '/register': (context) => RegisterView(),
          '/update_profile': (context) => UpdateProfileView(),
          '/admin': (context) => AdminLandingView(),
          '/user': (context) => UserLandingView(),
          '/add_property': (context) => AddPropertyView(),
        },
      ),
    );
  }
}
