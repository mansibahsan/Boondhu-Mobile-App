import 'package:flutter_riverpod/flutter_riverpod.dart';

// Separate providers for each screen to prevent search state leaking.
final storeSearchProvider = StateProvider<String>((ref) => "");
final servicesSearchProvider = StateProvider<String>((ref) => "");
final kitchenSearchProvider = StateProvider<String>((ref) => "");

// NEW: Store Category Filter
final storeCategoryProvider = StateProvider<String>((ref) => "All");

// NEW: Services Category Filter
final servicesCategoryProvider = StateProvider<String>((ref) => "All");

// NEW: Delivery Category Filter
final deliveryCategoryProvider = StateProvider<String>((ref) => "All");

// Keep a general one for backward compatibility
final searchProvider = storeSearchProvider;
