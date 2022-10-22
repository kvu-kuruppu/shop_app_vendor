import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_vendor/provider/product_provider.dart';
import 'package:shop_app_vendor/provider/vendor_provider.dart';
import 'package:shop_app_vendor/screens/add_products/attribute_tab.dart';
import 'package:shop_app_vendor/screens/add_products/general_tab.dart';
import 'package:shop_app_vendor/screens/add_products/images_tab.dart';
import 'package:shop_app_vendor/screens/add_products/inventory_tab.dart';
import 'package:shop_app_vendor/screens/add_products/shipping_tab.dart';
import 'package:shop_app_vendor/services/firebase_services.dart';
import 'package:shop_app_vendor/widgets/customer_drawer.dart';
import 'package:shop_app_vendor/widgets/scaffold_msg.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  @override
  Widget build(BuildContext context) {
    final FirebaseService service = FirebaseService();
    final provider = Provider.of<ProductProvider>(context);
    final vendorData = Provider.of<VendorProvider>(context);
    final formkey = GlobalKey<FormState>();
    final SCF scf = SCF();

    return Form(
      key: formkey,
      child: DefaultTabController(
        length: 6,
        initialIndex: 0,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Add Products'),
            elevation: 0,
            backgroundColor: const Color.fromARGB(255, 10, 11, 102),
            bottom: const TabBar(
              isScrollable: true,
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(
                  width: 4,
                  color: Colors.deepOrange,
                ),
              ),
              tabs: [
                Tab(child: Text('General')),
                Tab(child: Text('Inventory')),
                Tab(child: Text('Shipping')),
                Tab(child: Text('Attributes')),
                Tab(child: Text('Linked Products')),
                Tab(child: Text('Images')),
              ],
            ),
          ),
          drawer: const CustomDrawer(),
          body: const TabBarView(
            children: [
              GeneralTab(),
              InventoryTab(),
              ShippingTab(),
              AttributeTab(),
              Center(child: Text('Linked Products')),
              ImagesTab(),
            ],
          ),
          persistentFooterButtons: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (provider.imageFiles!.isEmpty) {
                          scf.scaffoldMsg(
                            context: context,
                            msg: 'Image is not selected',
                          );
                          return;
                        }
                        if (formkey.currentState!.validate()) {
                          // print(_provider.productData);
                          EasyLoading.show(status: 'Please Wait...');
                          provider.getFormData(seller: {
                            'name': vendorData.doc!['businessName'],
                            'uid': service.user!.uid,
                          });
                          service
                              .uploadFiles(
                            images: provider.imageFiles,
                            ref:
                                'products/${vendorData.doc!['businessName']}/${provider.productData!['productName']}/',
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
                              });
                            }
                          });
                        }
                      },
                      child: const Text('Save Product'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
