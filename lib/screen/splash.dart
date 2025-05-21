import 'dart:async';
import 'dart:convert';

import 'package:camera_app/model/LoginModel.dart';
import 'package:camera_app/screen/bottomnav.dart';
import 'package:camera_app/screen/camera_screen.dart';
import 'package:camera_app/screen/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../util/const.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();

    Timer(Duration(seconds: 3), () {
      if (appStore.isLoggedIn) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Bottomnav()),(route) => false,);
      }else{
        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
      }
    });
  }

  getData() async {
    // try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final bool? isLogin = prefs.getBool(IS_LOGGED_IN);
    appStore.setIsLogin(isLogin ?? false);

    if (isLogin == true) {
      appStore.setUserToken(prefs.getString(TOKEN)??"");
      Map<String, dynamic> userDetailsString = jsonDecode(prefs.getString(USER_DETAIL)!);
      UserData userDetails = UserData.fromJson(userDetailsString);
      appStore.setUser(userDetails);
    }
    // } catch (e) {
    //   print(
    //       "this is the following error ------------------------------------------------------------------------------------->\n ${e}");
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 200,
            width: 200,
            color: Colors.white,
            child: Image.asset('assets/images/bg.png', fit: BoxFit.contain),
          ),
        ],
      ),
    );
  }
}
