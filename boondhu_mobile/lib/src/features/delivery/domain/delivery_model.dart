class DeliveryModel {
  final String id;
  final String from;
  final String to;
  final String status;
  final String type;
  final String weight;
  final String price;
  final String eta;
  final String image;

  DeliveryModel({
    required this.id,
    required this.from,
    required this.to,
    required this.status,
    required this.type,
    required this.weight,
    required this.price,
    this.eta = 'Pending',
    this.image = '',
  });
}
