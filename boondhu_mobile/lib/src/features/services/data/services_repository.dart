import '../domain/service_model.dart';
import '../../../core/network/api_client.dart';

class ServicesRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<ServiceModel>> getServices() async {
    try {
      final response = await _apiClient.dio.get('/services/items/');
      final results = response.data['results'] as List;
      return results.map((json) => ServiceModel.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching services: $e');
      return [];
    }
  }
}

final servicesRepository = ServicesRepository();
