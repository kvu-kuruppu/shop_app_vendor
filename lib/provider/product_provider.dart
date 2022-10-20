import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProductProvider with ChangeNotifier {
  Map<String, dynamic>? productData = {'approved': false};
  List<XFile>? imageFiles = [];

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
    String? unit,
    List? imageUrl,
    Map? seller,
  }) {
    if (seller != null) {
      productData!['seller'] = seller;
    }

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

    if (unit != null) {
      productData!['unit'] = unit;
    }

    if (imageUrl != null) {
      productData!['imageUrl'] = imageUrl;
    }

    notifyListeners();
  }

  getImageFiles(image) {
    imageFiles!.add(image);
    notifyListeners();
  }

  clearProductData() {
    productData!.clear();
    imageFiles!.clear();
    productData!['approved'] = false;

    notifyListeners();
  }
}
