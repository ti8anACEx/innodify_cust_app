import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:innodify_cust_app/commons/widgets/custom_order_dialog.dart';
import 'package:innodify_cust_app/confidential/vendor_options.dart';
import 'package:innodify_cust_app/constants/colors.dart';
import 'package:innodify_cust_app/features/product_details/controllers/product_details_controller.dart';
import 'package:innodify_cust_app/features/product_details/widgets/product_images.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../confidential/apis.dart';
import '../../../constants/utils.dart';
import '../../home/controllers/item_controller.dart';

// ignore: must_be_immutable
class ProductDetailsPage extends StatelessWidget {
  final ItemController itemController;

  ProductDetailsPage({super.key, required this.itemController});

  ProductDetailsController productDetailsController =
      Get.put(ProductDetailsController(), tag: 'product-details-controller');
  VendorOptionsUpdating vendorOptionsUpdating =
      Get.find(tag: 'vendor-options-updating');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: "Product Details".text.black.make(),
          centerTitle: true,
          shadowColor: transparentColor,
          backgroundColor: transparentColor,
          leading: const Icon(
            Icons.arrow_back_ios,
            color: blackColor,
          ).onTap(() {
            Get.back();
          }),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ProductImages(itemController: itemController),
              15.heightBox,
              itemController.pushedProductName.value.text.bold.size(22).make(),
              20.heightBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  "Rate : ".text.bold.size(16).make(),
                  itemController.pushedRate.value.text.size(16).make(),
                  35.widthBox,
                  "Date : ".text.bold.size(16).make(),
                  itemController.pushedDate.value.text.size(16).make(),
                ],
              ),
              15.heightBox,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    "Description : ".text.bold.make(),
                    itemController.pushedDescription.value.text.make(),
                  ],
                ),
              ),
              20.heightBox,
              Wrap(
                spacing: 12,
                runSpacing: 12,
                runAlignment: WrapAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      customOrderDialog(context, itemController);
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: blackColor),
                    child: "Add to Cart".text.white.make(),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // ignore: prefer_interpolation_to_compose_strings
                      String url = APIs.whatsappLink1 +
                          APIs.whatsappLink2 +
                          vendorOptionsUpdating.vendorPhoneNumberVar.value
                              .toString() +
                          APIs.whatsappLink4 +
                          'Hello, I need help regarding this item - ' +
                          itemController.pushedProductName.value +
                          ', Desc: ' +
                          itemController.pushedDescription.value +
                          ', Rate: ' +
                          itemController.pushedRate.value +
                          APIs.whatsappLink6;
                      launchTheUrl(url);
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: blackColor),
                    child: "Help".text.white.make(),
                  ),
                ],
              ),
              20.heightBox,
            ],
          ),
        ));
  }
}
