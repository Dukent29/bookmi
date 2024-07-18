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

  //login/connexion
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

  //register/inscription
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

  //fetch user connected username
  Future<String> fetchUsernameById(String userId) async {
    final response = await http.get(
      Uri.parse('http://localhost:5000/api/users/username/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['username'];
    } else {
      throw Exception('Failed to load username');
    }
  }

  //log out
  void logout() async {
    _token = null;
    _role = null;
    _userId = null;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
  }

  //edit user infos
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

  // search function
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

  //fetch properties by id(mostly used to display property in a singlr detail page)
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

  //create/add property
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

  //create bookings
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

  //display and properties on user interface
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

  //display and photo properties (only)
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

  //display and photo properties and their data
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

  //for displaying reviews
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

  //for search purpose and display properties recently added or created
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

  //update propertis determinr if there is promotion
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

  //fetch bookings done on certain property (general)
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

  //fetch properties detail (one by one)
  Future<Map<String, dynamic>> fetchPropertyDetails(int propertyId) async {
    final response = await http.get(
      Uri.parse('http://localhost:5000/api/properties/$propertyId/details'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load property details');
    }
  }

  //edit property
  Future<void> updateProperty(int propertyId, Map<String, dynamic> updateData) async {
    final response = await http.put(
      Uri.parse('http://localhost:5000/api/properties/$propertyId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
      body: jsonEncode(updateData),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update property');
    }
  }

  //get booking by id if (need to edit or display in single page with all infos)
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

  //fetch own bookings
  Future<List<Booking>> getBookingsByUser(String userId) async {
    final response = await http.get(
      Uri.parse('http://localhost:5000/api/bookings/guest/$userId'), // This route should match
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;

      return data.map((json) => Booking.fromJson(json)).toList();
    } else {

      throw Exception('Failed to load bookings');
    }
  }

  //cancel user's booking
  Future<void> cancelBooking(int bookingId) async {
    final response = await http.put(
      Uri.parse('http://localhost:5000/api/bookings/cancel/$bookingId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to cancel booking');
    }
  }

  //update my booking
  Future<void> updateBooking({
    required int bookingId,
    required DateTime startDate,
    required DateTime endDate,
    required int numPeople,
  }) async {
    final url = 'http://localhost:5000/api/bookings/my-booking/$bookingId';
    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
      body: jsonEncode({
        'start_date': startDate.toIso8601String(),
        'end_date': endDate.toIso8601String(),
        'num_people': numPeople,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update booking');
    }
  }

  // fetch bookings to display to admin page (non-used)
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

  //fetch users' properties' bookings
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

  //delete property
  Future<void> deleteProperty(int propertyId) async {
    final url = Uri.parse('http://localhost:5000/api/properties/$propertyId');
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token', // Add authentication token if needed
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete property');
    }
  }

  //if admin wants to see his/properties
  Future<List<Map<String, dynamic>>> fetchMyProperties(String userId) async {
    final response = await http.get(
      Uri.parse('http://localhost:5000/api/properties/my-properties/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load properties');
    }
  }

  //blocking dates
  Future<void> addBlockedDate({
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
      throw Exception('Failed to add blocked date');
    }
  }

  //fetch to display blocked date
  Future<List<Map<String, dynamic>>> getBlockedDates(int propertyId) async {
    final response = await http.get(
      Uri.parse('http://localhost:5000/api/blocked-dates/$propertyId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to fetch blocked dates');
    }
  }

  //unblocking dates
  Future<void> unblockDate(int blockedDateId) async {
    final response = await http.delete(
      Uri.parse('http://localhost:5000/api/blocked-dates/unblock/$blockedDateId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to unblock date');
    }
  }

  //block date(if admin)
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
