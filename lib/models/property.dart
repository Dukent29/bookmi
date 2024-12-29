class Property {
  final int id;
  final String title;
  final String description;
  final String address;
  final String city;
  final String state;
  final String country;
  final String zipCode;
  final double pricePerNight;
  final int maxGuests;
  final int numBedrooms;
  final int numBathrooms;
  final String amenities;
  final DateTime createdAt;
  final DateTime updatedAt;

  Property({
    required this.id,
    required this.title,
    required this.description,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.zipCode,
    required this.pricePerNight,
    required this.maxGuests,
    required this.numBedrooms,
    required this.numBathrooms,
    required this.amenities,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      zipCode: json['zip_code'] ?? '',
      pricePerNight: double.tryParse(json['price_per_night'].toString()) ?? 0.0,
      maxGuests: json['max_guests'] ?? 0,
      numBedrooms: json['num_bedrooms'] ?? 0,
      numBathrooms: json['num_bathrooms'] ?? 0,
      amenities: json['amenities'] ?? '',
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'address': address,
      'city': city,
      'state': state,
      'country': country,
      'zip_code': zipCode,
      'price_per_night': pricePerNight,
      'max_guests': maxGuests,
      'num_bedrooms': numBedrooms,
      'num_bathrooms': numBathrooms,
      'amenities': amenities,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
