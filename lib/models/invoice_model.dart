import 'package:innodify_cust_app/models/customer_model.dart';

import 'supplier_model.dart';

// Useful in pdf only
class InvoiceModel {
  final InvoiceInfo info;
  final SupplierModel supplier;
  final CustomerModel customer;
  final List<InvoiceItem> items;

  const InvoiceModel({
    required this.info,
    required this.supplier,
    required this.customer,
    required this.items,
  });
}

class InvoiceInfo {
  final String description;
  final String number;
  final DateTime date;
  final DateTime dueDate;

  const InvoiceInfo({
    required this.description,
    required this.number,
    required this.date,
    required this.dueDate,
  });
}

class InvoiceItem {
  final String extraNotes;
  final String quantity;
  final String unitPrice;
  final String productName;
  final String draftProductName;
  final String productId;

  const InvoiceItem({
    required this.draftProductName,
    required this.extraNotes,
    required this.quantity,
    required this.unitPrice,
    required this.productName,
    required this.productId,
  });
}
