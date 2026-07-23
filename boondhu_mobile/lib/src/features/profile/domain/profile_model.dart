class ProfileModel {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final int totalOrders;
  final double walletBalance;
  final int rewardPoints;

  ProfileModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.totalOrders,
    required this.walletBalance,
    required this.rewardPoints,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id']?.toString() ?? '',
      fullName: json['full_name'] ?? json['first_name'] ?? 'User',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      totalOrders: json['total_orders'] ?? 0,
      walletBalance: double.tryParse(json['wallet_balance']?.toString() ?? '0') ?? 0.0,
      rewardPoints: int.tryParse(json['reward_points']?.toString() ?? '0') ?? 0,
    );
  }
}
