import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app_vendor/constants/routes.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
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
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: const Center(child: Text('An Admin will contact you...')),
            ),
          ],
        ),
      ),
    );
  }
}
