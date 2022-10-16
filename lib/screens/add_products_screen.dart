import 'package:flutter/material.dart';
import 'package:shop_app_vendor/widgets/customer_drawer.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Products'),
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 10, 11, 102),
      ),
      drawer: const CustomDrawer(),
      body: Center(
        child: Text('AddProductScreen'),
      ),
    );
  }
}
