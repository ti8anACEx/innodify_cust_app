import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:innodify_cust_app/commons/widgets/custom_order_dialog.dart';
import 'package:innodify_cust_app/constants/colors.dart';
import 'package:innodify_cust_app/features/home/controllers/item_controller.dart';
import 'package:velocity_x/velocity_x.dart';
import '../controllers/home_controller.dart';

// ignore: must_be_immutable
class ItemCard extends StatelessWidget {
  final ItemController itemController;
  ItemCard({super.key, required this.itemController});

  HomeController homeController = Get.find(tag: 'home-controller');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromARGB(91, 148, 155, 144),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: itemController.pushedImageLinks[0],
                    fit: BoxFit.fitWidth,
                  )).onTap(() {
                homeController.openProductDetails(itemController);
              }),
              5.heightBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            "Rate : ".text.bold.size(14).make(),
                            itemController.pushedRate.value.text
                                .fontWeight(FontWeight.w600)
                                .size(12)
                                .make(),
                          ],
                        ),
                        5.heightBox,
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: itemController.pushedProductName.value.text
                              .fontWeight(FontWeight.w800)
                              .size(12)
                              .make(),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.add_circle, color: blackColor).onTap(() {
                    customOrderDialog(context, itemController);
                  })
                ],
              ),
              6.heightBox,
            ],
          ),
        ),
      ),
    );
  }
}
