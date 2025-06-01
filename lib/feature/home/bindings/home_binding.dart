import 'package:assignment_discount_module/data/repositories/campaign_repository.dart';
import 'package:assignment_discount_module/data/repositories/item_repository.dart';
import 'package:get/get.dart';

import '../../../data/repositories/user_repository.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserRepository>(() => UserRepository());
    Get.lazyPut<ItemRepository>(() => ItemRepository());
    Get.lazyPut<DiscountCampaignRepository>(() => DiscountCampaignRepository());

    Get.lazyPut<HomeController>(() => HomeController());
  }
}
