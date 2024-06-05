import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:innodify_cust_app/confidential/vendor_options.dart';
import 'package:innodify_cust_app/features/auth/controllers/auth_controller.dart';
import 'package:innodify_cust_app/features/home/controllers/item_controller.dart';
import 'package:innodify_cust_app/models/cart_item_model.dart';
import 'package:innodify_cust_app/models/invoice_model.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:uuid/uuid.dart';
import '../../../constants/utils.dart';
import '../../../pdf_services/sync_pdf.dart';

class CartController extends GetxController {
  AuthController authController = Get.find(tag: 'auth-controller');
  VendorOptionsUpdating vendorOptionsUpdating =
      Get.find(tag: 'vendor-options-updating');

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  RxList<DocumentSnapshot> cartItems = <DocumentSnapshot>[].obs;
  List<InvoiceItem> itemsForPdf = <InvoiceItem>[];
  TextEditingController addressAndTransportationController =
      TextEditingController();

  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    isLoading.value = true;
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('orders')
          .where('orderedFromUid', isEqualTo: VendorOptions.vendorId)
          .where('orderedByUid', isEqualTo: authController.currentUserUID.value)
          .get();
      cartItems.value = querySnapshot.docs;

      isLoading.value = false;
    } catch (e) {
      Get.snackbar("Error", 'Failed to load cart items');
    }
  }

  Future<void> addToCart(
      ItemController itemController, String quantity, String extraNotes) async {
    try {
      if (quantity.isNotEmpty) {
        final cartItemId = const Uuid().v1();

        CartItemModel cartItemModel = CartItemModel(
          orderedFromUid: VendorOptions.vendorId,
          orderedByUid: authController.currentUserUID.value,
          itemModel: itemController.itemModel!,
          cartItemId: cartItemId,
          datePublished: DateTime.now(),
          orderedBy: authController.currentUsername.value,
          orderedFrom: vendorOptionsUpdating.vendorStoreNameVar.value,
          quantity: quantity,
          extraNotes: extraNotes,
        );

        await firestore
            .collection('orders')
            .doc(cartItemId)
            .set(cartItemModel.toJson());
        Get.snackbar(
            "Added item to cart", "You can now order the item from the Cart");
      } else {
        Get.snackbar("Failed", "Failed to add item to the cart");
      }
    } catch (e) {
      Get.snackbar("Error", "Error occured while adding item to the cart");
    }
  }

  Future<void> generateReceiptAndOrderNow() async {
    if (cartItems.isEmpty) {
      Get.snackbar("Failed", 'Your Cart is empty!');
      return;
    }
    itemsForPdf.clear();
    final String invoiceId = const Uuid().v1();
    final now = DateFormat.yMMMEd().format(DateTime.now());

    for (int i = 0; i < cartItems.length; i++) {
      var zz = cartItems[i].data() as Map<String, dynamic>;
      getSingleItemInfo(zz);
    }

    PdfDocument doc = PdfDocument();
    final page = doc.pages.add();

    SyncPdf().drawInfo(invoiceId, addressAndTransportationController.text, page,
        authController, vendorOptionsUpdating, itemsForPdf);
    SyncPdf().drawGrid(page, itemsForPdf);
    // SyncPdf().drawSignature(page, itemsForPdf);

    List<int> bytes = await doc.save();
    doc.dispose();
    String dwnldUrl =
        await SyncPdf().saveAndLaunchFile(bytes, 'invoice_$now.pdf', invoiceId);
    String downloadUrl = SyncPdf().convertUrl(dwnldUrl);

    String msg = '''
Got an Order Receipt.
Download the Receipt PDF here:
$downloadUrl
''';

    downloadUrl == "web-contdition-unhandled" || downloadUrl == "error"
        ? Get.snackbar(
            'Attention', 'Failed to redirect to Chat, or the platorm is web')
        : launchTheUrl(getWhatsappOrderLink(
            vendorOptionsUpdating.vendorPhoneNumberVar.value, msg));
  }

  void getSingleItemInfo(Map<String, dynamic> itemData) {
    // another itemId is there ['itemModel']['itemId']
    String cartItemId = itemData['cartItemId'];
    String extraNotes = itemData['extraNotes'];
    String pushedProductName = itemData['itemModel']['pushedProductName'];
    String draftProductName = itemData['itemModel']['draftProductName'];
    String quantity = itemData['quantity'];

    String pushedRate = itemData['itemModel']['pushedRate'];

    InvoiceItem anItem = InvoiceItem(
      extraNotes: extraNotes,
      quantity: quantity,
      unitPrice: pushedRate,
      productName: pushedProductName,
      productId: cartItemId,
      draftProductName: draftProductName,
    );
    itemsForPdf.add(anItem);
  }
}

  /// THE LAST 3 FUNCTIONS ARE NOT USED IN UPCOMING VERSIONS,
  /// Now they are not in use so are outside this class.

/*
  void generateReceiptAndOrderNowButInAString() {
    final String orderId = const Uuid().v1();

    int total = 0;
    String itemsList = "";
    String orderDate = DateTime.now().toString();

    for (int i = 0; i < cartItems.length; i++) {
      var zz = cartItems[i].data() as Map<String, dynamic>;
      // itemsList = "$itemsList\n${getSingleItemInfo(zz)}";
      total += (int.parse(zz['itemModel']['pushedRate']) *
          int.parse(zz['quantity']));
    }

    String orderReceipt = getOrderReceipt(
      orderId,
      orderDate,
      itemsList,
      authController.currentUsername.value,
      authController.currentPhoneNumber.value,
      authController.currentEmail.value,
      total.toString(),
    );

    launchTheUrl(getWhatsappOrderLink(
        vendorOptionsUpdating.vendorPhoneNumberVar.value, orderReceipt));
  }

  void getSingleItemInfo(Map<String, dynamic> itemData) {
    // another itemId is there ['itemModel']['itemId']
    String cartItemId = itemData['cartItemId'];
    String extraNotes = itemData['extraNotes'];
    String pushedProductName = itemData['itemModel']['pushedProductName'];
    String draftProductName = itemData['itemModel']['draftProductName'];
    String quantity = itemData['quantity'];

    String pushedRate = itemData['itemModel']['pushedRate'];

    InvoiceItem anItem = InvoiceItem(
      extraNotes: extraNotes,
      quantity: quantity,
      unitPrice: pushedRate,
      productName: pushedProductName,
      productId: cartItemId,
      draftProductName: draftProductName,
    );
    itemsForPdf.add(anItem);
  }

  String getOrderReceipt(
      String orderId,
      String orderDate,
      String itemsList,
      String customerName,
      String customerPhoneNumber,
      String customerEmail,
      String totalPrice) {
    return '''
  *--Order Receipt--*

  *Store Name:* ${vendorOptionsUpdating.vendorStoreNameVar.value}

  *Order ID:* $orderId,

  *Date:* $orderDate

  *---Items ordered---*

  $itemsList

  *Grand Total:* ₹ $totalPrice /-

  *Customer Details:*

  Name: $customerName,Phone: $customerPhoneNumber,Email: $customerEmail

  *-Important-*

  Make sure you ask the delivery address, payment method and other information.
  Also, let customer negotiate for a successful sale. Best of Luck!

  *---With love from Sauda2Sale---*
  ''';
  }
*/