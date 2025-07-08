import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:ffi';
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
  bool isRememberMe = false;


  @observable
  String? email;

  @observable
  String? password;

  @observable
   bool? isShowAdd;

  @observable
   bool? isShowShare;

  @observable
  bool? isShowEdit;

  @observable
  bool? isShowDelete;

  @observable
  bool? isShowGroup;

  @observable
  bool? isShowTag;

@observable
  bool isShowButtons = false;





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



  @action
  void setIsAdd(getIsAdd){
    isShowAdd = getIsAdd;
  }

  @action
  void setIsShare(getIsShare){
    isShowShare = getIsShare;
  }
  @action
  void setIsEdit(getIsEdit){
    isShowEdit = getIsEdit;
  }
  @action
  void setIsDelete(getIsDelete){
    isShowDelete = getIsDelete;
  }
  @action
  void setIsGroup(getIsGroup){
    isShowGroup = getIsGroup;
  }
  @action
  void setIsTag(getIsTag){
    isShowTag= getIsTag;
  }

 @action
  void setButtons(getISShowButtons){
    isShowButtons = getISShowButtons;
 }



}
