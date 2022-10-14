import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shop_app_vendor/constants/routes.dart';
import 'package:shop_app_vendor/firebase_options.dart';
import 'package:shop_app_vendor/screens/landing_screen.dart';
import 'package:shop_app_vendor/screens/login.dart';
import 'package:shop_app_vendor/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MaterialApp(
      home: const SplashScreen(),
      routes: {
        loginScreenRoute: (context) => const LoginView(),
        landingScreenRoute: (context) => const LandingScreen(),
      },
      builder: EasyLoading.init(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
