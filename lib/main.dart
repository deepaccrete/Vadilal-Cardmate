import 'package:camera_app/model/dbModel/cardDetailsModel.dart';
import 'package:camera_app/model/dbModel/imagemodel.dart';
import 'package:camera_app/screen/add.dart';
import 'package:camera_app/screen/home.dart';

import 'package:camera_app/screen/splash.dart';
import 'package:camera_app/store/appStore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';


final appStore = AppStore();


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // register adapter
  Hive.registerAdapter(CardDetailsAdapter());
  Hive.registerAdapter(PendingImageAdapter());
  // final box = Hive.openBox('pending_images');
  await Hive.openBox<PendingImage>('pending_images');

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
    // home:AddDetails()
    home: SplashScreen()
    );
  }
}
