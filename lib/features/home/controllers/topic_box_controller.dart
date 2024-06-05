import 'package:get/get.dart';

//        same as { newer, older, normal } for dates
enum CurrentSort { lower, higher, normal }

class TopicBoxController extends GetxController {
  Rx<CurrentSort> currentSort = Rx<CurrentSort>(CurrentSort.normal);

  void toggleSort() {
    if (currentSort.value == CurrentSort.normal) {
      currentSort.value = CurrentSort.lower;
    } else if (currentSort.value == CurrentSort.lower) {
      currentSort.value = CurrentSort.higher;
    } else if (currentSort.value == CurrentSort.higher) {
      currentSort.value = CurrentSort.normal;
    }
  }
}
