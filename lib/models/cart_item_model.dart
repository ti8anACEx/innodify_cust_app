import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:innodify_cust_app/models/item_model.dart';

class CartItemModel {
  final ItemModel itemModel;
  final String orderedBy; // customer name
  final String orderedFrom; // store name
  final String orderedByUid;
  final String orderedFromUid;
  final String
      cartItemId; // same as orderId, until the app does not take the initiative of managing orders itself
  final datePublished;
  final String quantity; // quantity of the item in the cart (as String)
  final String extraNotes;

  CartItemModel({
    required this.itemModel,
    required this.cartItemId,
    required this.datePublished,
    required this.orderedBy,
    required this.orderedFrom,
    required this.quantity,
    required this.extraNotes,
    required this.orderedByUid,
    required this.orderedFromUid,
  });

  Map<String, dynamic> toJson() {
    return {
      'itemModel': itemModel.toJson(),
      'orderedBy': orderedBy,
      'orderedFrom': orderedFrom,
      'cartItemId': cartItemId,
      'datePublished': datePublished, // Store as Timestamp
      'quantity': quantity,
      'extraNotes': extraNotes,
      'orderedByUid': orderedByUid,
      'orderedFromUid': orderedFromUid,
    };
  }

  static CartItemModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return CartItemModel(
      itemModel: ItemModel.fromSnap(snap),
      extraNotes: snapshot['extraNotes'],
      orderedByUid: snapshot['orderedByUid'],
      orderedFromUid: snapshot['orderedFromUid'],
      orderedBy: snapshot['orderedBy'],
      orderedFrom: snapshot['orderedFrom'],
      cartItemId: snapshot['cartItemId'],
      datePublished: snapshot['datePublished'], // Cast as Timestamp if reqd
      quantity: snapshot['quantity']?.toString() ??
          '1', // Handle potential missing quantity field and convert to String
    );
  }
}
