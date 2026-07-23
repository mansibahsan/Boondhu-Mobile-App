import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../data/tracking_provider.dart';
import '../../services/domain/service_model.dart';
import '../../delivery/domain/delivery_model.dart';

class TrackingScreen extends ConsumerWidget {
  const TrackingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tracked = ref.watch(trackingProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text(
            'Track Requests',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: AppColors.primary,
          iconTheme: const IconThemeData(color: Colors.white),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            tabs: [
              Tab(text: 'Services'),
              Tab(text: 'Deliveries'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildServicesTab(context, tracked.services),
            _buildDeliveriesTab(context, tracked.deliveries),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesTab(BuildContext context, List<ServiceModel> services) {
    if (services.isEmpty) {
      return _buildEmptyState(Icons.business_center_outlined, 'No active service bookings');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final s = services[index];
        return _buildTrackingCard(
          title: s.name,
          subtitle: s.providerName,
          price: s.price,
          status: 'Provider Assigned',
          statusColor: Colors.blue,
          icon: Icons.build_circle_outlined,
          color: AppColors.servicesGreen,
          image: s.image,
        );
      },
    );
  }

  Widget _buildDeliveriesTab(BuildContext context, List<DeliveryModel> deliveries) {
    if (deliveries.isEmpty) {
      return _buildEmptyState(Icons.local_shipping_outlined, 'No active delivery requests');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: deliveries.length,
      itemBuilder: (context, index) {
        final d = deliveries[index];
        return _buildTrackingCard(
          title: '${d.type} Request',
          subtitle: 'From: ${d.from}\nTo: ${d.to}',
          price: d.price,
          status: d.status,
          statusColor: Colors.orange,
          icon: Icons.local_shipping_outlined,
          color: AppColors.deliveryPurple,
          image: d.image,
        );
      },
    );
  }

  Widget _buildEmptyState(IconData icon, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingCard({
    required String title,
    required String subtitle,
    required String price,
    required String status,
    required Color statusColor,
    required IconData icon,
    required Color color,
    required String image,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                  image: image.isNotEmpty ? DecorationImage(image: NetworkImage(image), fit: BoxFit.cover) : null,
                ),
                child: image.isEmpty ? Icon(icon, color: color, size: 30) : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(price, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.history, size: 16, color: Colors.grey),
                  SizedBox(width: 4),
                  Text('Status: Updated 2 mins ago', style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                child: const Text('View Detail', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
