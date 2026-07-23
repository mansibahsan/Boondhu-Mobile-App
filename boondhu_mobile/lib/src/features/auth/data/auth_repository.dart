import '../../../core/network/api_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepository {
  final ApiClient _apiClient = ApiClient();
  final _storage = const FlutterSecureStorage();

  Future<bool> login(String phone, String password) async {
    try {
      final response = await _apiClient.dio.post('/auth/login/', data: {
        'phone': phone,
        'password': password,
      });
      
      final accessToken = response.data['access'];
      final refreshToken = response.data['refresh'];
      
      await _storage.write(key: 'access_token', value: accessToken);
      await _storage.write(key: 'refresh_token', value: refreshToken);
      return true;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<bool> register(String name, String email, String phone, String password) async {
    try {
      await _apiClient.dio.post('/auth/register/', data: {
        'first_name': name,
        'email': email,
        'phone': phone,
        'password': password,
        'password_confirm': password,
      });
      
      // Auto-login after successful registration
      return await login(phone, password);
    } catch (e) {
      print('Register error: $e');
      return false;
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
  }
}

final authRepository = AuthRepository();
