import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../home/controllers/item_controller.dart';

// ignore: must_be_immutable
class SingleImageview extends StatelessWidget {
  final int index;
  final ItemController itemController;
  const SingleImageview({
    super.key,
    required this.index,
    required this.itemController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 11,
        borderRadius: BorderRadius.circular(10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            width: 80,
            height: 80,
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: itemController.pushedImageLinks[index],
            ),
          ),
        ),
      ),
    );
  }
}
