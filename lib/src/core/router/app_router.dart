import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/store/presentation/store_screen.dart';
import '../../features/services/presentation/services_screen.dart';
import '../../features/delivery/presentation/delivery_screen.dart';
import '../../features/kitchen/presentation/kitchen_screen.dart';
import '../../features/store/presentation/cart_screen.dart';
import '../../features/store/presentation/checkout_screen.dart';
import '../../features/store/presentation/product_detail_screen.dart';
import '../../features/services/presentation/service_detail_screen.dart';
import '../../features/kitchen/presentation/meal_detail_screen.dart';
import '../../features/delivery/presentation/parcel_info_screen.dart';
import '../../features/notifications/presentation/notifications_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/signup_screen.dart'; // ADDED
import '../../features/store/domain/product.dart';
import '../../features/services/domain/service_model.dart';
import '../../features/kitchen/domain/meal_model.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    routes: [
      // Auth
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignUpScreen(),
      ),

      // Home Dashboard
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),

      // Store
      GoRoute(
        path: '/store',
        name: 'store',
        builder: (context, state) => const StoreScreen(),
      ),

      // Services
      GoRoute(
        path: '/services',
        name: 'services',
        builder: (context, state) => const ServicesScreen(),
      ),

      // Delivery
      GoRoute(
        path: '/delivery',
        name: 'delivery',
        builder: (context, state) => const DeliveryScreen(),
      ),

      // Kitchen
      GoRoute(
        path: '/kitchen',
        name: 'kitchen',
        builder: (context, state) => const KitchenScreen(),
      ),

      // Cart & Checkout
      GoRoute(
        path: '/cart',
        name: 'cart',
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: '/checkout',
        name: 'checkout',
        builder: (context, state) => const CheckoutScreen(),
      ),

      // Details
      GoRoute(
        path: '/product-detail',
        name: 'product-detail',
        builder: (context, state) {
          final product = state.extra as Product;
          return ProductDetailScreen(product: product);
        },
      ),
      GoRoute(
        path: '/service-detail',
        name: 'service-detail',
        builder: (context, state) {
          final service = state.extra as ServiceModel;
          return ServiceDetailScreen(service: service);
        },
      ),
      GoRoute(
        path: '/meal-detail',
        name: 'meal-detail',
        builder: (context, state) {
          final meal = state.extra as MealModel;
          return MealDetailScreen(meal: meal);
        },
      ),
      GoRoute(
        path: '/parcel-info',
        name: 'parcel-info',
        builder: (context, state) {
          final category = state.extra as String;
          return ParcelInfoScreen(category: category);
        },
      ),

      // Others
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
    ],
  );
}
