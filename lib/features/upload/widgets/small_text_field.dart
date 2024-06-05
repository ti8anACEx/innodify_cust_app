import 'package:flutter/material.dart';
import 'package:innodify_cust_app/constants/colors.dart';

Widget smallTextField(
    {TextInputType? textInputType = TextInputType.text,
    String? hint = '',
    int? maxLength,
    int? maxLines = 1,
    String labelText = '',
    required TextEditingController controller}) {
  return TextField(
    maxLines: maxLines,
    controller: controller,
    decoration: InputDecoration(
      labelText: labelText,
      labelStyle: const TextStyle(fontWeight: FontWeight.w300),
      contentPadding: const EdgeInsets.all(10.0),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black, width: 2.0),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: pinkColor, width: 2.0),
        borderRadius: BorderRadius.circular(10),
      ),
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.black),
    ),
    textAlign: TextAlign.start,
    maxLength: maxLength,
    keyboardType: textInputType,
    onChanged: (value) {
      // Handle onChanged event if needed
    },
  );
}
