import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_vendor/provider/product_provider.dart';
import 'package:shop_app_vendor/widgets/add_products/attribute_tab.dart';
import 'package:shop_app_vendor/widgets/add_products/general_tab.dart';
import 'package:shop_app_vendor/widgets/add_products/inventory_tab.dart';
import 'package:shop_app_vendor/widgets/add_products/shipping_tab.dart';
import 'package:shop_app_vendor/widgets/customer_drawer.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _productData = Provider.of<ProductProvider>(context);
    final _formkey = GlobalKey<FormState>();

    return DefaultTabController(
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
            // Form(key: _formkey, child: const GeneralTab()),
            GeneralTab(),
            InventoryTab(),
            ShippingTab(),
            AttributeTab(),
            Center(child: Text('Linked Products')),
            Center(child: Text('Images')),
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
                      print(_productData.productData);
                      // if (_formkey.currentState!.validate()) {}
                    },
                    child: const Text('Save Product'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
