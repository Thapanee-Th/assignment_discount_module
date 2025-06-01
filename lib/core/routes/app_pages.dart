import 'package:assignment_discount_module/feature/home/bindings/home_binding.dart';
import 'package:assignment_discount_module/feature/home/views/home_view.dart';

import 'package:get/get.dart';

import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: Routes.home, page: () => HomeView(), binding: HomeBinding()),
  ];
}
