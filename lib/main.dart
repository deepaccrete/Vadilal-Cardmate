import 'dart:io';

import 'package:camera_app/screen/splashScreen.dart';
import 'package:camera_app/store/appStore.dart';
import 'package:camera_app/util/internet_check.dart';
import 'package:flutter/material.dart';



final appStore = AppStore();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}


void main() async{
  // WidgetsFlutterBinding.ensureInitialized();
  // await Hive.initFlutter();

  // register adapter
  // Hive.registerAdapter(CardDetailsAdapter());
  // Hive.registerAdapter(PendingImageAdapter());
  // final box = Hive.openBox('pending_images');
  // await Hive.openBox<PendingImage>('pending_images');
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
  void initState() {
    super.initState();
    // Delay starting internet checker after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      InternetChecker().start();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // builder: (context, child) {
      //   WidgetsBinding.instance.addPostFrameCallback((_) {
      //     if (ModalRoute.of(context)?.isCurrent ?? false) {
      //       InternetChecker().Start(context);
      //     }
      //   });
      //   return child!;
      // },
navigatorKey: navigatorKey,
      // home:GroupAndTags()
    // home:AddDetails()
    home: SplashScreen()
    );
  }
}
