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
    String? description,
    DateTime? scheduleDate,
    String? sku,
    bool? manageInventory,
    int? stockOnHand,
    int? reorderLevel,
    bool? shippingChargeStatus,
    int? shippingCharge,
    String? brand,
    List? sizeList,
    String? remarks,
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

    if (description != null) {
      productData!['description'] = description;
    }

    if (scheduleDate != null) {
      productData!['scheduleDate'] = scheduleDate;
    }

    if (sku != null) {
      productData!['sku'] = sku;
    }

    if (manageInventory != null) {
      productData!['manageInventory'] = manageInventory;
    }

    if (stockOnHand != null) {
      productData!['stockOnHand'] = stockOnHand;
    }

    if (reorderLevel != null) {
      productData!['reorderLevel'] = reorderLevel;
    }

    if (shippingChargeStatus != null) {
      productData!['shippingChargeStatus'] = shippingChargeStatus;
    }

    if (shippingCharge != null) {
      productData!['shippingCharge'] = shippingCharge;
    }

    if (brand != null) {
      productData!['brand'] = brand;
    }

    if (sizeList != null) {
      productData!['sizeList'] = sizeList;
    }

    if (remarks != null) {
      productData!['remarks'] = remarks;
    }

    notifyListeners();
  }
}
