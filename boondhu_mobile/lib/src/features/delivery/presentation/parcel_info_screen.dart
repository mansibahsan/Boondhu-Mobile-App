import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../tracking/data/tracking_provider.dart';
import '../domain/delivery_model.dart';

class ParcelInfoScreen extends ConsumerStatefulWidget {
  final String category;

  const ParcelInfoScreen({super.key, required this.category});

  @override
  ConsumerState<ParcelInfoScreen> createState() => _ParcelInfoScreenState();
}

class _ParcelInfoScreenState extends ConsumerState<ParcelInfoScreen> {
  String selectedWeight = 'Under 1kg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Send ${widget.category}',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.deliveryPurple,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader('Pickup Details'),
            _buildLocationField('Pickup from...', Icons.my_location, Colors.blue),
            const SizedBox(height: 24),
            _sectionHeader('Drop-off Details'),
            _buildLocationField('Deliver to...', Icons.location_on, Colors.red),
            const SizedBox(height: 24),
            _sectionHeader('Parcel Weight'),
            _buildWeightSelector(),
            const SizedBox(height: 24),
            _sectionHeader('Package Category'),
            _buildCategoryChip(),
            const SizedBox(height: 40),
            _buildContinueButton(context),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildLocationField(String hint, IconData icon, Color iconColor) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: Icon(icon, color: iconColor),
        suffixIcon: const Icon(Icons.map_outlined, color: AppColors.deliveryPurple),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.deliveryPurple),
        ),
      ),
    );
  }

  Widget _buildWeightSelector() {
    final weights = ['Under 1kg', '1-5kg', '5-10kg', 'Above 10kg'];
    return Wrap(
      spacing: 12,
      children: weights.map((w) {
        final isSelected = selectedWeight == w;
        return ChoiceChip(
          label: Text(w),
          selected: isSelected,
          onSelected: (val) {
            setState(() {
              selectedWeight = w;
            });
          },
          selectedColor: AppColors.deliveryPurple.withOpacity(0.2),
          labelStyle: TextStyle(
            color: isSelected ? AppColors.deliveryPurple : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCategoryChip() {
    return Chip(
      label: Text(widget.category),
      backgroundColor: AppColors.deliveryPurple.withOpacity(0.1),
      side: const BorderSide(color: AppColors.deliveryPurple),
    );
  }

  Widget _buildContinueButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Save to tracking
          final newDelivery = DeliveryModel(
            id: '#BD-${(1000 + (ref.read(trackingProvider).deliveries.length * 7))}',
            from: 'Current Location',
            to: 'Selected Destination',
            status: 'Picking Up',
            type: widget.category,
            weight: selectedWeight,
            price: '৳ 60',
            image: 'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?auto=format&fit=crop&w=500&q=80',
          );
          ref.read(trackingProvider.notifier).addDeliveryRequest(newDelivery);
          _showSuccessDialog(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.deliveryPurple,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Text(
          'Confirm Request',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 16),
            const Text(
              'Request Sent!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'A rider will be assigned soon to pick up your package.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.go('/'); // Go back to Home
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.deliveryPurple,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
