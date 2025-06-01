import 'package:get/get.dart';
import '../../core/services/json_data_service.dart';
import '../models/user_model.dart';

class UserRepository {
  final JsonDataService _jsonDataService = Get.find<JsonDataService>();

  Future<List<UserModel>> getUsers() async {
    try {
      // Simulate network delay
      await _jsonDataService.simulateNetworkDelay(milliseconds: 800);

      final List<dynamic> jsonData = await _jsonDataService.loadUsers();
      return jsonData.map((json) => UserModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error fetching users: $e');
    }
  }
}
