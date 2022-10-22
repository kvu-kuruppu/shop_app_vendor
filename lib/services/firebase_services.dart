import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:shop_app_vendor/provider/product_provider.dart';
import 'package:shop_app_vendor/widgets/scaffold_msg.dart';

class FirebaseService {
  final SCF _scf = SCF();

  User? user = FirebaseAuth.instance.currentUser;

  final CollectionReference vendor =
      FirebaseFirestore.instance.collection('vendor');
  final CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');
  final CollectionReference mainCategory =
      FirebaseFirestore.instance.collection('mainCategory');
  final CollectionReference subCategory =
      FirebaseFirestore.instance.collection('subCategory');
  final CollectionReference products =
      FirebaseFirestore.instance.collection('products');

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<String> uploadImg({XFile? file, String? reference}) async {
    File filee = File(file!.path);

    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref(reference);

    await ref.putFile(filee);

    String downloadURL = await ref.getDownloadURL();

    return downloadURL;
  }

  Future<List> uploadFiles({
    List<XFile>? images,
    String? ref,
    ProductProvider? provider,
  }) async {
    var imageUrl = await Future.wait(images!.map(
      (img) => uploadFile(img: File(img.path), reference: ref),
    ));

    provider!.getFormData(imageUrl: imageUrl);
    return imageUrl;
  }

  Future uploadFile({File? img, String? reference}) async {
    firebase_storage.Reference storageReference =
        storage.ref().child('$reference/${DateTime.now()}');
    firebase_storage.UploadTask uploadTask = storageReference.putFile(img!);
    await uploadTask;
    return storageReference.getDownloadURL();
  }

  Future<void> addVendor({Map<String, dynamic>? data}) {
    return vendor
        .doc(user!.uid)
        .set(data)
        .then((value) => _scf.scaffoldMsg(context: context, msg: 'User Added'));
  }

  Future<void> saveToDb({
    BuildContext? context,
    Map<String, dynamic>? data,
  }) {
    return products.add(data).then(
        (value) => _scf.scaffoldMsg(context: context, msg: 'Product Saved'));
  }
}
