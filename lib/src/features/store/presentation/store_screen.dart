import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../domain/product.dart';
import '../data/cart_provider.dart';
import '../../../core/providers/search_provider.dart'; // ADDED

class StoreScreen extends ConsumerWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final searchQuery = ref.watch(storeSearchProvider).toLowerCase(); // WATCH SEARCH

    // Original list of products
    final allProducts = [
      Product(id: '1', name: 'Basmati Rice 5kg', price: '৳580', rating: 4.8, image: ''),
      Product(id: '2', name: 'Fresh Milk 1L', price: '৳95', rating: 4.9, image: ''),
      Product(id: '3', name: 'Hand Sanitizer', price: '৳120', rating: 4.5, image: ''),
      Product(id: '4', name: 'Baby Diapers', price: '৳450', rating: 4.7, image: ''),
      Product(id: '5', name: 'Paracetamol 500mg', price: '৳35', rating: 4.6, image: ''),
      Product(id: '6', name: 'Cooking Oil 1L', price: '৳220', rating: 4.4, image: ''),
    ];

    // --- FILTER PRODUCTS BASED ON SEARCH ---
    final filteredProducts = allProducts.where((p) {
      return p.name.toLowerCase().contains(searchQuery);
    }).toList();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context, ref, cartItems.length), // Pass ref
            _buildCategories(),
            _buildSectionHeader(searchQuery.isEmpty ? 'Popular Products' : 'Search Results'),
            if (filteredProducts.isEmpty)
              _buildNoResults()
            else
              _buildProductGrid(ref, filteredProducts), // Pass filtered list
          ],
        ),
      ),
    );
  }

  Widget _buildNoResults() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Icon(Icons.search_off, size: 60, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text('No products found', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref, int cartCount) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 60, 16, 24),
      decoration: const BoxDecoration(
        color: AppColors.storeBlue,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Column(
        children: [
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
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () => context.push('/cart'),
                child: Stack(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.white24,
                      child: Icon(Icons.shopping_cart_outlined, color: Colors.white),
                    ),
                    if (cartCount > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                          child: Text('$cartCount', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // --- CONNECTED SEARCH BAR ---
          TextField(
            onChanged: (value) {
              ref.read(storeSearchProvider.notifier).state = value; // UPDATE SEARCH
            },
            decoration: InputDecoration(
              hintText: 'Search products...',
              hintStyle: const TextStyle(color: Colors.grey),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              suffixIcon: ref.watch(storeSearchProvider).isNotEmpty 
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey),
                    onPressed: () => ref.read(storeSearchProvider.notifier).state = "",
                  )
                : null,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
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
                Text(cat['name'] as String, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
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

  Widget _buildProductGrid(WidgetRef ref, List<Product> products) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.78,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return _productCard(ref, products[index]);
      },
    );
  }

  Widget _productCard(WidgetRef ref, Product product) {
    return GestureDetector(
      onTap: () {
        ref.context.push('/product-detail', extra: product);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.storeBlue.withOpacity(0.08),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: const Center(child: Icon(Icons.image_outlined, size: 40, color: Colors.grey)),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(product.price, style: const TextStyle(color: AppColors.storeBlue, fontWeight: FontWeight.bold, fontSize: 16)),
                      Row(children: [const Icon(Icons.star, color: Colors.amber, size: 14), Text(' ${product.rating}', style: const TextStyle(fontSize: 12, color: Colors.grey))]),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ref.read(cartProvider.notifier).addProduct(product);
                        ScaffoldMessenger.of(ref.context).showSnackBar(SnackBar(content: Text('${product.name} added to cart!'), duration: const Duration(seconds: 1)));
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.storeBlue, padding: const EdgeInsets.symmetric(vertical: 8), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                      child: const Text('Add to Cart', style: TextStyle(fontSize: 12)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
