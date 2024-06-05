import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:innodify_cust_app/confidential/vendor_options.dart';
import 'package:innodify_cust_app/features/auth/controllers/auth_controller.dart';
import 'package:intl/intl.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../models/invoice_model.dart';

class SyncPdf {
  String convertUrl(String originalUrl) {
    if (originalUrl.contains('/uploads/pdfs/')) {
      return originalUrl.replaceAll('/uploads/pdfs/', '/uploads%2Fpdfs%2F');
    } else {
      return originalUrl;
    }
  }

  Future<String> saveAndLaunchFile(
      List<int> bytes, String fileName, String invoiceId) async {
    if (kIsWeb) {
      html.AnchorElement(
          href:
              'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
        ..setAttribute('download', fileName)
        ..click();
      return "web-contdition-unhandled";
    } else {
      final path = (await getExternalStorageDirectory())!.path;
      final file = File('$path/$fileName');
      await file.writeAsBytes(bytes, flush: true);
      // OpenFile.open('$path/$fileName');

      String downloadUrl =
          await uploadFiles(invoiceId, File('$path/$fileName'));

      return downloadUrl;
    }
  }

  Future<String> uploadFiles(String invoiceId, File file) async {
    try {
      Reference storageReference =
          FirebaseStorage.instance.ref().child('uploads/pdfs/$invoiceId');
      SettableMetadata metadata =
          SettableMetadata(contentType: 'application/pdf');

      UploadTask uploadTask = storageReference.putFile(file, metadata);

      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
      String downloadURL = await taskSnapshot.ref.getDownloadURL();

      return downloadURL;
    } catch (e) {
      return "error";
    }
  }

  void drawSignature(PdfPage page, List<InvoiceItem> itemsForPdf) {
    // THIS FN CAN BE USEFUL WHEN USING SIGNATURES

    final pageSize = page.getClientSize();
    int tot = 0;
    for (var item in itemsForPdf) {
      tot += int.parse(item.quantity) * int.parse(item.unitPrice);
    }
    final now = DateFormat.yMMMEd().format(DateTime.now());

    final signatureText = '''
    Total: Rs $tot
    $now
    ''';

    page.graphics.drawString(
      signatureText,
      PdfStandardFont(PdfFontFamily.helvetica, 15),
      format: PdfStringFormat(alignment: PdfTextAlignment.left),
      bounds: Rect.fromLTWH(pageSize.width - 140, pageSize.height - 200, 0, 0),
    );
  }

  void drawInfo(
    String invoiceId,
    String addressAndTransportationNotes,
    PdfPage page,
    AuthController authController,
    VendorOptionsUpdating vendorOptionsUpdating,
    List<InvoiceItem> itemsForPdf,
  ) {
    final pageSize = page.getClientSize();
    final now = DateFormat.yMMMEd().format(DateTime.now());
    int tot = 0;
    for (var item in itemsForPdf) {
      tot += int.parse(item.quantity) * int.parse(item.unitPrice);
    }
    final invoiceInformation = '''
  Invoice ID: $invoiceId

  Ordered By: ${authController.currentUsername.value}
  Phone: (+91)${authController.currentPhoneNumber.value}
  Email: ${authController.currentEmail.value}
  $now

  GRAND TOTAL: Rs. ${tot.toString()}
  ''';

    final storeInformation = '''
  Store Name: ${vendorOptionsUpdating.vendorStoreNameVar.value}
  Address: ${vendorOptionsUpdating.vendorOfficeAddressVar.value}
  Phone: (+91)${vendorOptionsUpdating.vendorPhoneNumberVar.value}
  Email: ${vendorOptionsUpdating.vendorEmailVar.value}
  GSTIN: ${vendorOptionsUpdating.vendorGstinVar.value}
  ''';

    var mou = '''
  Address & Transportation Notes:
  $addressAndTransportationNotes
  Both parties are advised to share the requisite information.
  ''';

    // Adjust margins for better layout
    const leftMargin = 20.0;
    const topMargin = 20.0;
    const rightMargin = 20.0;
    const bottomMargin = 20.0;

    // Calculate maximum width for invoice and store information
    final maxWidth = (pageSize.width - leftMargin - rightMargin) / 2;

    // Estimated line heights based on font size (adjust as needed)
    const lineHeight = 15.0; // Adjust based on your font size

    // Calculate estimated number of lines for invoice and store information
    final estimatedInvoiceLines = invoiceInformation.split('\n').length;
    final estimatedStoreLines = storeInformation.split('\n').length;

    // Calculate estimated heights for invoice and store information
    final estimatedInvoiceHeight = estimatedInvoiceLines * lineHeight;
    final estimatedStoreHeight = estimatedStoreLines * lineHeight;

    // Calculate Y position for MOU based on estimated heights
    double larger(double a, double b) => a > b ? a : b;

    final mouTop = topMargin +
        larger(estimatedInvoiceHeight, estimatedStoreHeight) +
        bottomMargin;

    // Draw invoice information on top left with adjusted bounds
    page.graphics.drawString(
      invoiceInformation,
      PdfStandardFont(PdfFontFamily.helvetica, 10),
      format: PdfStringFormat(alignment: PdfTextAlignment.left),
      bounds: Rect.fromLTWH(leftMargin, topMargin, maxWidth, 0),
    );

    // Draw store information on top right with adjusted bounds
    page.graphics.drawString(
      storeInformation,
      PdfStandardFont(PdfFontFamily.helvetica, 10),
      format: PdfStringFormat(alignment: PdfTextAlignment.left),
      bounds: Rect.fromLTWH(
          leftMargin + maxWidth + rightMargin, topMargin, maxWidth, 0),
    );

    // Draw MOU centered with adjusted bounds and Y position
    page.graphics.drawString(
      mou,
      PdfStandardFont(PdfFontFamily.helvetica, 10),
      format: PdfStringFormat(alignment: PdfTextAlignment.center),
      bounds: Rect.fromLTWH(
          leftMargin, mouTop, pageSize.width - leftMargin - rightMargin, 0),
    );
  }

  void drawGrid(PdfPage page, List<InvoiceItem> itemsForPdf) {
    final grid = PdfGrid();
    grid.columns.add(count: 7);

    final headerRow = grid.headers.add(1)[0];
    headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(203, 62, 249));
    headerRow.style.textBrush = PdfBrushes.white;

    headerRow.cells[0].value = 'Product ID';
    headerRow.cells[1].value = 'Name';
    headerRow.cells[2].value = 'Unit Price';
    headerRow.cells[3].value = 'Quantity';
    headerRow.cells[4].value = 'Notes';
    headerRow.cells[5].value = 'Draft Name';
    headerRow.cells[6].value = 'Total Price';

    headerRow.style.font = PdfStandardFont(
      PdfFontFamily.timesRoman,
      10,
      style: PdfFontStyle.bold,
    );

    for (var item in itemsForPdf) {
      final row = grid.rows.add();

      row.cells[0].value = item.productId;
      row.cells[1].value = item.productName;
      row.cells[2].value = item.unitPrice;
      row.cells[3].value = item.quantity;
      row.cells[4].value = item.extraNotes;
      row.cells[5].value = item.draftProductName;
      row.cells[6].value =
          (int.parse(item.quantity) * int.parse(item.unitPrice)).toString();
    }

    grid.draw(
      page: page,
      bounds: const Rect.fromLTWH(0, 220, 0, 0),
    )!;
  }
}
