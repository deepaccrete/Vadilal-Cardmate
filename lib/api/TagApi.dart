import 'dart:convert';

import 'package:camera_app/model/TagModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;

import '../main.dart';
import '../util/const.dart';

class TagApi {
  static Future<TagModel> getTag() async {
    try {
      var headers1 = {'Authorization': 'Bearer ${appStore.userData!.token}'};

      final response = await http.get(
        Uri.parse(AppApiConst.tagget),
        headers: headers1,
      );
    print("=========== Tag API response ==========");

      debugPrint(
        "===============================-=-=-=-=-=-=>>>>>>>>>>>${AppApiConst.tagget}",
      );
      debugPrint(
        "===============================-=-=-=-=-=-=>>>>>>>>>>>${response.body}",
      );
      debugPrint(
        "===============================-=-=-=-=-=-=>>>>>>>>>>>${response.statusCode}",
      );

      if (response.statusCode == 200) {
        return TagModel.fromJson(jsonDecode(response.body));
      } else {
        return TagModel.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      print("this is the error ------------------>> $e");
      return TagModel();
    }
  }

}
// }
// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// class TagApi {
//   static Future<TagModel> getTag() async {
//     var headers1 = {'Authorization': 'Bearer ${appStore.userData!.token}'};
//
//     final response = await http.get(Uri.parse("http://192.168.120.144:8002/api/v1/tag/gettag"),
//     headers: headers1,
//     ); // Adjust the URL
//
//     print("=========== Tag API response ==========");
//     print(response.statusCode);
//     print(response.body); // Print raw response
//     print("========================================");
//
//     if (response.statusCode == 200) {
//       final Map<String, dynamic> jsonData = jsonDecode(response.body);
//       return TagModel.fromJson(jsonData);
//     } else {
//       throw Exception("Failed to load tag data");
//     }
//   }
// }

