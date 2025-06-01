import 'package:assignment_discount_module/data/models/campaigns_model.dart';
import 'package:assignment_discount_module/data/models/cart_item_model.dart';
import 'package:assignment_discount_module/data/repositories/campaign_repository.dart';
import 'package:assignment_discount_module/data/repositories/item_repository.dart';
import 'package:assignment_discount_module/feature/home/views/widget/discount_campaigns_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/user_model.dart';

import '../../../data/repositories/user_repository.dart';

class HomeController extends GetxController {
  final UserRepository _userRepository = Get.find<UserRepository>();
  final ItemRepository _itemRepository = Get.find<ItemRepository>();
  final DiscountCampaignRepository _discountCampaignRepository =
      Get.find<DiscountCampaignRepository>();

  // Observable variables
  final Rx<UserModel> user = UserModel().obs;

  final RxList<CartItemModel> cartItems = <CartItemModel>[].obs;
  final RxList<DiscountCampaignModel> discountCampaigns =
      <DiscountCampaignModel>[].obs;
  final RxBool isLoadingUsers = false.obs;
  final RxBool isLoadingPosts = false.obs;
  final RxString errorMessage = ''.obs;
  TextEditingController promoController = TextEditingController();
  final RxList<Map<String, double>> discountCampaignsList =
      <Map<String, double>>[].obs;

  RxList<DiscountCampaignModel> selectedCampaign =
      <DiscountCampaignModel>[].obs;
  double get couponDiscount => applyDiscountCampaignCoupon();
  double get onTopDiscount => applyDiscountCampaignOnTop();
  double get seasonalDiscount => applyDiscountCampaignSeasonal();
  double get subtotal =>
      cartTotal - couponDiscount - onTopDiscount - seasonalDiscount;

  @override
  void onInit() {
    super.onInit();
    fetchItems();
    fetchDiscountCampaigns();
    fetchUsers();
  }

  double get cartTotal {
    return cartItems.fold(
      0.0,
      (sum, item) => sum + (item.price * item.quantity),
    );
  }

  Future<void> fetchItems() async {
    try {
      isLoadingUsers.value = true;
      errorMessage.value = '';

      final result = await _itemRepository.getItems();
      cartItems.assignAll(result);
      debugPrint('cartItems: ${cartItems.length}');
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', 'Failed to load items');
    } finally {
      isLoadingUsers.value = false;
    }
  }

  Future<void> fetchDiscountCampaigns() async {
    try {
      isLoadingUsers.value = true;
      errorMessage.value = '';

      final result = await _discountCampaignRepository.getDiscountCampaigns();
      discountCampaigns.assignAll(result);

      final Map<String, double> categoryMap = {
        for (var e in discountCampaigns) e.category ?? '': 0.0,
      };

      // Convert the map to a list of single-entry maps
      final listOfMaps =
          categoryMap.entries.map((e) => {e.key: e.value}).toList();

      discountCampaignsList.assignAll(listOfMaps);

      debugPrint('cartItems: ${cartItems.length}');
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', 'Failed to load items');
    } finally {
      isLoadingUsers.value = false;
    }
  }

  Future<void> fetchUsers() async {
    try {
      isLoadingUsers.value = true;
      errorMessage.value = '';

      final result = await _userRepository.getUsers();
      user.value = result[0];
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', 'Failed to load users');
    } finally {
      isLoadingUsers.value = false;
    }
  }

  void navigateToProfile(UserModel user) {
    Get.toNamed('/profile', arguments: user);
  }

