import 'dart:convert';

import 'package:camera_app/model/GroupModel.dart';
import 'package:camera_app/model/groupPostModel.dart';
import 'package:camera_app/util/const.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import 'package:http/http.dart' as http;
// //
// static Future<OfferListModel> getOfferList() async {
// // try{
// var headers1 = {
//   'Authorization': 'Bearer ${appStore.userDetails!.token}',
// };
//
// final response = await http.get(
// Uri.parse(AppApiConst.offerList),
// headers: headers1,
// );
// debugPrint("================-=-=-=-==-=-=>>>>>>>${AppApiConst.offerList}");
// debugPrint("================-=-=-=-==-=-=>>>>>>>${response.body}");
// debugPrint("================-=-=-=-==-=-=>>>>>>>${response.statusCode}");
// if (response.statusCode == 200) {
// return OfferListModel.fromJson(jsonDecode(response.body));
// } else {
// return OfferListModel.fromJson(jsonDecode(response.body));
// }
// // }catch (e){
// //   print("this is the eror -------------------->> $e");
// // }
// }

class GroupApi {
  static Future<GroupModel> getGroup() async {
    try {
      var headers1 = {'Authorization': 'Bearer ${appStore.userData!.token}'};

      final response = await http.get(
        Uri.parse(AppApiConst.groupget),
        headers: headers1,
      );

      debugPrint(
        "===============================-=-=-=-=-=-=>>>>>>>>>>>${AppApiConst.groupget}",
      );
      debugPrint(
        "===============================-=-=-=-=-=-=>>>>>>>>>>>${response.body}",
      );
      debugPrint(
        "===============================-=-=-=-=-=-=>>>>>>>>>>>${response.statusCode}",
      );

      if (response.statusCode == 200) {
        return GroupModel.fromJson(jsonDecode(response.body));
      } else {
        return GroupModel.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      print("this is the error ------------------>> $e");
      return GroupModel(success:  0 ,data: []);
    }
  }



static Future<GroupPostModel>postGrroup({required  String groupname})async{
    try{
      print("=========================================>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> We are here ");
      var headers1 = {
      'Content-Type': 'application/json',
        'Authorization': 'Bearer ${appStore.userData!.token}'};

      var body = jsonEncode(<String, dynamic>{
          "groupname":groupname,
      });
print("body of $body");
final response = await http.post(Uri.parse("${AppApiConst.GroupPost}"),
headers: headers1,
  body: body
);
print(AppApiConst.GroupPost);
  print("=====================.=.=.=.=.=.=.== ${response.body}");
  print("=======================.=.=.======..${response.statusCode}");
  if(response.statusCode == 200){
    return GroupPostModel.fromJson(jsonDecode(response.body));
  }  else{
   return GroupPostModel.fromJson(jsonDecode(response.body));
  }
    }catch(e){
      print("-----=======-----=======-$e--------------=======-=-=");
      return GroupPostModel(success: 0);
    }

}


// static Future<GroupPostModel> grouppost(String groupName)async{
//
//   try{
//
//     var header2 = {'Content-Type': 'application/json'};
//     var body = jsonEncode(<String , dynamic>{
//
//   "groupname":groupName
//   });
//
//     final response =await http.post(Uri.parse("{AppApiConst.GroupPost}"),
//     headers: header2,
//       body: body,
//     );
//
//     if(response.statusCode==200){
//       return GroupPostModel.fromJson(jsonDecode(response.body));
//     }else{
//       return GroupPostModel.fromJson(jsonDecode(jsonDecode(response.body)));
//     }
//   } catch(e){
// print(====........e);
// return GroupPostModel(success: 0);
//   }
//
//
//   }
//




}
