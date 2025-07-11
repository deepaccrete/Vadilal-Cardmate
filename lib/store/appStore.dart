import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/LoginModel.dart';
part 'appStore.g.dart';


class AppStore = _AppStore with _$AppStore;

// The store-class
abstract class _AppStore with Store {
  @observable
  bool isLoggedIn = false;

  @observable
  bool isLoading = false;

  @observable
  String? userToken = '';

  @observable
  UserData? userData;

  @observable
  AppSetting? appSetting;

  @observable
  bool isRememberMe = false;


  @observable
  String? email;

  @observable
  String? password;

  @action
  void setIsLoading(getIsLoading) {
    isLoading = getIsLoading;
  }

  @action
  void setIsLogin(getIsLOGIN) {
    isLoggedIn = getIsLOGIN;
  }

  @action
  void setUserToken(getIsUserToken) {
    userToken = getIsUserToken;
  }

  @action
  void setUser(getUser) {
    userData = getUser;
  }

  @action
  void setAppSetting(getAppSetting) {
    appSetting = getAppSetting;
  }

  @action
  void setIsRememberMe (getRememberme){
    isRememberMe = getRememberme;
  }

  @action
  void setEmail(getEmail){
    email = getEmail;
  }

  @action
  void setPassword(getPassword){
    password = getPassword;
  }
}
