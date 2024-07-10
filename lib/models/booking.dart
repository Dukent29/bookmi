class Booking {
  final int id;
  final int propertyId;
  final String startDate;
  final String endDate;
  final double totalPrice;

  Booking({
    required this.id,
    required this.propertyId,
    required this.startDate,
    required this.endDate,
    required this.totalPrice,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      propertyId: json['property_id'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      totalPrice: json['total_price'].toDouble(),
    );
  }
}
