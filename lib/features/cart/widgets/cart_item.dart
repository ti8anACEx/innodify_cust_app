import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:innodify_cust_app/constants/colors.dart';
import 'package:velocity_x/velocity_x.dart';

import '../controllers/cart_item_controller.dart';

// ignore: must_be_immutable
class CartItem extends StatelessWidget {
  final CartItemController cartItemController;
  const CartItem({super.key, required this.cartItemController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          const Icon(Icons.cancel, color: blackColor).onTap(() {
            cartItemController.deleteCartItem();
          }),
          4.widthBox,
          ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 80,
                height: 80,
                child: Image.network(
                  cartItemController.data!['itemModel']['pushedImageLinks'][0]
                      .toString(),
                  fit: BoxFit.cover,
                ),
              )),
          7.widthBox,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                cartItemController.data!['itemModel']['pushedProductName']
                    .toString()
                    .text
                    .bold
                    .make(),
                2.heightBox,
                Row(
                  children: [
                    "Quantity : ".text.semiBold.make(),
                    cartItemController.data!['quantity'].toString().text.make(),
                  ],
                ),
                2.heightBox,
                Row(
                  children: [
                    "Rate : ".text.semiBold.make(),
                    cartItemController.data!['itemModel']['pushedRate']
                        .toString()
                        .text
                        .make(),
                  ],
                ),
                2.heightBox,
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    "Note : ".text.semiBold.make(),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          cartItemController.data!['extraNotes'],
                          style:
                              const TextStyle(overflow: TextOverflow.ellipsis),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ).onTap(() {
        cartItemController.openProductDetails();
      }),
    );
  }
}
