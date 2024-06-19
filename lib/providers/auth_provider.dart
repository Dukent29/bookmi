import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthProvider with ChangeNotifier {
  String? _token;
  String? _role;
  String? get token => _token;
  String? get role => _role;

  bool get isAuthenticated => _token != null;
  bool get isAdmin => _role == 'admin';

  Future<void> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('http://localhost:5000/api/users/login'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      _token = data['token'];
      _role = data['role']; // Ensure the role is correctly set
      notifyListeners();
    } else {
      throw Exception(data['message']);
    }
  }

  Future<void> register(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('http://localhost:5000/api/users/register'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      await login(email, password); // Automatically login after registration
    } else {
      throw Exception(data['message']);
    }
  }

  Future<void> updateProfile(String firstName, String lastName, String bio, String profilePicture) async {
    final response = await http.put(
      Uri.parse('http://localhost:5000/api/users/profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
      body: jsonEncode(<String, String>{
        'first_name': firstName,
        'last_name': lastName,
        'bio': bio,
        'profile_picture': profilePicture,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(data['message']);
    }
  }

  void logout() {
    _token = null;
    _role = null;
    notifyListeners();
  }
}
