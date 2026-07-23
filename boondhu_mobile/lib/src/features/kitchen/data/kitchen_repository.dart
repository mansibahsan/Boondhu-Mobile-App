import '../domain/meal_model.dart';
import '../../../core/network/api_client.dart';

class KitchenRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<MealModel>> getMeals() async {
    try {
      final response = await _apiClient.dio.get('/kitchen/meals/');
      final results = response.data['results'] as List;
      return results.map((json) => MealModel.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching meals: $e');
      return [];
    }
  }
}

final kitchenRepository = KitchenRepository();
