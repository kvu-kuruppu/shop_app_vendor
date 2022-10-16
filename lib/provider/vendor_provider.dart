import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_app_vendor/services/firebase_services.dart';

class VendorProvider with ChangeNotifier {
  final FirebaseService _service = FirebaseService();
  DocumentSnapshot? doc;

  getVendorData() {
    _service.vendor.doc(_service.user!.uid).get().then((document) {
      doc = document;
      notifyListeners();
    });
  }
}
