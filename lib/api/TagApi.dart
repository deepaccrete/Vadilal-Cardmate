import 'dart:convert';

import 'package:camera_app/model/TagModel.dart';
import 'package:camera_app/model/tagpostmodel.dart';
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


  static Future<TagPostModel> PostTag ({required String tagname})async{
    try{
      var headers1 = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${appStore.userData!.token}'};


      var body = jsonEncode(<String , dynamic>{
        "tagname": tagname
      });
      print("body of${body}");

      final response = await http.post(Uri.parse("${AppApiConst.TagPost}"),
      body: body,
        headers: headers1
      );
      print(AppApiConst.GroupPost);
      print("=====================.=.=.=.=.=.=.== ${response.body}");
      print("=======================.=.=.======..${response.statusCode}");
      if(response.statusCode == 200){
        return TagPostModel.fromJson(jsonDecode(response.body));
      }else{
        return TagPostModel.fromJson(jsonDecode(response.body));
      }
    }catch(e){
      print("==================$e");
      return TagPostModel(success: 0);
    }



  }


}
