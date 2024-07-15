import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/property.dart';
import '../models/property_photo.dart';
import '../models/review.dart';
import 'dart:typed_data';
import 'package:http_parser/http_parser.dart';
import '../models/booking.dart';
import '../models/payment.dart';

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
      _userId = data['userId'].toString();  // Ensure userId is a string
      notifyListeners();

      // Save userId in shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', _userId!);
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

  void logout() async {
    _token = null;
    _role = null;
    _userId = null;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
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
      throw Exception('Échec du chargement des propriétés');
    }
  }

  Future<Map<String, dynamic>> getPropertyById(int propertyId) async {
    final response = await http.get(
      Uri.parse('http://localhost:5000/api/properties/$propertyId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('propriete introuvable');
    }
  }

  Future<void> addProperty({
    required Property property,
    required List<Uint8List> images,
  }) async {
    final uri = Uri.parse('http://localhost:5000/api/properties/add-property-with-images');
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $_token'
      ..fields['title'] = property.title
      ..fields['description'] = property.description
      ..fields['address'] = property.address
      ..fields['city'] = property.city
      ..fields['state'] = property.state
      ..fields['country'] = property.country
      ..fields['zip_code'] = property.zipCode
      ..fields['price_per_night'] = property.pricePerNight.toString()
      ..fields['max_guests'] = property.maxGuests.toString()
      ..fields['num_bedrooms'] = property.numBedrooms.toString()
      ..fields['num_bathrooms'] = property.numBathrooms.toString()
      ..fields['amenities'] = property.amenities;

    for (var i = 0; i < images.length; i++) {
      request.files.add(http.MultipartFile.fromBytes(
        'property_photos',
        images[i],
        filename: 'image$i.jpg',
        contentType: MediaType('image', 'jpeg'),
      ));
    }

    final response = await request.send();

    if (response.statusCode != 201) {
      throw Exception('Failed to add property with images');
    }
  }

  Future<String> createBooking({
    required int propertyId,
    required String startDate,
    required String endDate,
    required int numPeople,
  }) async {
    print('Creating booking for propertyId: $propertyId, startDate: $startDate, endDate: $endDate, numPeople: $numPeople'); // Debugging
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
        'num_people': numPeople,
      }),
    );

    print('Response status: ${response.statusCode}'); // Debugging
    print('Response body: ${response.body}'); // Debugging

    if (response.statusCode != 200) {
      throw Exception('Failed to create booking');
    }

    return response.body;
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
      throw Exception('Échec du chargement des propriétés');
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
    print(response.statusCode);
    print('http://localhost:5000/api/property-photos/$propertyId');

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => PropertyPhoto.fromJson(item)).toList();
    } else {
      throw Exception('Échec du chargement des photos de la propriété');
    }

  }
  Future<String> fetchPropertyPhotoUrl(int propertyId) async {
    final response = await http.get(
      Uri.parse('http://localhost:5000/api/properties/$propertyId/returnpicture'),
      headers: {
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode == 200) {
      // Construct the URL to access the image
      return 'http://localhost:5000/api/properties/$propertyId/returnpicture';
    } else {
      throw Exception('Échec du chargement des photos de la propriété');
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
      throw Exception('Échec du chargement des avis');
    }
  }
  Future<List<Property>> fetchRecentlyAddedProperties() async {
    final response = await http.get(
      Uri.parse('http://localhost:5000/api/properties/recently-added'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Property.fromJson(item)).toList();
    } else {
      throw Exception('Échec du chargement des propriétés récemment ajoutées');
    }
  }
  Future<void> updatePropertyStatusToFavoris(int propertyId) async {
    final response = await http.put(
      Uri.parse('http://localhost:5000/api/properties/status/favoris'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
      body: jsonEncode({'id': propertyId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update property status to favoris');
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
      throw Exception('Échec du chargement des réservations');
    }
  }
  //detail booking
  Future<Booking> getBookingById(int bookingId) async {
    final response = await http.get(
      Uri.parse('http://localhost:5000/api/bookings/$bookingId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        return Booking.fromJson(data[0]); // Assuming the first element is the booking
      } else {
        throw Exception('No booking found');
      }
    } else {
      throw Exception('Failed to load booking');
    }
  }

  Future<List<Booking>> getBookingsByUser(String userId) async {
    print('Fetching bookings for userId: $userId'); // Debug statement
    final response = await http.get(
      Uri.parse('http://localhost:5000/api/bookings/guest/$userId'), // This route should match
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      print('Bookings data: $data'); // Debugging line
      return data.map((json) => Booking.fromJson(json)).toList();
    } else {
      print('Failed to load bookings: ${response.statusCode}'); // Debugging line
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
      throw Exception('Échec du chargement des réservations');
    }
  }

  //fetch users propertys bookings
  Future<List<Map<String, dynamic>>> fetchBookingsByUserProperties(String userId) async {
    final response = await http.get(
      Uri.parse('http://localhost:5000/api/bookings/user/$userId'),
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
      throw Exception('Échec du blocage des dates');
    }
  }

  //payment method
  Future<void> createPayment({
    required int bookingId,
    required double amount,
    required String paymentMethod,
    required String paymentStatus,
  }) async {
    final response = await http.post(
      Uri.parse('http://localhost:5000/api/payments'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
      body: jsonEncode({
        'booking_id': bookingId,
        'amount': amount,
        'payment_method': paymentMethod,
        'payment_status': paymentStatus,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create payment');
    }
  }
}
