import 'dart:convert';

import 'package:camera_app/main.dart';
import 'package:camera_app/model/addManualCardModel.dart';

import 'package:camera_app/model/cardModel.dart';

import 'package:camera_app/util/const.dart';

import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;

class CardApi {
  // static Map<String, String> _getheader() {
  //   return {
  //     // 'Content-Type': 'Application/json',
  //     'Content-Type': 'application/json',
  //     // 'accept': 'application/json',
  //     'Authorization': 'Bearer ${appStore.userData!.token}',
  //   };
  // }

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
        "============================ STATUSCODE ===============================${response.statusCode}",
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

  static Future<bool> updateCard(DataCard card) async {

    if (card.cardID == null) {
      debugPrint('Cannot Update cardid is null');
      return false;
    }

    // final url = Uri.parse(AppApiConst.cardupdate);
    var headers1 = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${appStore.userData!.token}'};
    try {
      final response = await http.post(
        Uri.parse(AppApiConst.cardupdate),

        headers: headers1,
        body: jsonEncode(card.toJson()),
      );
      debugPrint("API URL (UPDATE): ${AppApiConst.cardupdate}");
      debugPrint("API STATUSCODE (UPDATE): ${response.statusCode}");
      debugPrint("API REQUEST BODY (UPDATE): ${jsonEncode(card.toJson())}");
      debugPrint("API RESPONSE (UPDATE): ${response.body}");

      if (response.statusCode == 200) {
        return true;
      } else {
        debugPrint(
          'Failed to create card. Status code: ${response.statusCode}. Body: ${response.body}',
        );
        return false;
      }
    } catch (e) {
      print('Faild to Update $e');
      return false;
    }
  }


//   static Future<AddManualCardModel> addCard(AddManualCardModel addccard)async{
//
//     var headers1 = {
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer ${appStore.userData!.token}'};
//
//
//   try{
//
//   }catch(e){
//
//   }
//
// }

}