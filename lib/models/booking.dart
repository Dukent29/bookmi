class Booking {
  final int id;
  final int propertyId;
  final String startDate;
  final String endDate;
  final double totalPrice;
  final int numPeople; // Add this line

  Booking({
    required this.id,
    required this.propertyId,
    required this.startDate,
    required this.endDate,
    required this.totalPrice,
    required this.numPeople, // Add this line
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      propertyId: json['property_id'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      totalPrice: json['total_price'].toDouble(),
      numPeople: json['num_people'], // Add this line
    );
  }
}
