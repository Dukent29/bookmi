// models/review.dart

class Review {
  final String id;
  final String propertyId;
  final String guestId;
  final String comment;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.propertyId,
    required this.guestId,
    required this.comment,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['_id'] ?? '',
      propertyId: json['property_id'] ?? '',
      guestId: json['guest_id'] ?? '',
      comment: json['comment'] ?? '',
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'property_id': propertyId,
      'guest_id': guestId,
      'comment': comment,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
