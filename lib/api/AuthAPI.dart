import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/LoginModel.dart';
import '../util/const.dart';

class AuthApi {



  static Future<LoginModel> login({required String email,required String password}) async {
    try{
      print("================-=-=-=-==-=-=>>>>>>>  we are here");
      var headers1 = {'Content-Type': 'application/json'};
      var body1 = jsonEncode(<String, dynamic>{
        "email":email,
        "password":password,
      });

      print("body of $body1");
      final response = await http.post(
        Uri.parse("${AppApiConst.login}"),
        headers: headers1,
        body: body1,
      );
      print(AppApiConst.login);
      print("================-=-=-=-==-=-=>>>>>>>${response.body}");
      print("================-=-=-=-==-=-=>>>>>>>${response.statusCode}");
      if (response.statusCode == 200) {
        return LoginModel.fromJson(jsonDecode(response.body));
      } else {
        return LoginModel.fromJson(jsonDecode(response.body));
      }
    }catch (e){
      print("-=------------------------------------------->> $e");
      return LoginModel(msg: "Login Error",success: 0);
    }

  }
}
