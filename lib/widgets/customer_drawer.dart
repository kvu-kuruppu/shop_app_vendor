import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_vendor/constants/routes.dart';
import 'package:shop_app_vendor/provider/vendor_provider.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _vendorData = Provider.of<VendorProvider>(context);

    Widget _drawerItems({String? text, IconData? icon, String? route}) {
      return ListTile(
        leading: icon == null ? null : Icon(icon),
        title: Text(text!),
        onTap: () {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(route!, (route) => false);
        },
      );
    }

    return Drawer(
      child: Column(
        children: [
          // Drawer Header
          Container(
            height: 150,
            color: const Color.fromARGB(255, 10, 11, 102),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                DrawerHeader(
                  child: _vendorData.doc == null
                      ? const SizedBox(
                          height: 50,
                          width: 50,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Row(
                          children: [
                            CachedNetworkImage(
                              imageUrl: _vendorData.doc!['logo'],
                            ),
                            const SizedBox(width: 20),
                            Text(
                              _vendorData.doc!['businessName'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Home
                _drawerItems(
                  text: 'Home',
                  icon: Icons.home_outlined,
                  route: homeScreenRoute,
                ),
                ExpansionTile(
                  title: const Text('Products'),
                  leading: const Icon(Icons.production_quantity_limits),
                  childrenPadding: const EdgeInsets.only(left: 30),
                  children: [
                    // All Products
                    _drawerItems(
                      text: 'All Products',
                      route: productScreenRoute,
                    ),
                    // Add Products
                    _drawerItems(
                      text: 'Add Products',
                      route: addProductScreenRoute,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(
            color: Colors.grey,
            thickness: 2.0,
          ),
          ListTile(
            title: const Text('Sign Out'),
            trailing: const Icon(Icons.logout),
            onTap: () {
              FirebaseAuth.instance.signOut();
              // Navigator.of(context)
              //     .pushNamedAndRemoveUntil(loginScreenRoute, (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
