import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_app_vendor/services/firebase_services.dart';
import 'package:shop_app_vendor/widgets/product_data.dart';

class Unpublished extends StatelessWidget {
  const Unpublished({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseService service = FirebaseService();

    return StreamBuilder<QuerySnapshot>(
      stream: service.products
          .where('approved', isEqualTo: false)
          .where('seller.uid', isEqualTo: service.user!.uid)
          .orderBy('productName')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Something wrong!');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data!.size == 0) {
          return const Center(
            child: Text('No products'),
          );
        }

        return ProductData(snapshot: snapshot, service: service);
      },
    );
  }
}
