import 'dart:convert';

import 'package:camera_app/main.dart';
import 'package:camera_app/model/cardModel.dart';
import 'package:camera_app/util/const.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class CardApi {
  static Future<CardModel> getCard() async {
    try {
      var headers1 = {'Authorization': 'Bearer ${appStore.userData!.token}'};

      final response = await http.post(
        Uri.parse(AppApiConst.cardget),
        headers: headers1,
      );

      debugPrint(
        "============================ URL ===============================${AppApiConst.cardget}",
      );
      debugPrint(
        "============================ RESPONSE ===============================${response.body}",
      );
      debugPrint(
        "============================ STATUSCODE  ===============================${response.statusCode}",
      );

      debugPrint("Full URL: ${Uri.parse(AppApiConst.cardget)}");
      // print('API Front Image: ${apiResponse['cardFrontImageBase64']}');
      // print('API Back Image: ${apiResponse['cardBackImageBase64']}');

      if (response.statusCode == 200) {
        return CardModel.fromJson(jsonDecode(response.body));
      } else {
        return CardModel.fromJson(jsonDecode(response.body));
      }
    } catch (e) {

      print('this is the erorr for Card Api=====> $e');
      return CardModel(success: 0, data: []);
    }
  }


  // static Future<bool> updateCard(
  //     {required String cardId,})async{
  //   try{
  //     final url = Uri.parse(${AppApiConst.})
  //   }
  //
  // }
}
