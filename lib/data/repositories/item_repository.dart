import 'package:assignment_discount_module/data/models/cart_item_model.dart';
import 'package:get/get.dart';
import '../../core/services/json_data_service.dart';

class ItemRepository {
  final JsonDataService _jsonDataService = Get.find<JsonDataService>();

  Future<List<CartItemModel>> getItems() async {
    try {
      // Simulate network delay
      await _jsonDataService.simulateNetworkDelay(milliseconds: 800);

      final List<dynamic> jsonData = await _jsonDataService.loadItems();
      return jsonData.map((json) => CartItemModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error fetching users: $e');
    }
  }
}
