import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:innodify_cust_app/confidential/vendor_options.dart';
import 'package:innodify_cust_app/features/cart/pages/cart_page.dart';
import 'package:innodify_cust_app/features/home/pages/home_page.dart';
import 'package:innodify_cust_app/features/product_details/pages/product_details_page.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../constants/colors.dart';
import '../../auth/controllers/auth_controller.dart';
import 'item_controller.dart';
import 'topic_box_controller.dart';

class HomeController extends GetxController {
  RxString currentTag = ''.obs;
  RxBool isLoading = true.obs;
  RxBool isSearching = false.obs;
  RxInt addedCartItems = 0.obs;
  RxInt carouselsIndex = 0.obs;
  RxBool isCarouselImagesLoading = false.obs;
  double min = 0, max = 150;

  final CarouselController carouselController = CarouselController();

  TextEditingController searchController = TextEditingController();
  TopicBoxController dateTopicBoxController =
      Get.put(TopicBoxController(), tag: 'date');
  TopicBoxController priceTopicBoxController =
      Get.put(TopicBoxController(), tag: 'price');

  RxList<DocumentSnapshot> searchedItems = <DocumentSnapshot>[].obs;
  RxList<DocumentSnapshot> items = <DocumentSnapshot>[].obs;
  RxList<String> carouseImages = <String>[
    "https://plus.unsplash.com/premium_photo-1714115034964-16b20994142a?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwxfHx8ZW58MHx8fHx8",
    "https://images.unsplash.com/photo-1714548529006-aea2b7530e6e?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwzfHx8ZW58MHx8fHx8",
    "https://images.unsplash.com/photo-1714508862788-44e45c4315d0?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwyfHx8ZW58MHx8fHx8",
  ].obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  AuthController authController = Get.find(tag: 'auth-controller');

  @override
  void onInit() {
    super.onInit();
    // fetchPosts(); // interchangeable with fetchItems
    numberOfCartItems();
    fetchCarouselmages();
  }

  void updateCurrentTag(String text) {
    if (currentTag.value == text) {
      currentTag.value = '';
    } else {
      currentTag.value = text;
    }
  }

  void openCart() {
    Get.to(() => CartPage());
  }

  void openProductDetails(ItemController itemController) {
    Get.to(() => ProductDetailsPage(itemController: itemController));
  }

