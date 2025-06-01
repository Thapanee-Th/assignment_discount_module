import 'package:assignment_discount_module/data/models/cart_item_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your cart'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Obx(() {
              return Text('${controller.user.value.point.toString()} Points');
            }),
          ),
        ],
      ),
      body: Obx(() {
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: controller.cartItems.length,
                itemBuilder: (context, index) {
                  return _buildCartItem(controller.cartItems[index], index);
                },
              ),
            ),
            //_buildPromoSection(context),
            _buildPricingBreakdown(context),
            _buildCheckoutButton(),
          ],
        );
      }),
    );
  }

  Widget _buildCartItem(CartItemModel item, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Quantity controls
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => controller.updateQuantity(index, 1),
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: Icon(Icons.add, color: Colors.grey.shade600),
                  ),
                ),
                SizedBox(
                  width: 30,
                  height: 30,
                  child: Center(
                    child: Text(
                      '${item.quantity}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => controller.updateQuantity(index, -1),
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: Icon(Icons.remove, color: Colors.grey.shade600),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 16),

          // Food image
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: Image.asset(item.imageUrl),
          ),
          SizedBox(width: 16),

          // Item details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 4),
                Text(
                  '${item.price.toStringAsFixed(2)} THB',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Remove button
          GestureDetector(
            onTap: () => controller.removeItem(index),
            child: Container(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.close, color: Colors.grey.shade600, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildPromoSection(context) {
  //   return GestureDetector(
  //     onTap: () {
  //       controller.showDiscountCampaigns(
  //         MediaQuery.of(context).size.height * 0.7,
  //         controller.discountCampaigns,
  //       );
  //     },
  //     child: Container(
  //       margin: EdgeInsets.symmetric(horizontal: 16),
  //       padding: EdgeInsets.all(16),
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(12),
  //       ),
  //       child: Row(
  //         children: [
  //           IconButton(icon: Icon(Icons.confirmation_number), onPressed: () {}),
  //           Expanded(
  //             child: Text(
  //               controller.selectedCampaign.value != null
  //                   ? controller.selectedCampaign.value!.name ?? ''
  //                   : 'select Promo Code',
  //               style: TextStyle(color: Colors.grey.shade500),
  //             ),
  //           ),
  //           IconButton(
  //             icon: Icon(Icons.chevron_right),
  //             onPressed: () {
  //               // print('Icon button tapped!');
  //             },
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildPricingBreakdown(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildPriceRow('Total', controller.cartTotal),
          SizedBox(height: 12),
          ...controller.discountCampaignsList.map((item) {
            double discount = 0.0;
            if (item.keys.first.toLowerCase() == 'coupon') {
              discount = controller.couponDiscount;
            } else if (item.keys.first.toLowerCase() == 'on top') {
              discount = controller.onTopDiscount;
            } else if (item.keys.first.toLowerCase() == 'seasonal') {
              discount = controller.seasonalDiscount;
            }

            return _buildDiscountRow(
              item.keys.first,
              -discount,
              isDiscount: true,
              context: context,
            );
          }),

          SizedBox(height: 16),
          Divider(color: Colors.grey.shade300),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subtotal',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
              Text(
                '${controller.subtotal.toStringAsFixed(2)} THB',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(
    String label,
    double amount, {
    bool isDiscount = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
        ),
        Text(
          '${isDiscount && amount > 0 ? '-' : ''}${amount.toStringAsFixed(2)} THB',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildDiscountRow(
    String label,
    double amount, {
    bool isDiscount = false,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: () {
        final campaignList =
            controller.discountCampaigns
                .where((element) => element.category == label)
                .toList();
        controller.showDiscountCampaigns(
          MediaQuery.of(context).size.height * 0.7,
          campaignList,
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
            ),
            Row(
              children: [
                Text(
                  '${isDiscount && amount > 0 ? '-' : ''}${amount.toStringAsFixed(2)} THB',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Icon(Icons.chevron_right),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckoutButton() {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          // backgroundColor: Colors.blue,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'Proceed to Checkout',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
