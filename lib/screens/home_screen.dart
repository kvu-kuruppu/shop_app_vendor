import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_vendor/provider/vendor_provider.dart';
import 'package:shop_app_vendor/widgets/customer_drawer.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vendorData = Provider.of<VendorProvider>(context);

    if (vendorData.doc == null) {
      vendorData.getVendorData();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 10, 11, 102),
      ),
      drawer: const CustomDrawer(),
      body: const Center(
        child: Text('Home'),
      ),
    );
  }
}
