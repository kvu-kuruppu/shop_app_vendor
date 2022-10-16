import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_vendor/constants/routes.dart';
import 'package:shop_app_vendor/firebase_options.dart';
import 'package:shop_app_vendor/provider/vendor_provider.dart';
import 'package:shop_app_vendor/screens/add_products_screen.dart';
import 'package:shop_app_vendor/screens/home_screen.dart';
import 'package:shop_app_vendor/screens/landing_screen.dart';
import 'package:shop_app_vendor/screens/login.dart';
import 'package:shop_app_vendor/screens/products_screen.dart';
import 'package:shop_app_vendor/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Provider.debugCheckInvalidValueType = null;

  runApp(
    MultiProvider(
      providers: [
        Provider<VendorProvider>(create: (_) => VendorProvider()),
      ],
      child: MaterialApp(
        home: const SplashScreen(),
        routes: {
          loginScreenRoute: (context) => const LoginView(),
          landingScreenRoute: (context) => const LandingScreen(),
          homeScreenRoute: (context) => const Home(),
          productScreenRoute: (context) => const ProductScreen(),
          addProductScreenRoute: (context) => const AddProductScreen(),
        },
        builder: EasyLoading.init(),
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}
