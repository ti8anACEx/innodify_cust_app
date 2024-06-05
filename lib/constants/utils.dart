import 'dart:math';

import 'package:flutter/material.dart';
import 'package:innodify_cust_app/confidential/apis.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'colors.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        text,
        style: const TextStyle(color: whiteColor),
      ),
      backgroundColor: transparentColor));
}

void pushNamedNoArgs(BuildContext context, String routeName) {
  Navigator.pushNamed(context, routeName);
}

void pushNamedAndRemoveUntilNoArgs(BuildContext context, String routeName) {
  Navigator.pushNamedAndRemoveUntil(context, routeName, (route) => false);
}

// Future<List<File>> pickImages() async {
//   List<File> images = [];
//   try {
//     var files = await FilePicker.platform
//         .pickFiles(type: FileType.image, allowMultiple: true);
//
//     if (files != null && files.files.isNotEmpty) {
//       for (int i = 0; i < files.files.length; i++) {
//         images.add(File(files.files[i].path!));
//       }
//     }
//   } catch (e) {
//     debugPrint(e.toString());
//   }
//   return images;
// }

String randomIdGenerator() {
  String currentDate = DateTime.now().toString().substring(8, 10) +
      DateTime.now().toString().substring(5, 7) +
      DateTime.now().toString().substring(2, 4);
  String randomLetters = String.fromCharCodes(
      List.generate(2, (index) => Random().nextInt(26) + 97));
  String millisecondsSinceEpoch =
      DateTime.now().millisecondsSinceEpoch.toString();
  String orcaChainId = currentDate + randomLetters + millisecondsSinceEpoch;
  return orcaChainId;
}

String getWhatsappOrderLink(String phoneNumberWithout91, String message) {
  return APIs.whatsappLink1 +
      APIs.whatsappLink2 +
      phoneNumberWithout91 +
      APIs.whatsappLink4 +
      message +
      APIs.whatsappLink6;
}

Future<void> launchTheUrl(String url) async {
  final uri = Uri.parse(url);
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}

class Utils {
  static formatPrice(double price) => '\$ ${price.toStringAsFixed(2)}';
  static formatDate(DateTime date) => DateFormat.yMd().format(date);
}
