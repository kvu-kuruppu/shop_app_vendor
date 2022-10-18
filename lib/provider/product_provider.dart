import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  Map<String, dynamic>? productData = {};

  getFormData({
    String? productName,
    int? regularPrice,
    int? salesPrice,
    String? taxStatus,
    int? taxPercentage,
    String? category,
    String? mainCategory,
    String? subCategory,
  }) {
    if (productName != null) {
      productData!['productName'] = productName;
    }

    if (regularPrice != null) {
      productData!['regularPrice'] = regularPrice;
    }

    if (salesPrice != null) {
      productData!['salesPrice'] = salesPrice;
    }

    if (taxStatus != null) {
      productData!['taxStatus'] = taxStatus;
    }

    if (taxPercentage != null) {
      productData!['taxPercentage'] = taxPercentage;
    }

    if (category != null) {
      productData!['category'] = category;
    }

    if (mainCategory != null) {
      productData!['mainCategory'] = mainCategory;
    }

    if (subCategory != null) {
      productData!['subCategory'] = subCategory;
    }

    notifyListeners();
  }
}
