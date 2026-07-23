import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../domain/service_model.dart';
import '../../../core/providers/search_provider.dart';
import '../../../core/data/mock_repository.dart';
import '../../tracking/data/tracking_provider.dart';

class ServicesScreen extends ConsumerWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(servicesSearchProvider).toLowerCase();
    final selectedCategory = ref.watch(servicesCategoryProvider);
    final trackedServices = ref.watch(trackingProvider).services;
    final servicesAsync = ref.watch(servicesProvider);

    return Scaffold(
      body: servicesAsync.when(
        data: (allProviders) => SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(context, ref, trackedServices.length),
              _buildServiceCategories(ref, selectedCategory),
              _buildSectionHeader(searchQuery.isEmpty 
                  ? (selectedCategory == 'All' ? 'Top Rated Providers' : '$selectedCategory Experts') 
                  : 'Search Results'),
              _buildFilteredProviders(context, allProviders, searchQuery, selectedCategory),
              const SizedBox(height: 20),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error loading services: $err')),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref, int trackedCount) {
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
              GestureDetector(
                onTap: () => context.push('/tracking'),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.white24,
                      child: Icon(Icons.receipt_long, color: Colors.white),
                    ),
                    if (trackedCount > 0)
                      Positioned(
                        right: -4,
                        top: -4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                          constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                          child: Text(
                            '$trackedCount',
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
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

  Widget _buildServiceCategories(WidgetRef ref, String selected) {
    final categories = [
      {'name': 'All', 'icon': Icons.grid_view, 'color': AppColors.servicesGreen},
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
        mainAxisSpacing: 16,
        childAspectRatio: 0.82,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final cat = categories[index];
        final name = cat['name'] as String;
        final color = cat['color'] as Color;
        final isSelected = selected == name;

        return GestureDetector(
          onTap: () {
            ref.read(servicesCategoryProvider.notifier).state = name;
          },
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isSelected ? color : color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: color.withOpacity(0.2)),
                  boxShadow: isSelected ? [
                    BoxShadow(color: color.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))
                  ] : null,
                ),
                child: Icon(
                  cat['icon'] as IconData, 
                  color: isSelected ? Colors.white : color, 
                  size: 26
                ),
              ),
              const SizedBox(height: 6),
              Text(
                name,
                style: TextStyle(
                  fontSize: 10, 
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: isSelected ? color : Colors.black87,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
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

  Widget _buildFilteredProviders(BuildContext context, List<ServiceModel> allProviders, String query, String selectedCat) {

    final filtered = allProviders.where((p) {
      final matchesSearch = p.name.toLowerCase().contains(query) || p.providerName.toLowerCase().contains(query);
      final matchesCategory = selectedCat == 'All' || p.category == selectedCat;
      return matchesSearch && matchesCategory;
    }).toList();

    if (filtered.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Icon(Icons.search_off, size: 60, color: Colors.grey[300]),
            const SizedBox(height: 16),
            const Text('No providers found', style: TextStyle(color: Colors.grey)),
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
                Hero(
                  tag: 'service-${p.id}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 60,
                      height: 60,
                      color: AppColors.servicesGreen.withOpacity(0.1),
                      child: p.image.isNotEmpty 
                        ? Image.network(
                            p.image, 
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, color: AppColors.servicesGreen),
                          )
                        : const Icon(Icons.person, color: AppColors.servicesGreen),
                    ),
                  ),
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
                        context.push('/service-booking', extra: p);
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
