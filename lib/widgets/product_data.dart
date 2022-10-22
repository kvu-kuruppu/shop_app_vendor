import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:shop_app_vendor/screens/all_products/product_details_screen.dart';
import 'package:shop_app_vendor/services/firebase_services.dart';

class ProductData extends StatelessWidget {
  final AsyncSnapshot<QuerySnapshot<Object?>> snapshot;
  final FirebaseService service;

  const ProductData({
    Key? key,
    required this.snapshot,
    required this.service,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: snapshot.data!.size,
        itemBuilder: (context, index) {
          Map<String, dynamic> dataa =
              snapshot.data!.docs[index].data() as Map<String, dynamic>;

          var id = snapshot.data!.docs[index].id;

          var images = snapshot.data!.docs[index]['imageUrl'] as List;

          var discount = (dataa['regularPrice'] - dataa['salesPrice']) *
              100 /
              dataa['regularPrice'];

          String regularPrice =
              NumberFormat('###,###').format(dataa['regularPrice']);

          String salesPrice =
              NumberFormat('###,###').format(dataa['salesPrice']);

          return Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Slidable(
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  // Approve
                  SlidableAction(
                    onPressed: (context) {
                      service.products.doc(id).update({
                        'approved': dataa['approved'] ? false : true,
                      });
                    },
                    backgroundColor: Colors.green,
                    icon: Icons.approval,
                    label: dataa['approved'] ? 'Inactive' : 'Approve',
                  ),
                  // Delete
                  SlidableAction(
                    onPressed: (context) {},
                    backgroundColor: Colors.red,
                    icon: Icons.delete,
                    label: 'Delete',
                  )
                ],
              ),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProductDetail(
                        id: id,
                        dataa: dataa,
                        images: images,
                      ),
                    ),
                  );
                },
                child: Card(
                  child: Row(
                    children: [
                      // image
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 70,
                          width: 70,
                          color: Colors.grey,
                          child: CachedNetworkImage(
                            imageUrl: images[0],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Name
                            Text(
                              dataa['productName'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Price
                            Row(
                              children: [
                                const Text('Price:'),
                                const SizedBox(width: 10),
                                Text('$salesPrice\$'),
                                const SizedBox(width: 10),
                                Text(
                                  '$regularPrice\$',
                                  style: const TextStyle(
                                    color: Colors.red,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Discount
                      Expanded(
                        child: Container(
                          height: 35,
                          width: 40,
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.yellow,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.red, width: 2),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Center(
                                child: Text(
                                  '${discount.toInt().toString()}%',
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const Text(
                                'OFF',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 3),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