  Future<void> fetchPosts() async {
    isLoading.value = true;
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('items')
          .where('vendorUid', isEqualTo: VendorOptions.vendorId)
          .where('isPushedToSale', isEqualTo: true)
          .get();
      items.value = querySnapshot.docs;

      isLoading.value = false;
    } catch (e) {
      Get.snackbar("Error", 'Failed to load posts');
    }
  }

  Future<void> gotoHomePageWithLimits(double lower, double higher) async {
    Get.to(() => HomePage());

    isLoading.value = true;
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('items')
          .where('vendorUid', isEqualTo: VendorOptions.vendorId)
          .where('isPushedToSale', isEqualTo: true)
          .get();
      items.clear();

      for (var doc in querySnapshot.docs) {
        String rate = doc['pushedRate'];
        double r = double.parse(rate);
        if (r >= lower && r <= higher) {
          items.add(doc);
        }
      }

      isLoading.value = false;
    } catch (e) {
      Get.snackbar("Error", 'Failed to query');
    }
  }

  Future<void> gotoHomePage() async {
    Get.to(() => HomePage());
    fetchPosts();
  }

  Future<void> searchQuery() async {
    try {
      isSearching.value = true;
      searchedItems.clear();
      QuerySnapshot querySnapshot = await firestore
          .collection('items')
          .where('pushedProductName',
              isGreaterThanOrEqualTo: searchController.text)
          .get();

      searchedItems.value = querySnapshot.docs.where((docu) {
        Map<String, dynamic> data = docu.data() as Map<String, dynamic>;
        return data.values.any((value) => value
            .toString()
            .toLowerCase()
            .contains(searchController.text.toLowerCase()));
      }).toList();
    } catch (e) {
      Get.snackbar("Error", 'Failed to load items $e');
    }
  }

  Future<void> numberOfCartItems() async {
    try {
      Future.delayed(const Duration(seconds: 3)).then((value) async {
        QuerySnapshot querySnapshot = await firestore
            .collection('orders')
            .where('orderedFromUid', isEqualTo: VendorOptions.vendorId)
            .where('orderedByUid',
                isEqualTo: authController.currentUserUID.value)
            .get();
        addedCartItems.value = querySnapshot.docs.length;
      });
    } catch (e) {
      Get.snackbar("Error", 'Failed to load cart items');
    }
  }

  Future<void> fetchCarouselmages() async {
    RxList<DocumentSnapshot> items = <DocumentSnapshot>[].obs;

    try {
      Future.delayed(const Duration(seconds: 3)).then((value) async {
        QuerySnapshot querySnapshot = await firestore
            .collection('vendors')
            .where('uid', isEqualTo: VendorOptions.vendorId)
            .get();
        items.value = querySnapshot.docs;
        addedCartItems.value = items.length;

        for (var doc in querySnapshot.docs) {
          String cimages = doc['carouselImages'];
          carouseImages.add(cimages);
        }
      });
    } catch (e) {
      Get.snackbar("Error", 'Failed to load Carousles');
    }
  }

  void showTheFilter(String filterName, BuildContext context) {
    switch (filterName) {
      case 'Rate':
        showPriceFilter(context);
        break;
      case 'Date':
        showDateFilter(context);
        break;
      case 'A-Z':
        showAtoZFilter(context);
        break;
      default:
    }
  }

  Future<void> filteredSearchQuery({
    String collection = 'items',
    double minRate = 0,
    double maxRate = 150,
    String orderBy = '',
    bool oldestFirst = false,
    bool newestFirst = false,
    bool pushedToSaleItems = false,
    bool notPushedToSaleItems = false,
    bool aToZOrder = false,
    bool zToAOrder = false,
  }) async {
    try {
      isSearching.value = true;
      searchedItems.clear();
      if (orderBy == 'default') {
        isSearching.value = false;
        return;
      }
      Query query = firestore.collection(collection);

      // Fetch all documents without initial filtering
      QuerySnapshot querySnapshot = await query
          .where('vendorUid', isEqualTo: authController.currentUserUID.value)
          .get();

      // Convert QuerySnapshot to List<DocumentSnapshot>
      List<DocumentSnapshot> allDocuments = querySnapshot.docs;

      // Apply filtering logic on the client-side
      List<DocumentSnapshot> filteredDocuments = allDocuments.where((doc) {
        // Filter based on rate
        double rate = double.parse(doc['draftRate']);
        if (rate < minRate || rate > maxRate) {
          return false;
        }

        // Filter based on pushed/not pushed to sale items
        bool isPushedToSale = doc['isPushedToSale'] ?? false;
        if (pushedToSaleItems && !isPushedToSale) {
          return false;
        }
        if (notPushedToSaleItems && isPushedToSale) {
          return false;
        }

        // Add other filters as needed

        return true; // Document passes all filters
      }).toList();

      // Apply sorting logic on the client-side
      if (oldestFirst) {
        filteredDocuments.sort((a, b) => (a['datePublished'] as Timestamp)
            .compareTo(b['datePublished'] as Timestamp));
      } else if (newestFirst) {
        filteredDocuments.sort((a, b) => (b['datePublished'] as Timestamp)
            .compareTo(a['datePublished'] as Timestamp));
      } else if (aToZOrder) {
        filteredDocuments.sort((a, b) => (a['draftProductName'] as String)
            .compareTo(b['draftProductName'] as String));
      } else if (zToAOrder) {
        filteredDocuments.sort((a, b) => (b['draftProductName'] as String)
            .compareTo(a['draftProductName'] as String));
      }

      // Update searchedItems with the filtered and sorted documents
      searchedItems.value = filteredDocuments;
    } catch (e) {
      Get.snackbar("Error", 'Failed to load items $e');
    }
  }

  void showPriceFilter(BuildContext context) {
    Rx<RangeValues> values = Rx<RangeValues>(RangeValues(min, max));
    Rx<RangeLabels> labels = Rx<RangeLabels>(RangeLabels(
        values.value.start.toString(), values.value.end.toString()));
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            "Rate".text.make(),
            20.heightBox,
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(10, (index) {
                    double val = (min + (max / 10)) * (index + 1);
                    return Text(
                      val.toStringAsFixed(0),
                      style: const TextStyle(fontSize: 9),
                    );
                  }),
                ),
                Obx(
                  () => RangeSlider(
                    labels: labels.value,
                    divisions: 10,
                    min: min,
                    activeColor: pinkColor,
                    inactiveColor: textfieldGrey.withOpacity(0.3),
                    max: max,
                    values: values.value,
                    onChanged: (newValue) {
                      values.value = newValue;
                    },
                  ),
                ),
              ],
            ),
            20.heightBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    filteredSearchQuery(orderBy: 'default');
                    Get.back(); // Close the filter modal
                  },
                  child: "Default".text.make(),
                ),
                20.widthBox,
                ElevatedButton(
                  onPressed: () {
                    filteredSearchQuery(
                        minRate: values.value.start, maxRate: values.value.end);
                    Get.back(); // Close the filter modal
                  },
                  child: "OK".text.make(),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void showDateFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          color: whiteColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    filteredSearchQuery(oldestFirst: true);
                    Get.back(); // Close the filter modal
                  },
                  child: "Oldest First".text.make(),
                ),
                10.heightBox,
                ElevatedButton(
                  onPressed: () {
                    filteredSearchQuery(newestFirst: true);
                    Get.back(); // Close the filter modal
                  },
                  child: "Newest First".text.make(),
                ),
                10.heightBox,
                ElevatedButton(
                  onPressed: () {
                    filteredSearchQuery(orderBy: 'default');
                    Get.back(); // Close the filter modal
                  },
                  child: "Default".text.make(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showAtoZFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          color: whiteColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    filteredSearchQuery(aToZOrder: true);
                    Get.back(); // Close the filter modal
                  },
                  child: "Order by A-Z".text.make(),
                ),
                10.heightBox,
                ElevatedButton(
                  onPressed: () {
                    filteredSearchQuery(zToAOrder: true);
                    Get.back(); // Close the filter modal
                  },
                  child: "Order by Z-A".text.make(),
                ),
                10.heightBox,
                ElevatedButton(
                  onPressed: () {
                    filteredSearchQuery(orderBy: 'default');
                    Get.back(); // Close the filter modal
                  },
                  child: "Default".text.make(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
