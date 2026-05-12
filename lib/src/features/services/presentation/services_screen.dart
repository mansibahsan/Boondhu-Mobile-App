import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../domain/service_model.dart';
import '../../../core/providers/search_provider.dart';

class ServicesScreen extends ConsumerWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(servicesSearchProvider).toLowerCase();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context, ref),
            _buildServiceCategories(),
            _buildSectionHeader(searchQuery.isEmpty ? 'Top Rated Providers' : 'Search Results'),
            _buildFilteredProviders(context, searchQuery),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 60, 16, 24),
      decoration: const BoxDecoration(
        color: AppColors.servicesGreen,
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
                'e-Services',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const CircleAvatar(
                backgroundColor: Colors.white24,
                child: Icon(Icons.filter_list, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            onChanged: (value) => ref.read(servicesSearchProvider.notifier).state = value,
            decoration: InputDecoration(
              hintText: 'Search for services...',
              hintStyle: const TextStyle(color: Colors.grey),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              suffixIcon: ref.watch(servicesSearchProvider).isNotEmpty 
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey),
                    onPressed: () => ref.read(servicesSearchProvider.notifier).state = "",
                  )
                : null,
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

  Widget _buildServiceCategories() {
    final categories = [
      {'name': 'Plumbing', 'icon': Icons.plumbing, 'color': Colors.blue},
      {'name': 'Electrical', 'icon': Icons.electrical_services, 'color': Colors.orange},
      {'name': 'AC Service', 'icon': Icons.ac_unit, 'color': Colors.cyan},
      {'name': 'Painting', 'icon': Icons.format_paint, 'color': Colors.purple},
      {'name': 'Cleaning', 'icon': Icons.cleaning_services, 'color': Colors.teal},
      {'name': 'Car Wash', 'icon': Icons.local_car_wash, 'color': Colors.red},
      {'name': 'Gardening', 'icon': Icons.yard, 'color': Colors.green},
      {'name': 'Moving', 'icon': Icons.local_shipping, 'color': Colors.brown},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final cat = categories[index];
        final color = cat['color'] as Color;
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: color.withOpacity(0.2)),
              ),
              child: Icon(cat['icon'] as IconData, color: color, size: 26),
            ),
            const SizedBox(height: 6),
            Text(
              cat['name'] as String,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ],
        );
      },
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

  Widget _buildFilteredProviders(BuildContext context, String query) {
    final allProviders = [
      ServiceModel(
        id: '1',
        name: 'AC Repair & Service',
        providerName: 'Cooling Solutions Ltd.',
        price: '৳1,200',
        rating: 4.8,
        description: 'Professional AC servicing including gas charging, filter cleaning, and full diagnostic checkup.',
      ),
      ServiceModel(
        id: '2',
        name: 'House Deep Cleaning',
        providerName: 'Clean & Shine',
        price: '৳2,500',
        rating: 4.9,
        description: 'Complete home deep cleaning service using premium non-toxic chemicals and professional equipment.',
      ),
      ServiceModel(
        id: '3',
        name: 'Professional Plumbing',
        providerName: 'Expert Plumbers',
        price: '৳500',
        rating: 4.7,
        description: 'Expert plumbing services for leak detection, pipe repair, and fixture installation.',
      ),
    ];

    final filtered = allProviders.where((p) {
      return p.name.toLowerCase().contains(query) || p.providerName.toLowerCase().contains(query);
    }).toList();

    if (filtered.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Icon(Icons.search_off, size: 60, color: Colors.grey),
            SizedBox(height: 16),
            Text('No providers found', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final p = filtered[index];
        return GestureDetector(
          onTap: () {
            context.push('/service-detail', extra: p);
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.servicesGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.person, color: AppColors.servicesGreen),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      Text(p.providerName, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 14),
                          Text(' ${p.rating}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(p.price, style: const TextStyle(color: AppColors.servicesGreen, fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        context.push('/service-detail', extra: p);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.servicesGreen,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Book', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
