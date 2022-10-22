import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app_vendor/constants/routes.dart';
import 'package:shop_app_vendor/screens/business_register_screen.dart';
import 'package:shop_app_vendor/screens/home_screen.dart';
import 'package:shop_app_vendor/services/firebase_services.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseService service = FirebaseService();

    return StreamBuilder<DocumentSnapshot>(
      stream: service.vendor.doc(service.user!.uid).snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 50,
            width: 50,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (!snapshot.data!.exists) {
          return const BusinessRegisterScreen();
        }

        // VendorModel vendor =
        //     VendorModel.fromJson(snapshot.data!.data() as Map<String, dynamic>);

        var docc = snapshot.data;

        if (docc!['approved']) {
          return const Home();
        }

        return Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Log Out button
                  TextButton.icon(
                    onPressed: () {
                      FirebaseAuth.instance.signOut().then((value) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            loginScreenRoute, (route) => false);
                      });
                    },
                    label: const Text('Log Out'),
                    icon: const Icon(Icons.logout),
                  ),
                ],
              ),
              // Logo and Business Name
              SizedBox(
                height: 200,
                width: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: CachedNetworkImage(
                    imageUrl: docc['logo'],
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 200,
                      width: 200,
                      color: Colors.grey.shade300,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              // Business Name
              Text(
                docc['businessName'],
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Center(child: Text('An Admin will contact you...')),
            ],
          ),
        );
      },
    );
  }
}
