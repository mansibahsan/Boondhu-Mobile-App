import 'package:flutter_riverpod/flutter_riverpod.dart';

class Order {
  final String id;
  final String title;
  final String status;
  final String date;
  final String type; // 'Store', 'Service', 'Delivery', 'Kitchen'

  Order({
    required this.id,
    required this.title,
    required this.status,
    required this.date,
    required this.type,
  });
}

class OrdersNotifier extends StateNotifier<List<Order>> {
  OrdersNotifier() : super([
    Order(
      id: '#ORD-2024-001',
      title: 'Monthly Groceries',
      status: 'Delivered',
      date: '10 May 2024',
      type: 'Store',
    ),
  ]);

  void addOrder(Order order) {
    state = [order, ...state];
  }
}

final ordersProvider = StateNotifierProvider<OrdersNotifier, List<Order>>((ref) {
  return OrdersNotifier();
});
