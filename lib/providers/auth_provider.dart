import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/property.dart';
import '../models/property_photo.dart';
import '../models/review.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  String? _role;
  String? _userId;

  String? get token => _token;
  String? get role => _role;
  String? get userId => _userId;

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
      _role = data['role'];
      _userId = data['userId'];
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
      await login(email, password);
    } else {
      throw Exception(data['message']);
    }
  }

  Future<void> updateProfile(String firstName, String lastName, String bio,
      String profilePicture) async {
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
    _userId = null;
    notifyListeners();
  }

  Future<List<Property>> searchProperties({required String address}) async {
    final response = await http.get(
      Uri.parse('http://localhost:5000/api/properties/search?address=$address'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Property.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load properties');
    }
  }

  Future<void> addProperty(Property property) async {
    final response = await http.post(
      Uri.parse('http://localhost:5000/api/properties/add-property'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
      body: jsonEncode(property.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add property');
    }
  }

  Future<void> createBooking({
    required int propertyId,
    required String startDate,
    required String endDate,
  }) async {
    print('Creating booking for propertyId: $propertyId, startDate: $startDate, endDate: $endDate'); // Debugging
    final response = await http.post(
      Uri.parse('http://localhost:5000/api/bookings/book'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
      body: jsonEncode({
        'property_id': propertyId,
        'start_date': startDate,
        'end_date': endDate,
      }),
    );

    print('Response status: ${response.statusCode}'); // Debugging
    print('Response body: ${response.body}'); // Debugging

    if (response.statusCode != 201) {
      throw Exception('Failed to create booking');
    }
  }

  Future<List<Property>> fetchProperties() async {
    final response = await http.get(
      Uri.parse('http://localhost:5000/api/properties'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Property.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load properties');
    }
  }

  Future<List<PropertyPhoto>> fetchPropertyPhotos(int propertyId) async {
    final response = await http.get(
      Uri.parse('http://localhost:5000/api/property-photos/$propertyId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => PropertyPhoto.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load property photos');
    }
  }

  Future<List<Review>> fetchReviews(int propertyId) async {
    final response = await http.get(
      Uri.parse('http://localhost:5000/api/reviews/property/$propertyId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Review.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load reviews');
    }
  }

  Future<List<Map<String, dynamic>>> fetchBookingsByProperties(List<int> propertyIds) async {
    final response = await http.post(
      Uri.parse('http://localhost:5000/api/bookings/properties'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
      body: jsonEncode({'property_ids': propertyIds}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load bookings');
    }
  }

  Future<List<Map<String, dynamic>>> fetchBookings(int propertyId) async {
    final response = await http.get(
      Uri.parse('http://localhost:5000/api/bookings/property/$propertyId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load bookings');
    }
  }

  Future<void> blockDates({
    required int propertyId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final response = await http.post(
      Uri.parse('http://localhost:5000/api/blocked-dates/blockDate'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
      body: jsonEncode({
        'property_id': propertyId,
        'start_date': startDate.toIso8601String(),
        'end_date': endDate.toIso8601String(),
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to block dates');
    }
  }
}
