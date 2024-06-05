import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:innodify_cust_app/confidential/vendor_options.dart';
import 'package:innodify_cust_app/constants/colors.dart';
import 'package:innodify_cust_app/features/store_info/pages/store_info_page.dart';
import 'package:velocity_x/velocity_x.dart';

Widget storeBranding() {
  VendorOptionsUpdating vendorOptionsUpdating =
      Get.find(tag: 'vendor-options-updating');
  return Obx(
    () => Row(
      children: [
        Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(25),
          child: CircleAvatar(
            radius: 25,
            backgroundColor: blackColor,
            child: CircleAvatar(
              radius: 23,
              backgroundImage:
                  NetworkImage(vendorOptionsUpdating.vendorProfilePicVar.value),
              backgroundColor: whiteColor,
            ),
          ),
        ),
        10.widthBox,
        vendorOptionsUpdating.vendorStoreNameVar.value.text.bold
            .size(17)
            .make(),
      ],
    ).onTap(() {
      Get.to(() => StoreInfoPage());
    }),
  );
}
