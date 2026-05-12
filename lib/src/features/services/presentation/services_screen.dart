import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            _buildServiceCategories(),
            _buildSectionHeader('Top Rated Providers'),
            _buildProviderList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
            decoration: InputDecoration(
              hintText: 'Search for services...',
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

  Widget _buildProviderList() {
    final providers = [
      {'name': 'Md. Karim', 'service': 'Plumbing', 'rating': 4.9, 'jobs': 120, 'color': Colors.blue},
      {'name': 'Rahim Sheikh', 'service': 'AC Service', 'rating': 4.8, 'jobs': 95, 'color': Colors.cyan},
      {'name': 'Abdul Hasan', 'service': 'Electrical', 'rating': 4.7, 'jobs': 80, 'color': Colors.orange},
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: providers.length,
      itemBuilder: (context, index) {
        final p = providers[index];
        final color = p['color'] as Color;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
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
              // Provider avatar
              CircleAvatar(
                radius: 28,
                backgroundColor: color.withOpacity(0.15),
                child: Icon(Icons.person, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              // Provider info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p['name'] as String,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      p['service'] as String,
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                        Text(
                          ' ${p['rating']}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.work_outline, size: 14, color: Colors.grey[500]),
                        Text(
                          ' ${p['jobs']} jobs',
                          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Book button
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.servicesGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                child: const Text('Book', style: TextStyle(fontSize: 13)),
              ),
            ],
          ),
        );
      },
    );
  }
}
