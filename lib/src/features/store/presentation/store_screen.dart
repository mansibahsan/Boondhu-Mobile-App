import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with back button
            _buildHeader(context),
            // Category chips
            _buildCategories(),
            // Section title
            _buildSectionHeader('Popular Products'),
            // Product grid
            _buildProductGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 60, 16, 24),
      decoration: const BoxDecoration(
        color: AppColors.storeBlue,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Column(
        children: [
          // Top row: Back button + Title + Cart
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const CircleAvatar(
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.arrow_back, color: Colors.white),
                ),
              ),
              const Text(
                'e-Store',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const CircleAvatar(
                backgroundColor: Colors.white24,
                child: Icon(Icons.shopping_cart_outlined, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Search bar
          TextField(
            decoration: InputDecoration(
              hintText: 'Search products...',
              hintStyle: const TextStyle(color: Colors.grey),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    final categories = [
      {'name': 'Medicine', 'icon': Icons.medical_services},
      {'name': 'Groceries', 'icon': Icons.shopping_basket},
      {'name': 'Baby Care', 'icon': Icons.child_care},
      {'name': 'Cleaning', 'icon': Icons.cleaning_services},
    ];

    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          return Container(
            width: 80,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: AppColors.storeBlue.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.storeBlue.withOpacity(0.15)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(cat['icon'] as IconData, color: AppColors.storeBlue, size: 28),
                const SizedBox(height: 6),
                Text(
                  cat['name'] as String,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          TextButton(onPressed: () {}, child: const Text('See All')),
        ],
      ),
    );
  }

  Widget _buildProductGrid() {
    final products = [
      {'name': 'Basmati Rice 5kg', 'price': '৳580', 'rating': '4.8'},
      {'name': 'Fresh Milk 1L', 'price': '৳95', 'rating': '4.9'},
      {'name': 'Hand Sanitizer', 'price': '৳120', 'rating': '4.5'},
      {'name': 'Baby Diapers', 'price': '৳450', 'rating': '4.7'},
      {'name': 'Paracetamol 500mg', 'price': '৳35', 'rating': '4.6'},
      {'name': 'Cooking Oil 1L', 'price': '৳220', 'rating': '4.4'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.78,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _productCard(
          product['name']!,
          product['price']!,
          product['rating']!,
        );
      },
    );
  }

  Widget _productCard(String name, String price, String rating) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image placeholder
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.storeBlue.withOpacity(0.08),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: const Center(
              child: Icon(Icons.image_outlined, size: 40, color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      price,
                      style: const TextStyle(
                        color: AppColors.storeBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                        Text(
                          ' $rating',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Add to cart button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.storeBlue,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Add to Cart', style: TextStyle(fontSize: 12)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
