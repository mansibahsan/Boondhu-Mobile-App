class ServiceModel {
  final String id;
  final String name;
  final String providerName;
  final String price;
  final double rating;
  final String description;
  final String category;
  final String image;

  ServiceModel({
    required this.id,
    required this.name,
    required this.providerName,
    required this.price,
    required this.rating,
    required this.description,
    required this.category,
    this.image = '',
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      providerName: json['provider_name'] ?? 'Unknown Provider',
      price: json['price'] != null ? '৳ ${json['price']}' : '৳ 0',
      rating: (json['rating'] ?? 0.0).toDouble(),
      description: json['description'] ?? '',
      category: json['category_name'] ?? 'General',
      image: json['image'] ?? 'https://via.placeholder.com/500',
    );
  }
}
