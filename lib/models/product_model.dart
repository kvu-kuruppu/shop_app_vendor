import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  ProductModel({
    this.approved,
    this.productName,
    this.regularPrice,
    this.salesPrice,
    this.taxStatus,
    this.taxPercentage,
    this.category,
    this.mainCategory,
    this.subCategory,
    this.description,
    this.scheduleDate,
    this.sku,
    this.manageInventory,
    this.stockOnHand,
    this.reorderLevel,
    this.shippingChargeStatus,
    this.shippingCharge,
    this.brand,
    this.sizeLis,
    this.remarks,
    this.unit,
    this.imageUrl,
    this.seller,
  });

  ProductModel.fromJson(Map<String, Object?> json)
      : this(
          approved: json['approved']! as bool,
          productName: json['productName']! as String,
          regularPrice: json['regularPrice']! as int,
          salesPrice: json['salesPrice']! as int,
          taxStatus: json['taxStatus']! as String,
          taxPercentage: json['taxPercentage'] == null ? null : json['taxPercentage']! as int,
          category: json['category']! as String,
          mainCategory: json['mainCategory'] == null ? null : json['mainCategory']! as String,
          subCategory: json['subCategory'] == null ? null : json['subCategory']! as String,
          description: json['description']! as String,
          scheduleDate: json['scheduleDate']! as DateTime,
          sku: json['sku']! as String,
          manageInventory: json['manageInventory']! as bool,
          stockOnHand: json['stockOnHand']! as int,
          reorderLevel: json['reorderLevel']! as int,
          shippingChargeStatus: json['shippingChargeStatus']! as bool,
          shippingCharge: json['shippingCharge']! as int,
          brand: json['brand']! as String,
          sizeLis: json['sizeLis']! as List,
          remarks: json['remarks']! as String,
          unit: json['unit']! as String,
          imageUrl: json['imageUrl']! as List,
          seller: json['seller']! as Map,
        );

  bool? approved;
  String? productName;
  int? regularPrice;
  int? salesPrice;
  String? taxStatus;
  int? taxPercentage;
  String? category;
  String? mainCategory;
  String? subCategory;
  String? description;
  DateTime? scheduleDate;
  String? sku;
  bool? manageInventory;
  int? stockOnHand;
  int? reorderLevel;
  bool? shippingChargeStatus;
  int? shippingCharge;
  String? brand;
  List? sizeLis;
  String? remarks;
  String? unit;
  List? imageUrl;
  Map? seller;

  Map<String, Object?> toJson() {
    return {
      'approved': approved,
      'productName': productName,
      'regularPrice': regularPrice,
      'salesPrice': salesPrice,
      'taxStatus': taxStatus,
      'taxPercentage': taxPercentage,
      'category': category,
      'mainCategory': mainCategory,
      'subCategory': subCategory,
      'description': description,
      'scheduleDate': scheduleDate,
      'sku': sku,
      'manageInventory': manageInventory,
      'stockOnHand': stockOnHand,
      'reorderLevel': reorderLevel,
      'shippingChargeStatus': shippingChargeStatus,
      'shippingCharge': shippingCharge,
      'brand': brand,
      'sizeLis': sizeLis,
      'remarks': remarks,
      'unit': unit,
      'imageUrl': imageUrl,
      'seller': seller,
    };
  }
}


productCollection({approved}) {
  return FirebaseFirestore.instance.collection('products')
      .where('approved', isEqualTo: approved)
      .withConverter<ProductModel>(
        fromFirestore: (snapshot, _) => ProductModel.fromJson(snapshot.data()!),
        toFirestore: (movie, _) => movie.toJson(),
      );
}