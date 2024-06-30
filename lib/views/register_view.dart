import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'admin_landing_view.dart';
import 'user_landing_view.dart';

class RegisterView extends StatefulWidget {
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String _message = '';

  Future<void> _register() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _message = 'Passwords do not match';
      });
      return;
    }

    try {
      await Provider.of<AuthProvider>(context, listen: false).register(
        _usernameController.text,
        _emailController.text,
        _passwordController.text,
      );

      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      if (authProvider.isAdmin) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminLandingView()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserLandingView(userId: authProvider.userId ?? '')),
        );
      }
    } catch (e) {
      setState(() {
        _message = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
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
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 45.0),
            child: Column(
              children: <Widget>[
            RichText(
            text: TextSpan(
              style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
            children: <TextSpan>[
              TextSpan(
                text: 'Book',
                style: TextStyle(color: Colors.white),
              ),
              TextSpan(
                text: 'mi',
                style: TextStyle(color: Colors.orange),
              ),
            ],
          ),
        ),
        SizedBox(height: 20.0),
        Container(
          width: double.infinity,
          child: TextField(
            controller: _usernameController,
            decoration: InputDecoration(
              labelText: 'Username',
              labelStyle: TextStyle(fontFamily: 'Poppins'),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              filled: true,
              fillColor: Colors.grey[200],
            ),
          ),
        ),
        SizedBox(height: 10.0),
        Container(
          width: double.infinity,
          child: TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: TextStyle(fontFamily: 'Poppins'),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              filled: true,
              fillColor: Colors.grey[200],
            ),
          ),
        ),
        SizedBox(height: 10.0),
        Container(
          width: double.infinity,
          child: TextField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              labelStyle: TextStyle(fontFamily: 'Poppins'),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              filled: true,
              fillColor: Colors.grey[200],
            ),
            obscureText: true,
          ),
        ),
        SizedBox(height: 10.0),
        Container(
          width: double.infinity,
          child: TextField(
            controller: _confirmPasswordController,
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              labelStyle: TextStyle(fontFamily: 'Poppins'),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              filled: true,
              fillColor: Colors.grey[200],
            ),
            obscureText: true,
          ),
        ),
        SizedBox(height: 20.0),
        Container(
          width: double.infinity, // Make the button full width
          child: ElevatedButton(
            onPressed: _register,
            child: Text(
              'Register',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                color: Colors.white, // Set the text color to white
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: EdgeInsets.symmetric(vertical: 20.0), // Padding top and bottom
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ),
        ),
        SizedBox(height: 20.0),
        Text(
            _message,
        style: TextStyle(color: Colors.red, fontFamily: 'Poppins'),
      ),
      SizedBox(height: 20.0),
      GestureDetector(
        onTap: () {
          Navigator.pushReplacementNamed(context, '/');
        },
        child: Text(
          'Already have an account? Login',
          style: TextStyle(
            color: Colors.orange,
            decoration: TextDecoration.underline,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      ],
    ),
    ),
    ),
    ),
    );
  }
}
