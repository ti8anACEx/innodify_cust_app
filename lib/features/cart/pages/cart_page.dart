import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:innodify_cust_app/commons/widgets/custom_progress_indicator.dart';
import 'package:innodify_cust_app/commons/widgets/custom_transaport_dialog.dart';
import 'package:innodify_cust_app/constants/colors.dart';
import 'package:innodify_cust_app/features/cart/controllers/cart_controller.dart';
import 'package:innodify_cust_app/features/cart/controllers/cart_item_controller.dart';
import 'package:innodify_cust_app/features/cart/widgets/cart_item.dart';
import 'package:velocity_x/velocity_x.dart';

// ignore: must_be_immutable
class CartPage extends StatelessWidget {
  CartPage({super.key});

  CartController cartController =
      Get.put(CartController(), tag: 'cart-controller');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: "Cart".text.bold.make(),
            centerTitle: true,
            leading: const Icon(
              Icons.arrow_back_ios,
              color: blackColor,
            ).onTap(() {
              Get.back();
            }),
          ),
          body: Obx(
            () => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    "Items Added".text.bold.make(),
                    5.heightBox,
                    cartController.isLoading.value
                        ? customProgressIndicator()
                        : Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: fontGrey),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 7),
                              child: Column(
                                children: List.generate(
                                    cartController.cartItems.length, (index) {
                                  DocumentSnapshot<Object?> cartItem =
                                      cartController.cartItems[index];

                                  final CartItemController cartItemController =
                                      Get.put(
                                          CartItemController(item: cartItem),
                                          tag:
                                              'cartItemId_${cartItem['cartItemId']}');

                                  return CartItem(
                                    cartItemController: cartItemController,
                                  );
                                }),
                              ),
                            ),
                          ),
                    25.heightBox,
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          customTransportDialog(context);
                        },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7)),
                            backgroundColor: blackColor),
                        child: "Create Order".text.white.make(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
