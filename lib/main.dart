import 'package:camera_app/screen/add.dart';
import 'package:camera_app/screen/bottomnav.dart';
import 'package:camera_app/screen/camera_screen.dart';
import 'package:camera_app/screen/groupandtags.dart';
import 'package:camera_app/screen/home.dart';
import 'package:camera_app/screen/login.dart';
import 'package:camera_app/screen/login1.dart';
import 'package:camera_app/screen/splash.dart';
import 'package:camera_app/store/appStore.dart';
import 'package:flutter/material.dart';


final appStore = AppStore();


void main() {
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home:GroupAndTags()
    // home:Bottomnav(),
    home: SplashScreen()
    );
  }
}
