import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
// import 'package:newoutomateshiksha/homescreen.dart';
// import 'package:newoutomateshiksha/loginpage.dart';
import 'package:newoutomateshiksha_newmaster/splashscreen.dart';
// import 'package:newoutomateshiksha/webviewtesting.dart';
import 'Resource/Colors/app_colors.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Outomate Shiksha App',
      theme: ThemeData(
        primarySwatch: mainAppColor,
        fontFamily: 'Poppins',
      ),
      home: splashscreen(),
    );
  }
}
