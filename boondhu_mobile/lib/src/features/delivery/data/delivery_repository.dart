import '../../../core/network/api_client.dart';

class DeliveryRepository {
  final ApiClient _apiClient = ApiClient();

  Future<bool> createDeliveryRequest(Map<String, dynamic> deliveryData) async {
    try {
      final response = await _apiClient.dio.post('/delivery/requests/', data: deliveryData);
      return response.statusCode == 201;
    } catch (e) {
      print('Error creating delivery request: $e');
      return false;
    }
  }

  Future<List<dynamic>> getDeliveryHistory() async {
    try {
      final response = await _apiClient.dio.get('/delivery/requests/');
      return response.data['results'] as List;
    } catch (e) {
      print('Error fetching delivery history: $e');
      return [];
    }
  }
}

final deliveryRepository = DeliveryRepository();
