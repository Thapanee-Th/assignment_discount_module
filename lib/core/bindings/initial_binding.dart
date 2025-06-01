import 'package:assignment_discount_module/core/services/json_data_service.dart';
import 'package:get/get.dart';
import '../services/storage_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Core services
    Get.put<StorageService>(StorageService(), permanent: true);
    Get.put<JsonDataService>(JsonDataService(), permanent: true);
  }
}