  void onUserTap(UserModel user) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.name ?? 'Unknown',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Email: ${user.email ?? 'N/A'}'),
            Text('Phone: ${user.phone ?? 'N/A'}'),
            Text('Website: ${user.website ?? 'N/A'}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => navigateToProfile(user),
              child: const Text('View Profile'),
            ),
          ],
        ),
      ),
    );
  }

  void updateQuantity(int index, int change) {
    debugPrint(
      'updateQuantity: ${(cartItems[index].quantity + change).clamp(1, 99)}',
    );
    cartItems[index].quantity = (cartItems[index].quantity + change).clamp(
      1,
      99,
    );
    cartItems.refresh();
    debugPrint('Quantity: ${cartItems[index].quantity}');
  }

  void removeItem(int index) {
    cartItems.removeAt(index);
  }

  void showDiscountCampaigns(
    double height,
    List<DiscountCampaignModel> campaignList,
  ) {
    Get.bottomSheet(
      DiscountCampaignsWidget(height: height, campaignList: campaignList),
      isScrollControlled: true,
    );
  }

  String getCampaignDescription(DiscountCampaignModel campaign) {
    if (campaign.discountType == 'fixed') {
      return 'Discount ${campaign.discount} THB';
    } else if (campaign.discountType == 'percentage') {
      if (campaign.category == 'On Top') {
        String category = campaign.discountCategory!
            .map((e) => e.category)
            .join(', ');
        return 'Discount ${campaign.discount}% Off on $category';
      }
      return 'Discount ${campaign.discount}%';
    } else if (campaign.discountType == 'points') {
      return 'Points discount (cap at 20%)';
    } else if (campaign.discountType == 'seasonal') {
      return 'Discount ${campaign.discount} THB at every ${campaign.threshold} THB';
    }
    return '';
  }

  double applyDiscountCampaignCoupon() {
    final coupon =
        selectedCampaign
            .where((element) => element.category?.toLowerCase() == 'coupon')
            .firstOrNull;
    if (coupon == null) {
      return 0.0;
    }

    if (coupon.category?.toLowerCase() == 'coupon') {
      if (coupon.discountType == 'fixed') {
        //double total = cartItems.fold(0.0, (sum, item) => sum + item.price);
        return coupon.discount ?? 0;
      } else if (coupon.discountType == 'percentage') {
        return cartTotal * (coupon.discount ?? 0 * 1.0) / 100;
      }
    }

    return 0.0;
  }

  double applyDiscountCampaignOnTop() {
    final onTop =
        selectedCampaign
            .where((element) => element.category?.toLowerCase() == 'on top')
            .firstOrNull;
    if (onTop == null) {
      return 0.0;
    }

    final total = cartTotal - couponDiscount;

    if (onTop.category?.toLowerCase() == 'on top') {
      if (onTop.discountType == 'points') {
        double discount = total * 0.2;

        if (discount < (user.value.point ?? 0)) {
          return discount;
        } else {
          return (user.value.point ?? 0) * 1.0;
        }
      } else if (onTop.discountType == 'percentage') {
        final category =
            onTop.discountCategory?.map((c) => c.category).toList();
        final percentage = (onTop.discount ?? 0 * 1.0) / 100;
        final totalDiscount = cartItems
            .where((item) => category!.contains(item.category))
            .fold(0.0, (sum, item) => sum + (item.price * item.quantity));

        return totalDiscount * percentage;
      }
    }

    return 0.0;
  }

  double applyDiscountCampaignSeasonal() {
    final seasonal =
        selectedCampaign
            .where((element) => element.category?.toLowerCase() == 'seasonal')
            .firstOrNull;
    if (seasonal == null) {
      return 0.0;
    }
    final total = cartTotal - couponDiscount - onTopDiscount;

    if (seasonal.category?.toLowerCase() == 'seasonal') {
      int countEveryDiscount =
          (total / ((seasonal.threshold ?? 0) * 1.0)).floor();
      return countEveryDiscount * (seasonal.discount ?? 0);
    }
    return 0.0;
  }

  void closeBottomSheetCoupon(DiscountCampaignModel campaign) {
    selectedCampaign.add(campaign);

    //debugPrint('${campaign.name} promoDiscount: ${promoDiscount.toString()}');
    Get.back();
  }
}
