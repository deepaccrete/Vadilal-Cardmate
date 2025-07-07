class AppApiConst {
  ///API

  static String baseUrl = "http://192.168.120.144:8002/api/v1";

  ///Login
  static String login = '$baseUrl/auth/login';

//   group
static String groupget = '$baseUrl/group/getgroup';
static String tagget = '$baseUrl/tag/gettag';
static String imageupload = '$baseUrl/card/uploadcard';
static String cardget = '$baseUrl/card/getcardlists';
static String GroupPost = '$baseUrl/group/insertgroup';
static String TagPost = '$baseUrl/tag/inserttag';
}

const IS_LOGGED_IN = 'IS_LOGGED_IN';
const TOKEN = "TOKEN";
const USER_DETAIL= 'USER_DETAIL';
const Remember_Me_Key = 'Remember_Me_Key';
const Saved_Email = 'Saved_Email';
const Saved_Password = 'Saved_Password';
