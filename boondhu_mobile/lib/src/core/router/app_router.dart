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
import '../../features/services/presentation/service_booking_screen.dart';
import '../../features/kitchen/presentation/meal_detail_screen.dart';
import '../../features/tracking/presentation/tracking_screen.dart';
import '../../features/delivery/presentation/parcel_info_screen.dart';
import '../../features/notifications/presentation/notifications_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/signup_screen.dart';
import '../../features/orders/presentation/orders_screen.dart';
import '../../features/profile/presentation/shipping_addresses_screen.dart';
import '../../features/profile/presentation/payment_methods_screen.dart';
import '../../features/profile/presentation/settings_screen.dart';
import '../../features/store/domain/product.dart';
import '../../features/services/domain/service_model.dart';
import '../../features/kitchen/domain/meal_model.dart';

class AppRouter {
  static CustomTransitionPage _buildPageWithDefaultTransition<T>({
    required BuildContext context, 
    required GoRouterState state, 
    required Widget child,
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    routes: [
      // Auth
      GoRoute(
        path: '/login',
        name: 'login',
        pageBuilder: (context, state) => _buildPageWithDefaultTransition(context: context, state: state, child: const LoginScreen()),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        pageBuilder: (context, state) => _buildPageWithDefaultTransition(context: context, state: state, child: const SignUpScreen()),
      ),

      // Home Dashboard
      GoRoute(
        path: '/',
        name: 'home',
        pageBuilder: (context, state) => _buildPageWithDefaultTransition(context: context, state: state, child: const HomeScreen()),
      ),

      // Store
      GoRoute(
        path: '/store',
        name: 'store',
        pageBuilder: (context, state) => _buildPageWithDefaultTransition(context: context, state: state, child: const StoreScreen()),
      ),

      // Services
      GoRoute(
        path: '/services',
        name: 'services',
        pageBuilder: (context, state) => _buildPageWithDefaultTransition(context: context, state: state, child: const ServicesScreen()),
      ),

      // Delivery
      GoRoute(
        path: '/delivery',
        name: 'delivery',
        pageBuilder: (context, state) => _buildPageWithDefaultTransition(context: context, state: state, child: const DeliveryScreen()),
      ),

      // Kitchen
      GoRoute(
        path: '/kitchen',
        name: 'kitchen',
        pageBuilder: (context, state) => _buildPageWithDefaultTransition(context: context, state: state, child: const KitchenScreen()),
      ),

      // Cart & Checkout
      GoRoute(
        path: '/cart',
        name: 'cart',
        pageBuilder: (context, state) => _buildPageWithDefaultTransition(context: context, state: state, child: const CartScreen()),
      ),
      GoRoute(
        path: '/checkout',
        name: 'checkout',
        pageBuilder: (context, state) => _buildPageWithDefaultTransition(context: context, state: state, child: const CheckoutScreen()),
      ),

      // Details
      GoRoute(
        path: '/product-detail',
        name: 'product-detail',
        pageBuilder: (context, state) {
          final product = state.extra as Product;
          return _buildPageWithDefaultTransition(context: context, state: state, child: ProductDetailScreen(product: product));
        },
      ),
      GoRoute(
        path: '/service-detail',
        name: 'service-detail',
        pageBuilder: (context, state) {
          final service = state.extra as ServiceModel;
          return _buildPageWithDefaultTransition(context: context, state: state, child: ServiceDetailScreen(service: service));
        },
      ),
      GoRoute(
        path: '/service-booking',
        name: 'service-booking',
        pageBuilder: (context, state) {
          final service = state.extra as ServiceModel;
          return _buildPageWithDefaultTransition(context: context, state: state, child: ServiceBookingScreen(service: service));
        },
      ),
      GoRoute(
        path: '/meal-detail',
        name: 'meal-detail',
        pageBuilder: (context, state) {
          final meal = state.extra as MealModel;
          return _buildPageWithDefaultTransition(context: context, state: state, child: MealDetailScreen(meal: meal));
        },
      ),
      GoRoute(
        path: '/parcel-info',
        name: 'parcel-info',
        pageBuilder: (context, state) {
          final category = state.extra as String;
          return _buildPageWithDefaultTransition(context: context, state: state, child: ParcelInfoScreen(category: category));
        },
      ),

      // Others
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        pageBuilder: (context, state) => _buildPageWithDefaultTransition(context: context, state: state, child: const NotificationsScreen()),
      ),
      // Profile sub-pages
      GoRoute(
        path: '/tracking',
        name: 'tracking',
        pageBuilder: (context, state) => _buildPageWithDefaultTransition(context: context, state: state, child: const TrackingScreen()),
      ),
      GoRoute(
        path: '/orders',
        name: 'orders',
        pageBuilder: (context, state) => _buildPageWithDefaultTransition(context: context, state: state, child: const OrdersScreen()),
      ),
      GoRoute(
        path: '/shipping-addresses',
        name: 'shipping-addresses',
        pageBuilder: (context, state) => _buildPageWithDefaultTransition(context: context, state: state, child: const ShippingAddressesScreen()),
      ),
      GoRoute(
        path: '/payment-methods',
        name: 'payment-methods',
        pageBuilder: (context, state) => _buildPageWithDefaultTransition(context: context, state: state, child: const PaymentMethodsScreen()),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        pageBuilder: (context, state) => _buildPageWithDefaultTransition(context: context, state: state, child: const SettingsScreen()),
      ),
    ],
  );
}
