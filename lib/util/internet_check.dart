import 'dart:async';
import 'dart:io';
import 'package:camera_app/componets/button.dart';
import 'package:camera_app/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http ;
class InternetChecker with WidgetsBindingObserver {
  static final InternetChecker _instance = InternetChecker._internal();
  factory InternetChecker() => _instance;
  InternetChecker._internal();

  Timer? _timer;
  bool _isDialogVisible = false;

  void start({int intervalSecond = 5}) {
    WidgetsBinding.instance.addObserver(this);
    _startTimer(intervalSecond);
  }

  void _startTimer(int intervalSecond) {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: intervalSecond), (_) async {
      if (navigatorKey.currentContext == null) return;
      bool connected = await checkInternet();
      if (!connected && !_isDialogVisible) {
        _showInternetPopup();
      }
    });
  }

  Future<bool> checkInternet() async {
    try {

      final repsonse = await HttpClient().getUrl(Uri.parse('https://www.google.com'));
      await repsonse.close();
      print('Internet is Working');
      return true;
     //  final result = await InternetAddress.lookup('google.com');
     // return result.isNotEmpty && result[0].rawAddress.isNotEmpty;

      // final address = result.first;
      // final socket = await Socket.connect(address.address, 80, timeout: Duration(seconds: 2));
      // socket.destroy();
      // return true;
    } catch (_) {
      print('no Internnet');
      return false;
    }
  }

  void _showInternetPopup() {
    final ctx = navigatorKey.currentContext;
    if (ctx == null) return;

    _isDialogVisible = true;
 Future.delayed(Duration.zero,(){
   showDialog(
     context: ctx,
     barrierDismissible: false,
     builder: (_) {
       final width = MediaQuery.of(ctx).size.width * 1;
       final height = MediaQuery.of(ctx).size.height * 1;
       return AlertDialog(
         title: const Text('No Internet',textAlign: TextAlign.center,),
         content: const Text('Check your internet connectivity',textAlign: TextAlign.center,),
         actions: [
           Center(
             child:

             CommonButton(
               bordercircular: 5,
               height: height * 0.05,
               onTap:  () async {
                 bool connected = await checkInternet();
                 if (connected) {
                   Navigator.pop(ctx);
                   _isDialogVisible = false;
                 }
               },
               child:  Text('Retry',style: GoogleFonts.poppins(color: Colors.white),),
             ),
           )
         ],
       );
     },
   ).then((_) {
     _isDialogVisible = false;
   });
 });
  }

  void stop() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
  }

  // Listen for app lifecycle changes
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _startTimer(5);
    } else if (state == AppLifecycleState.paused) {
      _timer?.cancel();
    }
  }
}
