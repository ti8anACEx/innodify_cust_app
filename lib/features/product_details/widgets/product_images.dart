import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:innodify_cust_app/features/product_details/controllers/product_details_controller.dart';
import 'package:innodify_cust_app/features/product_details/widgets/single_image_view.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../home/controllers/item_controller.dart';

// ignore: must_be_immutable
class ProductImages extends StatelessWidget {
  final ItemController itemController;
  ProductImages({super.key, required this.itemController});

  ProductDetailsController productDetailsController =
      Get.find(tag: 'product-details-controller');

  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color.fromARGB(91, 148, 155, 144),
        width: context.screenWidth,
        child: Column(
          children: [
            20.heightBox,
            Obx(
              () => Material(
                elevation: 11,
                borderRadius: BorderRadius.circular(10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                      height: 300,
                      imageUrl: itemController.pushedImageLinks[
                          itemController.displayingImageIndex.value],
                      fit: BoxFit.fitHeight),
                ),
              ),
            ),
            15.heightBox,
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(itemController.pushedImageLinks.length,
                    (index) {
                  return SingleImageview(
                          index: index, itemController: itemController)
                      .onTap(() {
                    itemController.displayingImageIndex.value = index;
                  });
                }),
              ),
            ),
            15.heightBox,
          ],
        ));
  }
}
