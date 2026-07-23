import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          _notificationItem(
            'Order Delivered!',
            'Your e-Store order #ORD-8921 has been delivered. Rate your experience!',
            '2 mins ago',
            Icons.check_circle,
            Colors.green,
            true, // Unread
          ),
          _notificationItem(
            'Rider Assigned',
            'A rider has been assigned to your parcel request #DEL-2847. He is on his way!',
            '1 hour ago',
            Icons.delivery_dining,
            AppColors.deliveryPurple,
            false,
          ),
          _notificationItem(
            '20% OFF Special!',
            'Enjoy 20% discount on all e-Kitchen orders today. Use code: EAT20',
            '5 hours ago',
            Icons.local_offer,
            Colors.orange,
            false,
          ),
          _notificationItem(
            'System Update',
            'Boondhu app just got better! Check out our new e-Kitchen features.',
            'Yesterday',
            Icons.system_update,
            Colors.blue,
            false,
          ),
          _notificationItem(
            'Payment Successful',
            'Your wallet has been topped up with ৳2,000.',
            '2 days ago',
            Icons.account_balance_wallet,
            Colors.teal,
            false,
          ),
        ],
      ),
    );
  }

  Widget _notificationItem(
    String title,
    String body,
    String time,
    IconData icon,
    Color color,
    bool isUnread,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUnread ? color.withOpacity(0.05) : Colors.transparent,
        border: Border(
          bottom: BorderSide(color: Colors.grey.withOpacity(0.1)),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    if (isUnread)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13, height: 1.4),
                ),
                const SizedBox(height: 8),
                Text(
                  time,
                  style: TextStyle(color: Colors.grey[400], fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
