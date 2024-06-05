// will be changed on every vendor dedicated build, but customer may see different values, as the document will be called from DB on every login.
// But Vendor UID is probably non-changing, so here's it.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class VendorOptions extends GetxController {
  static String abidLast = vendorStoreName;

  static const String vendorId = 'VsC3yIM3nkPDi05uy35EqcVSiql2';
  static String vendorAppBundleId = 'com.innodifyVendor.$abidLast';

  static const String vendorPhoneNumber = '101';
  static const String vendorEmail = 'jit@gmail.com';
  static const String vendorUsername = 'jit';
  static const String vendorOwnerName = 'jit';
  static const String vendorProfilePic = '';
  static const String vendorStoreName = 'Risha Creations';
  static const String vendorGstin = '';
  static const String vendorOfficeAddress = '';

  static List<double> lowerRanges = [10, 27, 40, 60];
  static List<double> upperRanges = [27, 40, 60, 100];
}

class VendorOptionsUpdating extends GetxController {
  RxString vendorPhoneNumberVar = ''.obs;
  RxString vendorEmailVar = ''.obs;
  RxString vendorUsernameVar = ''.obs;
  RxString vendorOwnerNameVar = ''.obs;
  RxString vendorProfilePicVar = ''.obs;
  RxString vendorStoreNameVar = ''.obs;
  RxString vendorGstinVar = ''.obs;
  RxString vendorOfficeAddressVar = ''.obs;

  @override
  void onInit() {
    super.onInit();
    FirebaseFirestore.instance
        .collection('vendors')
        .doc(VendorOptions.vendorId)
        .snapshots()
        .listen(
      (DocumentSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.exists) {
          vendorUsernameVar.value = snapshot.data()?['username'] ?? '';
          vendorEmailVar.value = snapshot.data()?['email'] ?? '';
          vendorPhoneNumberVar.value = snapshot.data()?['phoneNumber'] ?? '';
          vendorOwnerNameVar.value = snapshot.data()?['ownerName'] ?? '';
          vendorProfilePicVar.value = snapshot.data()?['profilePic'] ?? '';
          vendorStoreNameVar.value = snapshot.data()?['storeName'] ?? '';
          vendorGstinVar.value = snapshot.data()?['gstin'] ?? '';
          vendorOfficeAddressVar.value =
              snapshot.data()?['officeAddress'] ?? '';
        } else {}
      },
    );
  }
}
