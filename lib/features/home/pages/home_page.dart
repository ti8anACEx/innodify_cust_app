import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:innodify_cust_app/commons/widgets/custom_search_bar.dart';
import 'package:innodify_cust_app/commons/widgets/store_branding.dart';
import 'package:innodify_cust_app/constants/colors.dart';
import 'package:innodify_cust_app/features/home/controllers/home_controller.dart';
import 'package:innodify_cust_app/features/home/widgets/item_card.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../commons/widgets/custom_progress_indicator.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/item_controller.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  HomePage({super.key});

  HomeController homeController =
      Get.put(HomeController(), tag: 'home-controller');
  AuthController authController = Get.find(tag: 'auth-controller');

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
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: textfieldGrey.withOpacity(0.8),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
                width: context.screenWidth,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10, left: 10, right: 10, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          storeBranding(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              'T&C '.text.make(),
                              const Icon(Icons.arrow_outward, size: 15),
                            ],
                          ).onTap(() {
                            authController.showTermsAndConditions(context,
                                showLogout: true);
                          }),
                        ],
                      ),
                    ),
                    // Search Bar
                    Padding(
                      padding: const EdgeInsets.all(8.0)
                          .copyWith(left: 12, right: 15),
                      child: customSearchBar(),
                    ),
                    // SingleChildScrollView(
                    //   scrollDirection: Axis.horizontal,
                    //   child: Row(
                    //     children: List.generate(customTags.length, (index) {
                    //       return TopicBox(
                    //         text: customTags[index]['title'],
                    //       );
                    //     }),
                    //   ),
                    // ),
                  ],
                ),
              ).box.roundedSM.make(),
              7.heightBox,
              Obx(
                () => Expanded(
                  child: homeController.isSearching.value
                      ? MasonryGridView.builder(
                          itemCount: homeController.searchedItems.length,
                          physics: const BouncingScrollPhysics(),
                          gridDelegate:
                              const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2),
                          itemBuilder: (context, index) {
                            DocumentSnapshot<Object?> searchedItem =
                                homeController.searchedItems[index];

                            final ItemController itemController = Get.put(
                                ItemController(
                                  item: searchedItem,
                                ),
                                tag:
                                    'searchedItemId_${searchedItem['itemId']}');

                            return ItemCard(
                              itemController: itemController,
                            );
                          },
                        )
                      : homeController.isLoading.value
                          ? customProgressIndicator()
                          : MasonryGridView.builder(
                              itemCount: homeController.items.length,
                              physics: const BouncingScrollPhysics(),
                              gridDelegate:
                                  const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2),
                              itemBuilder: (context, index) {
                                DocumentSnapshot<Object?> item =
                                    homeController.items[index];

                                final ItemController itemController = Get.put(
                                    ItemController(
                                      item: item,
                                    ),
                                    tag: 'itemId_${item['itemId']}');

                                return ItemCard(
                                  itemController: itemController,
                                );
                              },
                            ),
                ),
              ),
            ],
          )),
    );
  }
}
