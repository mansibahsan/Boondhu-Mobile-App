class ServiceModel {
  final String id;
  final String name;
  final String providerName;
  final String price;
  final double rating;
  final String description;
  final String category; // NEW: Added category field

  ServiceModel({
    required this.id,
    required this.name,
    required this.providerName,
    required this.price,
    required this.rating,
    required this.description,
    required this.category,
  });
}
