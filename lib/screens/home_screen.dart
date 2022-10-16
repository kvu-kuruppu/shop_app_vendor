import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_vendor/provider/vendor_provider.dart';
import 'package:shop_app_vendor/widgets/customer_drawer.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _vendorData = Provider.of<VendorProvider>(context);

    if (_vendorData.doc == null) {
      _vendorData.getVendorData();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 10, 11, 102),
      ),
      drawer: const CustomDrawer(),
      body: Center(
        child: Text('Home'),
      ),
    );
  }
}
