class Product {
  final String id;
  final String name;
  final String price;
  final double rating;
  final String image;
  final String category;
  final String description;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.rating,
    required this.image,
    required this.category,
    this.description = '',
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // The Django backend returns 'price' as string/decimal, 'id' as int, 'image' as url string
    return Product(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      price: json['price'] != null ? '৳ ${json['price']}' : '৳ 0',
      rating: (json['average_rating'] ?? 0.0).toDouble(),
      image: json['primary_image'] ?? 'https://via.placeholder.com/500',
      category: json['category'] ?? 'General',
      description: json['description'] ?? '',
    );
  }
}
