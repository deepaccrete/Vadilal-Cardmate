class AppApiConst {
  ///API
  //Local URL
  // static String baseUrl = "http://192.168.120.144:8002/api/v1";

  //OLD EC2(Dyn Forms & EasyCard) Live URL
  // static String baseUrl = "http://Vadilal-QC-Server-NLB-7c5300d13cc148cf.elb.ap-south-1.amazonaws.com:8001/api/v1";

  //Live URL
  static String baseUrl = "https://Vadilal-Easy-Card-IB-Server-ALB-542786463.ap-south-1.elb.amazonaws.com:8001/api/v1";

  ///Login
  static String login = '$baseUrl/auth/login';

  //   group
  static String groupget = '$baseUrl/group/getgroup';
  static String tagget = '$baseUrl/tag/gettag';
  static String imageupload = '$baseUrl/card/uploadcard';
  static String cardget = '$baseUrl/card/getcardlists';
  static String GroupPost = '$baseUrl/group/insertgroup';
  static String TagPost = '$baseUrl/tag/inserttag';
  static String cardupdate = '$baseUrl/card/updatecard';
  static String addCardManually='$baseUrl/card/savecard';
  //Delete Card
  static String cardDelete = '$baseUrl/card/deleteCard/';
  //Update Card Note Group and tag
  static String updateCardNoteTagGroup = '$baseUrl/card/updateCardTagGroupNote';
}

const IS_LOGGED_IN = 'IS_LOGGED_IN';
const TOKEN = "TOKEN";
const USER_DETAIL = 'USER_DETAIL';
const APP_SETTING = 'APP_SETTING';
const Remember_Me_Key = 'Remember_Me_Key';
const Saved_Email = 'Saved_Email';
const Saved_Password = 'Saved_Password';
