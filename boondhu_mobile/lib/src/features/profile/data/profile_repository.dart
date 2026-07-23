import '../../../core/network/api_client.dart';
import '../domain/profile_model.dart';

class ProfileRepository {
  final ApiClient _apiClient = ApiClient();

  Future<ProfileModel?> fetchProfile() async {
    try {
      final response = await _apiClient.dio.get('/auth/profile/');
      return ProfileModel.fromJson(response.data);
    } catch (e) {
      print('Fetch profile error: $e');
      return null;
    }
  }
}

final profileRepository = ProfileRepository();
