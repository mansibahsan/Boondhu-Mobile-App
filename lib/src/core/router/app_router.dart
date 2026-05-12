import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/store/presentation/store_screen.dart';
import '../../features/services/presentation/services_screen.dart';
import '../../features/delivery/presentation/delivery_screen.dart';
import '../../features/kitchen/presentation/kitchen_screen.dart';

/// Central navigation for the entire app.
/// Every screen route is defined here in one place.
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      // Home Dashboard
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),

      // e-Store — Product browsing
      GoRoute(
        path: '/store',
        name: 'store',
        builder: (context, state) => const StoreScreen(),
      ),

      // e-Services — Service categories & providers
      GoRoute(
        path: '/services',
        name: 'services',
        builder: (context, state) => const ServicesScreen(),
      ),

      // e-Delivery — Parcel, document, express delivery
      GoRoute(
        path: '/delivery',
        name: 'delivery',
        builder: (context, state) => const DeliveryScreen(),
      ),

      // e-Kitchen — Food ordering
      GoRoute(
        path: '/kitchen',
        name: 'kitchen',
        builder: (context, state) => const KitchenScreen(),
      ),
    ],
  );
}
