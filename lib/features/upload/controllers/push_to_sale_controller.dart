import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../commons/widgets/custom_snackbar.dart';

class PushToSaleController extends GetxController {
  TextEditingController rateController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController productNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  RxList<Uint8List> selectedImagesAsBytes = <Uint8List>[].obs;

  Future<void> pickFiles() async {
    try {
      var files = await FilePicker.platform.pickFiles(
          type: FileType.image, allowMultiple: true, allowCompression: true);
      selectedImagesAsBytes.clear();

      if (files != null && files.files.length > 4) {
        VxToast.show(Get.context!,
            msg:
                "Maximum 4 images allowed"); // restricting number of images to 4
      }

      if (!kIsWeb) {
        if (files != null && files.files.isNotEmpty) {
          for (int i = 0; i < files.files.length; i++) {
            selectedImagesAsBytes
                .add(await File(files.files[i].path!).readAsBytes());
          }
        }
      } else if (files != null && files.files.isNotEmpty) {
        for (int i = 0; i < files.files.length; i++) {
          selectedImagesAsBytes.add(files.files[i].bytes!);
        }
      }
    } catch (e) {
      CustomSnackbar.show("Error", e.toString());
    }
  }

  Future<void> pushToSale() async {}
}
