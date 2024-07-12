import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:innodify_cust_app/constants/colors.dart';

class CustomSnackbar {
  static void show(String title, String message) {
    final scaffoldMessenger = ScaffoldMessenger.maybeOf(Get.context!);
    if (scaffoldMessenger != null) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          backgroundColor: transparentColor,
          content: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: darkPinkColor),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Text(message),
                  ],
                ),
              ),
            ),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}
