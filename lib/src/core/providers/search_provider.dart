import 'package:flutter_riverpod/flutter_riverpod.dart';

// Separate providers for each screen to prevent search state leaking.
final storeSearchProvider = StateProvider<String>((ref) => "");
final servicesSearchProvider = StateProvider<String>((ref) => "");
final kitchenSearchProvider = StateProvider<String>((ref) => "");

// Keep a general one for backward compatibility
final searchProvider = storeSearchProvider;
