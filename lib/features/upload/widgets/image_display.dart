import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/carousel/gf_items_carousel.dart';
import 'package:innodify_cust_app/constants/colors.dart';
import 'package:innodify_cust_app/features/upload/controllers/upload_controller.dart';
import 'package:innodify_cust_app/features/upload/widgets/single_image_selection.dart';
import 'package:velocity_x/velocity_x.dart';

// ignore: must_be_immutable
class ImageDisplay extends StatelessWidget {
  ImageDisplay({super.key});

  UploadController uploadController = Get.find(tag: 'upload-controller');

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: blackColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(91, 148, 155, 144),
              ),
              child: Column(
                children: [
                  15.heightBox,
                  "Selected ${uploadController.selectedImagesAsBytes.length.toString()}/4 images"
                      .text
                      .color(whiteColor)
                      .make(),
                  10.heightBox,
                  uploadController.selectedImagesAsBytes.isEmpty
                      ? "Please pick an image (max. 4)"
                          .text
                          .color(whiteColor)
                          .make()
                      : GFItemsCarousel(
                          rowCount: 2,
                          children: List.generate(
                              uploadController.selectedImagesAsBytes.length,
                              (index) {
                            return SingleImageSelection(index: index);
                          })),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          await uploadController.pickFiles();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: pinkColor),
                        child: "Gallery".text.make(),
                      ),
                      20.widthBox,
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            backgroundColor: pinkColor),
                        child: "Camera".text.make(),
                      ),
                    ],
                  ),
                  15.heightBox,
                ],
              )),
        ),
      ),
    );
  }
}
