class MealModel {
  final String id;
  final String name;
  final String kitchenName;
  final String price;
  final double rating;
  final String time;
  final String description;
  final String image;

  MealModel({
    required this.id,
    required this.name,
    required this.kitchenName,
    required this.price,
    required this.rating,
    required this.time,
    required this.description,
    this.image = '',
  });

  factory MealModel.fromJson(Map<String, dynamic> json) {
    return MealModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      kitchenName: json['kitchen_name'] ?? 'Unknown Kitchen',
      price: json['price'] != null ? '৳ ${json['price']}' : '৳ 0',
      rating: double.tryParse(json['rating'].toString()) ?? 0.0,
      time: json['preparation_time'] != null ? '${json['preparation_time']} mins' : 'N/A',
      description: json['description'] ?? '',
      image: json['image'] ?? 'https://via.placeholder.com/500',
    );
  }
}
