import '../domain/product.dart';
import '../../../core/network/api_client.dart';

class StoreRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<Product>> getProducts() async {
    try {
      final response = await _apiClient.dio.get('/store/products/');
      final results = response.data['results'] as List;
      return results.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      // In a real app, handle exceptions and throw custom errors
      print('Error fetching products: $e');
      return [];
    }
  }
}

final storeRepository = StoreRepository();
