import 'package:assignment_discount_module/data/models/campaigns_model.dart';
import 'package:get/get.dart';
import '../../core/services/json_data_service.dart';

class DiscountCampaignRepository {
  final JsonDataService _jsonDataService = Get.find<JsonDataService>();

  Future<List<DiscountCampaignModel>> getDiscountCampaigns() async {
    try {
      // Simulate network delay
      await _jsonDataService.simulateNetworkDelay(milliseconds: 800);

      final List<dynamic> jsonData =
          await _jsonDataService.loadDiscountCampaigns();
      return jsonData
          .map((json) => DiscountCampaignModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Error fetching users: $e');
    }
  }
}
