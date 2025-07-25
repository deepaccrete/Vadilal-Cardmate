import 'package:flutter/material.dart';


void showCustomSnackbar(BuildContext context, String message,) {
  final snackBar = SnackBar(
    backgroundColor: Theme.of(context).primaryColor,
    content: Text(
      message,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16.0,
      ),
    ),

    duration: const Duration(seconds: 2),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
// void _showSnackBar(String message) {
//   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       backgroundColor: Theme.of(context).primaryColor,
//       content: Text(message,
//           textAlign: TextAlign.center,
//           style: const TextStyle(color: Colors.white, fontSize: 16.0))));
// }