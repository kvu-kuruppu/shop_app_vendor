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
    final FirebaseService _service = FirebaseService();
    final _provider = Provider.of<ProductProvider>(context);
    final _vendorData = Provider.of<VendorProvider>(context);
    final _formkey = GlobalKey<FormState>();
    final SCF _scf = SCF();

    return Form(
      key: _formkey,
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
                        if (_provider.imageFiles!.isEmpty) {
                          _scf.scaffoldMsg(
                            context: context,
                            msg: 'Image is not selected',
                          );
                          return;
                        }
                        if (_formkey.currentState!.validate()) {
                          // print(_provider.productData);
                          EasyLoading.show(status: 'Please Wait...');
                          _provider.getFormData(seller: {
                            'name': _vendorData.doc!['businessName'],
                            'uid': _service.user!.uid,
                          });
                          _service
                              .uploadFiles(
                            images: _provider.imageFiles,
                            ref:
                                'products/${_vendorData.doc!['businessName']}/${_provider.productData!['productName']}/',
                            provider: _provider,
                          )
                              .then((value) {
                            if (value.isNotEmpty) {
                              _service
                                  .saveToDb(
                                data: _provider.productData,
                                context: context,
                              )
                                  .then((value) {
                                EasyLoading.dismiss();
                                setState(() {
                                  _provider.clearProductData();
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
