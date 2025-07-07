import 'dart:convert';
import 'dart:io';

import 'package:camera_app/model/cardModel.dart';
import 'package:camera_app/util/const.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

import 'dart:io';
import 'package:camera_app/util/const.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

import '../main.dart';

class ImageuploadApi {

  static Future uploadImage({
    required File frontImage,
    File? backImage,
  }) async {
    final uri = Uri.parse(AppApiConst.imageupload);

    //  header with Bearer token
    final headers = {
      'Authorization': 'Bearer ${appStore.userData!.token}',
      'Accept': 'application/json',
    };

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
        await http.MultipartFile.fromPath(
          'images',
          backImage.path,
          filename: basename(backImage.path),
        ),
      );
    }

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        // final responseBody = await response.stream.bytesToString();
        // final cardModel = CardModel.fromJson(jsonDecode(responseBody));
        // if(cardModel.success == 1 && cardModel.data != null && cardModel.data!.isNotEmpty){
        //   print('API Success : DataCard object extracted');
        //   // return cardModel.data![0];
        // }

        final responseBody = await response.stream.bytesToString();
        final json = jsonDecode(responseBody);
        // print(' Uploaded Json: $json');
        print(" Image uploaded successfully to API");
        print("==========>>>>>>>>>>>>>>>>>>>>>${AppApiConst.imageupload}");
        print("==========>>>>>>>>>>>>>>>>>>>>>${response.statusCode}");
        if(json['success']==1){
          return json;
        }
        // return true;
      } else {
        print(" Upload failed: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print(" Upload error: $e");
      return null;
    }
  }
}
