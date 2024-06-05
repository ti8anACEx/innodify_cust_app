import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerModel {
  String username;
  String profilePic; // will be set later from the DB
  String email;
  String uid;
  String phoneNumber;

  CustomerModel({
    required this.username,
    required this.email,
    required this.profilePic,
    required this.uid,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "profilePic": profilePic,
      "email": email,
      "uid": uid,
      "phoneNumber": phoneNumber,
    };
  }

  static CustomerModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return CustomerModel(
      username: snapshot['username'],
      email: snapshot['email'],
      profilePic: snapshot['profilePic'],
      uid: snapshot['uid'],
      phoneNumber: snapshot['phoneNumber'],
    );
  }
}
