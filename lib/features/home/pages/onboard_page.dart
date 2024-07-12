import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:innodify_cust_app/commons/widgets/custom_button.dart';
import 'package:innodify_cust_app/commons/widgets/store_branding.dart';
import 'package:innodify_cust_app/confidential/vendor_options.dart';
import 'package:innodify_cust_app/constants/colors.dart';
import 'package:innodify_cust_app/features/home/controllers/home_controller.dart';
import 'package:velocity_x/velocity_x.dart';

// ignore: must_be_immutable
class OnboardPage extends StatelessWidget {
  OnboardPage({super.key});

  HomeController homeController =
      Get.put(HomeController(), tag: 'home-controller');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Obx(
            () => Badge.count(
              backgroundColor: redColor,
              count: homeController.addedCartItems.value,
              child: FloatingActionButton(
                onPressed: () {
                  homeController.openCart();
                },
                backgroundColor: blackColor,
                child: const Icon(
                  Icons.shopping_cart_outlined,
                  color: whiteColor,
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: transparentColor,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10, left: 10, right: 10, bottom: 10),
                        child: storeBranding(),
                      ),
                      // Search Bar
                    ],
                  ),
                ),
                7.heightBox,
                Obx(() => showCarouselSlider(homeController, context)),
                7.heightBox,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    "    Common Rates".text.bold.make(),
                    7.heightBox,
                    Padding(
                      padding:
                          const EdgeInsets.all(20).copyWith(top: 10, bottom: 0),
                      child: Wrap(
                        alignment: WrapAlignment.start,
                        runAlignment: WrapAlignment.start,
                        spacing: 10,
                        runSpacing: 5,
                        children: List.generate(
                          VendorOptions.lowerRanges.length,
                          (index) => CustomButton(
                              text:
                                  '${VendorOptions.lowerRanges[index].toStringAsFixed(0)}-${VendorOptions.upperRanges[index].toStringAsFixed(0)}',
                              onTap: () async {
                                await homeController.gotoHomePageWithLimits(
                                    VendorOptions.lowerRanges[index],
                                    VendorOptions.upperRanges[index]);
                              },
                              trailingWidget: const Icon(
                                Icons.arrow_forward_ios,
                                color: whiteColor,
                              ),
                              color: blackColor),
                        ),
                      ),
                    ),
                    5.heightBox,
                    Padding(
                      padding: const EdgeInsets.all(20).copyWith(top: 0),
                      child: CustomButton(
                          text: 'View All',
                          onTap: () async {
                            await homeController.gotoHomePage();
                          },
                          trailingWidget: const Icon(
                            Icons.arrow_forward_ios,
                            color: whiteColor,
                          ),
                          color: blackColor),
                    ),
                    30.heightBox,
                  ],
                ),
              ],
            ),
          )),
    );
  }

  Widget showCarouselSlider(
      HomeController homeController, BuildContext context) {
    return homeController.carouseImages.isEmpty
        ? SizedBox(
            width: context.screenWidth,
            child: Center(
                child: LinearProgressIndicator(
              color: blackColor,
              backgroundColor: transparentColor,
            )),
          )
        : Column(
            children: [
              CarouselSlider(
                items: homeController.carouseImages
                    .map(
                      (item) => Padding(
                          // !!!---MANIPULATE THE CHILD HERE---!!!
                          padding: const EdgeInsets.symmetric(horizontal: 7),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: item,
                                fit: BoxFit.cover,
                              ))),
                    )
                    .toList(),
                carouselController: homeController.carouselController,
                options: CarouselOptions(
                  scrollPhysics: const BouncingScrollPhysics(),
                  autoPlay: true,
                  viewportFraction: 1,
                  onPageChanged: (index, reason) {
                    homeController.carouselsIndex.value = index;
                  },
                ),
              ),
              const SizedBox(height: 8),
              // DOTS ROW
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:
                    homeController.carouseImages.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () => homeController.carouselController
                        .animateToPage(entry.key),
                    child: Obx(
                      () => AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        width: homeController.carouselsIndex.value == entry.key
                            ? 18
                            : 5,
                        height: 3.5,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color:
                              homeController.carouselsIndex.value == entry.key
                                  ? blackColor
                                  : fontGrey,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 22),
            ],
          );
  }
}
