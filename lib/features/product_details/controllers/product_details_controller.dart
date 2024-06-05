import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:innodify_cust_app/features/upload/pages/push_to_sale_page.dart';

class ProductDetailsController extends GetxController {
  RxList<DocumentSnapshot> images = <DocumentSnapshot>[].obs;

  void pushToSaleNow() {
    Get.to(() => PushToSalePage());
  }
}
