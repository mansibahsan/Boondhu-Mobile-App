import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/store/domain/product.dart';
import '../../features/store/data/store_repository.dart';
import '../../features/services/domain/service_model.dart';
import '../../features/services/data/services_repository.dart';
import '../../features/kitchen/domain/meal_model.dart';
import '../../features/kitchen/data/kitchen_repository.dart';

final productsProvider = FutureProvider<List<Product>>((ref) async {
  return storeRepository.getProducts();
});

final servicesProvider = FutureProvider<List<ServiceModel>>((ref) async {
  return servicesRepository.getServices();
});

final mealsProvider = FutureProvider<List<MealModel>>((ref) async {
  return kitchenRepository.getMeals();
});
