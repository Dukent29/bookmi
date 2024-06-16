import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'views/register_view.dart';
import 'views/login_view.dart';
import 'views/update_profile_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: MaterialApp(
        title: 'Bookmi App',
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        initialRoute: '/register',
        routes: {
          '/register': (context) => RegisterView(),
          '/login': (context) => LoginView(),
          '/update_profile': (context) => UpdateProfileView(),
        },
      ),
    );
  }
}
