import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../views/auth/login_view.dart';

class AuthGuard extends StatelessWidget {
  final Widget child;

  const AuthGuard({required this.child});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return authProvider.isAuthenticated ? child : LoginView();
  }
}
