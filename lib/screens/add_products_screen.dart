import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_vendor/provider/product_provider.dart';
import 'package:shop_app_vendor/provider/vendor_provider.dart';
import 'package:shop_app_vendor/screens/add_products/attribute_tab.dart';
import 'package:shop_app_vendor/screens/add_products/general_tab.dart';
import 'package:shop_app_vendor/screens/add_products/images_tab.dart';
import 'package:shop_app_vendor/screens/add_products/inventory_tab.dart';
import 'package:shop_app_vendor/screens/add_products/linked_tab.dart';
import 'package:shop_app_vendor/screens/add_products/shipping_tab.dart';
import 'package:shop_app_vendor/services/firebase_services.dart';
import 'package:shop_app_vendor/widgets/customer_drawer.dart';
import 'package:shop_app_vendor/widgets/scaffold_msg.dart';

// class AddProductScreen extends StatefulWidget {
//   const AddProductScreen({Key? key}) : super(key: key);

//   @override
//   State<AddProductScreen> createState() => _AddProductScreenState();
// }

// class _AddProductScreenState extends State<AddProductScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final FirebaseService service = FirebaseService();
//     final provider = Provider.of<ProductProvider>(context);
//     final vendorData = Provider.of<VendorProvider>(context);
//     final formkey1 = GlobalKey<FormState>();
//     final formkey2 = GlobalKey<FormState>();
//     final formkey3 = GlobalKey<FormState>();
//     final formkey4 = GlobalKey<FormState>();
//     final SCF scf = SCF();

//     return DefaultTabController(
//       length: 6,
//       initialIndex: 0,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Add Products'),
//           elevation: 0,
//           backgroundColor: const Color.fromARGB(255, 10, 11, 102),
//           bottom: const TabBar(
//             isScrollable: true,
//             indicator: UnderlineTabIndicator(
//               borderSide: BorderSide(
//                 width: 4,
//                 color: Colors.deepOrange,
//               ),
//             ),
//             tabs: [
//               Tab(child: Text('General')),
//               Tab(child: Text('Inventory')),
//               Tab(child: Text('Shipping')),
//               Tab(child: Text('Attributes')),
//               Tab(child: Text('Linked Products')),
//               Tab(child: Text('Images')),
//             ],
//           ),
//         ),
//         drawer: const CustomDrawer(),
//         body: TabBarView(
//           children: [
//             // Form(key: formkey1, child: const GeneralTab()),
//             // Form(key: formkey2, child: const InventoryTab()),
//             // Form(key: formkey3, child: const ShippingTab()),
//             // Form(key: formkey4, child: const AttributeTab()),
//             const GeneralTab(),
//             Form(key: formkey2, child: const InventoryTab()),
//             // const InventoryTab(),
//             const ShippingTab(),
//             const AttributeTab(),
//             const Center(child: Text('Linked Products')),
//             const ImagesTab(),
//           ],
//         ),
//         persistentFooterButtons: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       if (provider.imageFiles!.isEmpty) {
//                         scf.scaffoldMsg(
//                           context: context,
//                           msg: 'Image is not selected',
//                         );
//                         return;
//                       }
//                       if(formkey2.currentState!.validate()){
//                         print('object1');
//                       }
//                       // if (formkey1.currentState!.validate() &&
//                       //     formkey2.currentState!.validate() &&
//                       //     formkey3.currentState!.validate() &&
//                       //     formkey4.currentState!.validate()) {
//                       //   // print(provider.productData);
//                       //   EasyLoading.show(status: 'Please Wait...');
//                       //   provider.getFormData(seller: {
//                       //     'name': vendorData.doc!['businessName'],
//                       //     'uid': service.user!.uid,
//                       //   });
//                       //   service
//                       //       .uploadFiles(
//                       //     images: provider.imageFiles,
//                       //     ref:
//                       //         'products/${vendorData.doc!['businessName']}/${provider.productData!['productName']}/',
//                       //     provider: provider,
//                       //   )
//                       //       .then((value) {
//                       //     if (value.isNotEmpty) {
//                       //       service
//                       //           .saveToDb(
//                       //         data: provider.productData,
//                       //         context: context,
//                       //       )
//                       //           .then((value) {
//                       //         EasyLoading.dismiss();
//                       //         setState(() {
//                       //           provider.clearProductData();
//                       //         });
//                       //       });
//                       //     }
//                       //   });
//                       // }
//                     },
//                     child: const Text('Save Product'),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen>
    with SingleTickerProviderStateMixin {
  late final _tabController = TabController(length: 6, vsync: this);

  @override
  Widget build(BuildContext context) {
    final FirebaseService service = FirebaseService();
    final provider = Provider.of<ProductProvider>(context);
    final vendorData = Provider.of<VendorProvider>(context);
    final SCF scf = SCF();
    final String ref =
        'products/${vendorData.doc!['businessName']}/${provider.productData!['productName']}/';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Products'),
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 10, 11, 102),
        bottom: ReadOnlyTabBar(
          child: TabBar(
            isScrollable: true,
            controller: _tabController,
            indicator: const UnderlineTabIndicator(
              borderSide: BorderSide(
                width: 4,
                color: Colors.deepOrange,
              ),
            ),
            tabs: const [
              Tab(child: Text('General')),
              Tab(child: Text('Inventory')),
              Tab(child: Text('Shipping')),
              Tab(child: Text('Attributes')),
              Tab(child: Text('Linked Products')),
              Tab(child: Text('Images')),
            ],
          ),
        ),
      ),
      drawer: const CustomDrawer(),
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: [
          GeneralTab(onNext: () => _tabController.index = 1),
          InventoryTab(
            onPrevious: () => _tabController.index = 0,
            onNext: () => _tabController.index = 2,
          ),
          ShippingTab(
            onPrevious: () => _tabController.index = 1,
            onNext: () => _tabController.index = 3,
          ),
          AttributeTab(
            onPrevious: () => _tabController.index = 2,
            onNext: () => _tabController.index = 4,
          ),
          LinkedTab(
            onPrevious: () => _tabController.index = 3,
            onNext: () => _tabController.index = 5,
          ),
          ImagesTab(
            onPrevious: () => _tabController.index = 4,
            onSubmit: () {
              if (provider.imageFiles!.isEmpty) {
                scf.scaffoldMsg(
                  context: context,
                  msg: 'Image is not selected',
                );
                return;
              }
              EasyLoading.show(status: 'Please Wait...');

              provider.getFormData(seller: {
                'name': vendorData.doc!['businessName'],
                'uid': service.user!.uid,
              });

              service
                  .uploadFiles(
                images: provider.imageFiles,
                ref: ref,
                provider: provider,
              )
                  .then((value) {
                if (value.isNotEmpty) {
                  service
                      .saveToDb(
                    data: provider.productData,
                    context: context,
                  )
                      .then((value) {
                    EasyLoading.dismiss();

                    setState(() {
                      provider.clearProductData();
                    });

                    _tabController.index = 0;
                  });
                }
              });
            },
          ),
        ],
      ),
    );
  }
}

class ReadOnlyTabBar extends StatelessWidget implements PreferredSizeWidget {
  final TabBar child;

  const ReadOnlyTabBar({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(child: child);
  }

  @override
  Size get preferredSize => child.preferredSize;
}
