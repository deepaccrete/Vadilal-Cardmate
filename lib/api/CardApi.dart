import 'dart:convert';
import 'dart:io';

import 'package:camera_app/main.dart';
import 'package:camera_app/model/cardModel.dart';
import 'package:camera_app/util/const.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class CardApi {
  static Future<CardModel> getCard() async {
    try {
      var headers1 = {'Authorization': 'Bearer ${appStore.userData!.token}'};

      final response = await http.post(Uri.parse(AppApiConst.cardget), headers: headers1);

      debugPrint("============================ URL ===============================${AppApiConst.cardget}");
      debugPrint("============================ RESPONSE ===============================${response.body}");
      debugPrint("============================ STATUSCODE  ===============================${response.statusCode}");

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

  static Future addCardManually({required File frontImage, File? backImage, required String cardDetails}) async {
    final uri = Uri.parse(AppApiConst.addCardManually);

    //  header with Bearer token
    final headers = {'Authorization': 'Bearer ${appStore.userData!.token}', 'Accept': 'application/json'};

    var request = http.MultipartRequest('POST', uri)..headers.addAll(headers);

    // front image
    request.files.add(
      await http.MultipartFile.fromPath(
        'images', //  make sure this matches your backend field name
        frontImage.path,
        filename: basename(frontImage.path),
      ),
    );

    //   add back image if available
    if (backImage != null) {
      request.files.add(
        await http.MultipartFile.fromPath('images', backImage.path, filename: basename(backImage.path)),
      );
    }

    request.fields['data'] = cardDetails;


    try {
      final streamedResponse = await request.send();

      final response = await http.Response.fromStream(streamedResponse); // ✅ Convert here

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'] == 1) {
          return response; // return as http.Response
        }
      }

      return response; // Even if not 200, return the response for error handling
    } catch (e) {
      print("Upload error: $e");
      return null;
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
      debugPrint("API REQUEST BODY (UPDATE):----------------${jsonEncode(card.toJson())}");
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

  static Future deleteCard(cardId) async {
    try {
      var headers1 = {'Content-Type': 'application/json','Authorization': 'Bearer ${appStore.userData!.token}'};
      final response = await http.post(Uri.parse('${AppApiConst.cardDelete}${cardId}'), headers: headers1);

      debugPrint(
        "===============================-=-=-=-=-=-=>>>>>>>>>>>${response.body}",
      );
      debugPrint(
        "===============================-=-=-=-=-=-=>>>>>>>>>>>${response.statusCode}",
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print("this is the error ------------------>> $e");
      return {'success': 0, 'msg': e.toString()};
    }
  }

  static Future<bool> updateCardTagGroupNote(cardID,note,tagID,groupID) async {

    if (cardID == null) {
      debugPrint('Cannot Update cardid is null');
      return false;
    }

    // final url = Uri.parse(AppApiConst.cardupdate);
    var headers1 = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${appStore.userData!.token}'};

    final Map<String, dynamic> payload = {
      'cardid': cardID,
      'note': note??'',
    };

    if (tagID != null) {
      payload['tagid'] = tagID;
    }
    if (groupID != null) {
      payload['groupid'] = groupID;
    }

    var body1 = jsonEncode(payload);

    try {
      final response = await http.post(
        Uri.parse(AppApiConst.updateCardNoteTagGroup),
        headers: headers1,
        body: body1,
      );
      debugPrint("API URL (UPDATE): ${AppApiConst.updateCardNoteTagGroup}");
      debugPrint("API STATUSCODE (UPDATE): ${response.statusCode}");
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
}
