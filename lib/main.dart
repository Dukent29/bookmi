import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'views/auth/login_view.dart' as login_view;
import 'views/auth/register_view.dart' as register_view;
import 'views/update_profile_view.dart';
import 'views/admin_landing_view.dart';
import 'views/user_landing_view.dart';
import 'views/add_property_view.dart';
import 'views/search_properties_view.dart';
import 'views/my_single_property.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return MaterialApp(
            title: 'Bookmi',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              scaffoldBackgroundColor: Color(0x0),
            ),
            initialRoute: '/',
            routes: {
              '/': (context) => login_view.LoginView(),
              '/register': (context) => register_view.RegisterView(),
              '/update_profile': (context) => UpdateProfileView(),
              '/admin': (context) => AdminLandingView(),
              '/user': (context) => UserLandingView(userId: authProvider.userId ?? ''),
              '/add_property': (context) => AddPropertyView(),
              '/search_properties': (context) => SearchPropertiesView(userId: authProvider.userId ?? ''),
              '/property_details': (context) => MySingleProperty(propertyId: ModalRoute.of(context)?.settings.arguments as int),
            },
            builder: (context, child) {
              return Stack(
                children: [
                  // Background gradient
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF000000), Color(0xFF292A32)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  // Main content
                  child!,
                ],
              );
            },
          );
        },
      ),
    );
  }
}
