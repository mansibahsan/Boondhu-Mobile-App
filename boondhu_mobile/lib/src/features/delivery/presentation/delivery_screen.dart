import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/search_provider.dart';
import '../../tracking/data/tracking_provider.dart';

class DeliveryScreen extends ConsumerWidget {
  const DeliveryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(deliveryCategoryProvider);
    final trackedDeliveries = ref.watch(trackingProvider).deliveries;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context, ref, trackedDeliveries.length),
            _buildDeliveryTypes(context, ref, selectedCategory),
            _buildSectionHeader('Active Deliveries'),
            _buildActiveDeliveries(ref, selectedCategory, trackedDeliveries),
            _buildSectionHeader('Delivery Zones & SLA'),
            _buildZoneInfo(),
            const SizedBox(height: 100),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push('/parcel-info', extra: 'Parcel');
        },
        backgroundColor: AppColors.deliveryPurple,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('New Request', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref, int trackedCount) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 60, 16, 24),
      decoration: const BoxDecoration(
        color: AppColors.deliveryPurple,
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
                'e-Delivery',
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
            onChanged: (value) {
              // ref.read(deliverySearchProvider.notifier).state = value;
            },
            decoration: InputDecoration(
              hintText: 'Track your delivery...',
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

  Widget _buildDeliveryTypes(BuildContext context, WidgetRef ref, String selected) {
    final types = [
      {'name': 'All', 'icon': Icons.grid_view, 'desc': 'Show all items'},
      {'name': 'Parcel', 'icon': Icons.inventory_2, 'desc': 'Send packages'},
      {'name': 'Document', 'icon': Icons.description, 'desc': 'Secure docs'},
      {'name': 'Store Order', 'icon': Icons.store, 'desc': 'e-Store items'},
      {'name': 'Express', 'icon': Icons.flash_on, 'desc': '2hr delivery'},
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.35, // FIXED: Increased aspect ratio to prevent overflow
        ),
        itemCount: types.length,
        itemBuilder: (context, index) {
          final t = types[index];
          final name = t['name'] as String;
          final isSelected = selected == name;

          return GestureDetector(
            onTap: () {
              ref.read(deliveryCategoryProvider.notifier).state = name;
              if (name != 'All') {
                context.push('/parcel-info', extra: name);
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.deliveryPurple : AppColors.deliveryPurple.withOpacity(0.08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppColors.deliveryPurple : AppColors.deliveryPurple.withOpacity(0.15)
                ),
                boxShadow: isSelected ? [
                  BoxShadow(color: AppColors.deliveryPurple.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))
                ] : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    t['icon'] as IconData, 
                    color: isSelected ? Colors.white : AppColors.deliveryPurple, 
                    size: 28
                  ),
                  const SizedBox(height: 8),
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      fontSize: 14,
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                  ),
                  Text(
                    t['desc'] as String,
                    style: TextStyle(
                      fontSize: 11, 
                      color: isSelected ? Colors.white.withOpacity(0.8) : Colors.grey[600]
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
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

  Widget _buildActiveDeliveries(WidgetRef ref, String category, List<dynamic> trackedDeliveries) {
    final demoDeliveries = [
      {
        'id': '#BD-2847',
        'from': 'Mymensingh Sadar',
        'to': 'Gafargaon',
        'status': 'In Transit',
        'statusColor': Colors.orange,
        'eta': '2 hours',
        'type': 'Parcel',
        'image': 'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?auto=format&fit=crop&w=500&q=80',
      },
      {
        'id': '#BD-2843',
        'from': 'Trishal',
        'to': 'Mymensingh Sadar',
        'status': 'Delivered',
        'statusColor': Colors.green,
        'eta': 'Completed',
        'type': 'Document',
        'image': 'https://images.unsplash.com/photo-1568071296049-b92e43f77c8f?auto=format&fit=crop&w=500&q=80',
      },
      {
        'id': '#BD-2901',
        'from': 'Boondhu Mart',
        'to': 'Mymensingh Sadar',
        'status': 'Picking Up',
        'statusColor': Colors.blue,
        'eta': '15 mins',
        'type': 'Store Order',
        'image': 'https://images.unsplash.com/photo-1542838132-92c53300491e?auto=format&fit=crop&w=500&q=80',
      },
    ];

    // Convert tracked deliveries to match map format
    final convertedTracked = trackedDeliveries.map((d) => {
      'id': d.id,
      'from': d.from,
      'to': d.to,
      'status': d.status,
      'statusColor': Colors.orange,
      'eta': d.eta,
      'type': d.type,
      'image': d.image,
    }).toList();

    final allDeliveries = [...convertedTracked, ...demoDeliveries];

    final filtered = allDeliveries.where((d) => 
      category == 'All' || d['type'] == category
    ).toList();

    if (filtered.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Icon(Icons.inventory_2_outlined, size: 40, color: Colors.grey[300]),
            const SizedBox(height: 8),
            Text('No active $category deliveries', style: const TextStyle(color: Colors.grey)),
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
        final d = filtered[index];
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
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: 40,
                          height: 40,
                          margin: const EdgeInsets.only(right: 12),
                          color: AppColors.deliveryPurple.withOpacity(0.1),
                          child: (d['image'] as String).isNotEmpty 
                            ? Image.network(
                                d['image'] as String, 
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => const Icon(Icons.inventory_2, color: AppColors.deliveryPurple, size: 20),
                              )
                            : const Icon(Icons.inventory_2, color: AppColors.deliveryPurple, size: 20),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            d['id'] as String,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              d['type'] as String,
                              style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: (d['statusColor'] as Color).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      d['status'] as String,
                      style: TextStyle(
                        color: d['statusColor'] as Color,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Column(
                    children: [
                      const Icon(Icons.circle, size: 10, color: AppColors.deliveryPurple),
                      Container(width: 2, height: 20, color: Colors.grey[300]),
                      const Icon(Icons.location_on, size: 14, color: Colors.red),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(d['from'] as String, style: const TextStyle(fontSize: 13)),
                        const SizedBox(height: 8),
                        Text(
                          d['to'] as String,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      const Icon(Icons.timer_outlined, size: 16, color: Colors.grey),
                      const SizedBox(height: 2),
                      Text(
                        d['eta'] as String,
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildZoneInfo() {
    final zones = [
      {'zone': 'Priority (City)', 'area': 'Mymensingh Sadar', 'sla': '2–6 hrs', 'color': Colors.green},
      {'zone': 'Zone A', 'area': 'Gafargaon, Muktagacha, Trishal', 'sla': '6–12 hrs', 'color': Colors.blue},
      {'zone': 'Zone B', 'area': 'Netrokona, Kendua', 'sla': '12–24 hrs', 'color': Colors.orange},
      {'zone': 'Zone C', 'area': 'Kishoreganj, Karimganj', 'sla': '24–36 hrs', 'color': Colors.red},
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: zones.length,
      itemBuilder: (context, index) {
        final z = zones[index];
        final color = z['color'] as Color;
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: color.withOpacity(0.06),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withOpacity(0.15)),
          ),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 36,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      z['zone'] as String,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Text(
                      z['area'] as String,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  z['sla'] as String,
                  style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
