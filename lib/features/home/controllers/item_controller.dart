import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../models/item_model.dart';
import 'home_controller.dart';

class ItemController extends GetxController {
  TextEditingController quantityController = TextEditingController();
  TextEditingController extraNoteController = TextEditingController();

  ItemModel? itemModel;
  HomeController homeController = Get.find(tag: 'home-controller');

  RxBool isLoading = true.obs;
  RxBool isPushedToSale = false.obs;

  RxString pushedRate = ''.obs;
  RxString pushedDate = ''.obs;
  RxString pushedProductName = ''.obs;
  RxString pushedDescription = ''.obs;

  RxList<String> pushedImageLinks = <String>[].obs;

  RxInt displayingImageIndex = 0.obs;
  DocumentSnapshot<Object?> item;
  Map<String, dynamic>? data;

  ItemController({required this.item}) {
    itemModel = ItemModel.fromSnap(item);

    isPushedToSale.value = itemModel!.isPushedToSale;
    pushedRate.value = itemModel!.pushedRate;
    pushedDate.value = itemModel!.pushedDate;
    pushedProductName.value = itemModel!.pushedProductName;
    pushedDescription.value = itemModel!.pushedDescription;
    pushedImageLinks.value = itemModel!.pushedImageLinks;

    data = item.data() as Map<String, dynamic>;
  }
}
