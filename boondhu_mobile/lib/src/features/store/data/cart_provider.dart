import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/product.dart';

// This is a "Notifier". It notifies the app whenever the cart changes.
class CartNotifier extends StateNotifier<List<Product>> {
  CartNotifier() : super([]); // Start with an empty cart []

  // Function to add a product
  void addProduct(Product product) {
    state = [...state, product]; // Add the new product to the list
  }

  // Function to remove a product
  void removeProduct(String productId) {
    state = state.where((p) => p.id != productId).toList();
  }

  // Function to calculate total price
  double get totalCartPrice {
    double total = 0;
    for (var item in state) {
      // Extract numeric value from price string (e.g., "৳ 250/kg" -> 250)
      final numericString = item.price.replaceAll(RegExp(r'[^0-9]'), '');
      total += double.tryParse(numericString) ?? 0;
    }
    return total;
  }

  void clearCart() {
    state = [];
  }
}

// This "Provider" allows any screen in the app to talk to the CartNotifier.
final cartProvider = StateNotifierProvider<CartNotifier, List<Product>>((ref) {
  return CartNotifier();
});
