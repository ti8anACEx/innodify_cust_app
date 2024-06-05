import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:innodify_cust_app/confidential/apis.dart';
import 'package:innodify_cust_app/confidential/vendor_options.dart';
import 'package:innodify_cust_app/constants/colors.dart';
import 'package:innodify_cust_app/constants/utils.dart';
import 'package:velocity_x/velocity_x.dart';

// ignore: must_be_immutable
class StoreInfoPage extends StatelessWidget {
  StoreInfoPage({super.key});

  VendorOptionsUpdating vendorOptionsUpdating =
      Get.find(tag: 'vendor-options-updating');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: context.screenWidth,
            color: fontGrey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: const Icon(Icons.arrow_back_ios).onTap(() {
                        Get.back();
                      })),
                  CircleAvatar(
                    radius: 65,
                    backgroundColor: blackColor,
                    child: CircleAvatar(
                      radius: 63,
                      backgroundColor: royalWhiteColor,
                      backgroundImage: NetworkImage(
                          vendorOptionsUpdating.vendorProfilePicVar.value),
                    ),
                  ),
                  10.widthBox,
                  vendorOptionsUpdating.vendorStoreNameVar.value.text.bold
                      .size(20)
                      .make(),
                ],
              ),
            ),
          ),
          20.heightBox,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                "Owner Name".text.bold.size(18).make(),
                1.heightBox,
                vendorOptionsUpdating.vendorOwnerNameVar.value.text
                    .size(17)
                    .make(),
                7.heightBox,
                "GSTIN".text.bold.size(18).make(),
                1.heightBox,
                vendorOptionsUpdating.vendorGstinVar.value.text.size(17).make(),
                7.heightBox,
                "Contact Number".text.bold.size(18).make(),
                1.heightBox,
                vendorOptionsUpdating.vendorPhoneNumberVar.value.text
                    .size(17)
                    .make(),
                7.heightBox,
                "Email Address".text.bold.size(18).make(),
                1.heightBox,
                vendorOptionsUpdating.vendorEmailVar.value.text.size(17).make(),
                7.heightBox,
                "Office Address".text.bold.size(18).make(),
                1.heightBox,
                vendorOptionsUpdating.vendorOfficeAddressVar.value.text
                    .size(17)
                    .make(),
                7.heightBox,
              ],
            ),
          ),
          15.heightBox,
          Center(
            child: ElevatedButton(
              onPressed: () {
                // ignore: prefer_interpolation_to_compose_strings
                String url = APIs.whatsappLink1 +
                    APIs.whatsappLink2 +
                    vendorOptionsUpdating.vendorPhoneNumberVar.value
                        .toString() +
                    APIs.whatsappLink4 +
                    'Hello' +
                    APIs.whatsappLink6;
                launchTheUrl(url);
              },
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7)),
                  backgroundColor: blackColor),
              child: "Contact Us".text.white.make(),
            ),
          ),
        ],
      )),
    );
  }
}
