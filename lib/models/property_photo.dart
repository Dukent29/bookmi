class PropertyPhoto {
  final String id;
  final String propertyId;
  final String url;
  final String description;

  PropertyPhoto({
    required this.id,
    required this.propertyId,
    required this.url,
    required this.description,
  });

  factory PropertyPhoto.fromJson(Map<String, dynamic> json) {
    return PropertyPhoto(
      id: json['_id'] ?? '',
      propertyId: json['property_id'] ?? '',
      url: json['url'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'property_id': propertyId,
      'url': url,
      'description': description,
    };
  }
}
