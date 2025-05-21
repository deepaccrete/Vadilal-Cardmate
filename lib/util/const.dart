class AppApiConst {
  ///API

  static String baseUrl = "http://192.168.120.144:8002/api/v1";

  ///Login
  static String login = '$baseUrl/auth/login';

//   group
static String groupget = '$baseUrl/group/getgroup';
static String tagget = '$baseUrl/tag/gettag';
static String imageupload = '$baseUrl/card/uploadcard';
}

const IS_LOGGED_IN = 'IS_LOGGED_IN';
const TOKEN = "TOKEN";
const USER_DETAIL= 'USER_DETAIL';
