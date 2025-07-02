import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:camera_app/constant/colors.dart';
import 'package:camera_app/model/LoginModel.dart';
import 'package:camera_app/screen/bottomnav.dart';
import 'package:camera_app/screen/login1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import '../util/const.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  bool animationStarted = false;
  bool showNext = false;

  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();

    Timer(Duration(seconds: 3), () {
      _startAnimation();
      // if (appStore.isLoggedIn) {
      //   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Bottomnav()), (route) => false);
      // } else {
      //   Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
      // }

      //
    });
  }

  getData() async {
    try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final bool? isLogin = prefs.getBool(IS_LOGGED_IN);
    appStore.setIsLogin(isLogin ?? false);

    if (isLogin == true) {
      appStore.setUserToken(prefs.getString(TOKEN) ?? "");
      Map<String, dynamic> userDetailsString = jsonDecode(prefs.getString(USER_DETAIL)!);
      UserData userDetails = UserData.fromJson(userDetailsString);
      appStore.setUser(userDetails);
    }
    } catch (e) {
      print(
          "this is the following error ------------------------------------------------------------------------------------->\n ${e}");
    }
  }

  void _startAnimation() {
    setState(() => animationStarted = true);
    Future.delayed(Duration(milliseconds: 2100), () {
      setState(() => showNext = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final maxRadius = sqrt(screenSize.width * screenSize.width + screenSize.height * screenSize.height) * 2;
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Stack(
        children: [
          Container(
            // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
            // color: Colors.white,
            decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/bgimage.png'), fit: BoxFit.cover)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Container(height: 200, width: 200, child: Image.asset('assets/images/Frame 2.png', fit: BoxFit.contain))],
            ),
          ),

          // Expanding Circle Animation
          if (animationStarted && !showNext)
            Center(
              child: Animate(
                onComplete: (_) {},
                effects: [
                  MoveEffect(begin: Offset(0, -screenSize.height / 2), end: Offset.zero, duration: 800.ms, curve: Curves.easeOutBack),
                  ScaleEffect(
                    begin: Offset(1, 1),
                    end: Offset(maxRadius / 50, maxRadius / 50),
                    // e.g., scale to ~18x
                    duration: 1600.ms,
                    delay: 800.ms,
                    curve: Curves.easeInOutCubic,
                  ),
                ],

                child: Container(width: 100, height: 100, decoration: BoxDecoration(color: primarycolor, shape: BoxShape.circle)),
              ),
            ),

          // Final screen
          if (showNext) (appStore.isLoggedIn?Bottomnav():LoginScreen()),
        ],
      ),
    );
  }
}
