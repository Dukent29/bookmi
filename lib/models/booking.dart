class Booking {
  final int id;
  final int propertyId;
  final int guestId;
  final String startDate;
  final String endDate;
  final double totalPrice;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int numPeople;
  final String propertyTitle;
  final String propertyDescription;
  final String propertyAddress;
  final String propertyCity;
  final String propertyState;
  final String propertyCountry;
  final String? propertyZipCode;
  final double propertyPricePerNight;
  final int propertyMaxGuests;
  final int propertyNumBedrooms;
  final int propertyNumBathrooms;
  final String propertyAmenities;

  Booking({
    required this.id,
    required this.propertyId,
    required this.guestId,
    required this.startDate,
    required this.endDate,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.numPeople,
    required this.propertyTitle,
    required this.propertyDescription,
    required this.propertyAddress,
    required this.propertyCity,
    required this.propertyState,
    required this.propertyCountry,
    this.propertyZipCode,
    required this.propertyPricePerNight,
    required this.propertyMaxGuests,
    required this.propertyNumBedrooms,
    required this.propertyNumBathrooms,
    required this.propertyAmenities,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      propertyId: json['property_id'],
      guestId: json['guest_id'],
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      totalPrice: double.parse(json['total_price'] ?? '0'),
      status: json['status'] ?? 'unknown',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      numPeople: json['num_people'] ?? 0,
      propertyTitle: json['property_title'] ?? 'No title',
      propertyDescription: json['property_description'] ?? 'No description',
      propertyAddress: json['property_address'] ?? 'No address',
      propertyCity: json['property_city'] ?? 'No city',
      propertyState: json['property_state'] ?? 'No state',
      propertyCountry: json['property_country'] ?? 'No country',
      propertyZipCode: json['property_zip_code'],
      propertyPricePerNight: double.parse(json['property_price_per_night'] ?? '0'),
      propertyMaxGuests: json['property_max_guests'] ?? 0,
      propertyNumBedrooms: json['property_num_bedrooms'] ?? 0,
      propertyNumBathrooms: json['property_num_bathrooms'] ?? 0,
      propertyAmenities: json['property_amenities'] ?? 'No amenities',
    );
  }
}
