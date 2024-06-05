// ignore_for_file: unnecessary_null_comparison

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:innodify_cust_app/features/auth/controllers/auth_controller.dart';
import 'package:innodify_cust_app/features/cart/controllers/cart_controller.dart';
import 'package:innodify_cust_app/features/home/controllers/home_controller.dart';
import 'package:innodify_cust_app/features/home/controllers/item_controller.dart';
import '../../product_details/pages/product_details_page.dart';

class CartItemController extends GetxController {
  CartController cartController = Get.find(tag: 'cart-controller');
  DocumentSnapshot<Object?> item;
  late Map<String, dynamic>? data;

  CartItemController({required this.item}) {
    data = item.data() as Map<String, dynamic>;
  }

  void openProductDetails() {
    ItemController itemController =
        Get.find(tag: 'itemId_${data!['itemModel']['itemId']}');

    Get.to(() => ProductDetailsPage(itemController: itemController));
    // Get.back();
  }

  Future<void> deleteCartItem() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('cartItemId', isEqualTo: data!['cartItemId'])
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        // Loop through each document and delete it
        for (final doc in querySnapshot.docs) {
          await doc.reference.delete();
        }
        cartController.fetchCartItems();
        log('Documents deleted successfully!');
      } else {
        log('No documents found matching the criteria.');
      }
    } catch (e) {
      Get.snackbar('Failed', 'Failed to remove from Cart');
    }
  }
}
