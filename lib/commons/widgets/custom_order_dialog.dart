import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:innodify_cust_app/features/cart/controllers/cart_controller.dart';
import 'package:innodify_cust_app/features/home/controllers/item_controller.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../constants/colors.dart';
import '../../features/upload/widgets/small_text_field.dart';

void customOrderDialog(BuildContext context, ItemController itemController) {
  CartController cartController = Get.put(CartController());
  showModalBottomSheet(
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: fontGrey,
    context: context,
    builder: (context) {
      return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                itemController.itemModel!.pushedProductName.text.bold
                    .size(24)
                    .make(),
                10.heightBox,
                "Quantity".text.size(18).make(),
                5.heightBox,
                smallTextField(controller: itemController.quantityController),
                10.heightBox,
                "Extra Notes".text.size(18).make(),
                5.heightBox,
                smallTextField(
                    maxLines: 5,
                    controller: itemController.extraNoteController),
                15.heightBox,
                ElevatedButton(
                  onPressed: () {
                    cartController.addToCart(
                      itemController,
                      itemController.quantityController.text,
                      itemController.extraNoteController.text,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7)),
                      backgroundColor: blackColor),
                  child: "Order Now".text.white.make(),
                ),
                15.heightBox,
              ],
            ),
          ),
        ),
      );
    },
  );
}
