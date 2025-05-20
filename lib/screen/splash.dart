import 'dart:async';

import 'package:camera_app/screen/camera_screen.dart';
import 'package:camera_app/screen/login.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
 @override
  void initState() {
    // TODO: implement initState
    super.initState();
 Timer(Duration(seconds: 3),(){
Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginScreen()));
 });
 }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 200,
            width: 200,
            color: Colors.white,
            child: Image.asset('assets/images/bg.png',fit: BoxFit.contain,),
          ),
        ],
      ),
    );
  }
}
