class Product {
  final String id;
  final String name;
  final String price;
  final double rating;
  final String image;
  final String category; // NEW: Added category field

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.rating,
    required this.image,
    required this.category,
  });
}
