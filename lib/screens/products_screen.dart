import 'package:flutter/material.dart';
import 'package:shop_app_vendor/screens/all_products/published.dart';
import 'package:shop_app_vendor/screens/all_products/unpublished.dart';
import 'package:shop_app_vendor/widgets/customer_drawer.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Products'),
          elevation: 0,
          backgroundColor: const Color.fromARGB(255, 10, 11, 102),
          bottom: const TabBar(
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(
                width: 4,
                color: Colors.deepOrange,
              ),
            ),
            tabs: [
              Tab(child: Text('Unpublished')),
              Tab(child: Text('Published')),
            ],
          ),
        ),
        drawer: const CustomDrawer(),
        body: const TabBarView(
          children: [
            Unpublished(),
            Published(),
          ],
        ),
      ),
    );
  }
}
