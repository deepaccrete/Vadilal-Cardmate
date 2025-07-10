// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AppStore on _AppStore, Store {
  late final _$isLoggedInAtom =
      Atom(name: '_AppStore.isLoggedIn', context: context);

  @override
  bool get isLoggedIn {
    _$isLoggedInAtom.reportRead();
    return super.isLoggedIn;
  }

  @override
  set isLoggedIn(bool value) {
    _$isLoggedInAtom.reportWrite(value, super.isLoggedIn, () {
      super.isLoggedIn = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_AppStore.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$userTokenAtom =
      Atom(name: '_AppStore.userToken', context: context);

  @override
  String? get userToken {
    _$userTokenAtom.reportRead();
    return super.userToken;
  }

  @override
  set userToken(String? value) {
    _$userTokenAtom.reportWrite(value, super.userToken, () {
      super.userToken = value;
    });
  }

  late final _$userDataAtom =
      Atom(name: '_AppStore.userData', context: context);

  @override
  UserData? get userData {
    _$userDataAtom.reportRead();
    return super.userData;
  }

  @override
  set userData(UserData? value) {
    _$userDataAtom.reportWrite(value, super.userData, () {
      super.userData = value;
    });
  }

  late final _$appSettingAtom =
      Atom(name: '_AppStore.appSetting', context: context);

  @override
  AppSetting? get appSetting {
    _$appSettingAtom.reportRead();
    return super.appSetting;
  }

  @override
  set appSetting(AppSetting? value) {
    _$appSettingAtom.reportWrite(value, super.appSetting, () {
      super.appSetting = value;
    });
  }

  late final _$isRememberMeAtom =
      Atom(name: '_AppStore.isRememberMe', context: context);

  @override
  bool get isRememberMe {
    _$isRememberMeAtom.reportRead();
    return super.isRememberMe;
  }

  @override
  set isRememberMe(bool value) {
    _$isRememberMeAtom.reportWrite(value, super.isRememberMe, () {
      super.isRememberMe = value;
    });
  }

  late final _$emailAtom = Atom(name: '_AppStore.email', context: context);

  @override
  String? get email {
    _$emailAtom.reportRead();
    return super.email;
  }

  @override
  set email(String? value) {
    _$emailAtom.reportWrite(value, super.email, () {
      super.email = value;
    });
  }

  late final _$passwordAtom =
      Atom(name: '_AppStore.password', context: context);

  @override
  String? get password {
    _$passwordAtom.reportRead();
    return super.password;
  }

  @override
  set password(String? value) {
    _$passwordAtom.reportWrite(value, super.password, () {
      super.password = value;
    });
  }

  late final _$_AppStoreActionController =
      ActionController(name: '_AppStore', context: context);

  @override
  void setIsLoading(dynamic getIsLoading) {
    final _$actionInfo =
        _$_AppStoreActionController.startAction(name: '_AppStore.setIsLoading');
    try {
      return super.setIsLoading(getIsLoading);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setIsLogin(dynamic getIsLOGIN) {
    final _$actionInfo =
        _$_AppStoreActionController.startAction(name: '_AppStore.setIsLogin');
    try {
      return super.setIsLogin(getIsLOGIN);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setUserToken(dynamic getIsUserToken) {
    final _$actionInfo =
        _$_AppStoreActionController.startAction(name: '_AppStore.setUserToken');
    try {
      return super.setUserToken(getIsUserToken);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setUser(dynamic getUser) {
    final _$actionInfo =
        _$_AppStoreActionController.startAction(name: '_AppStore.setUser');
    try {
      return super.setUser(getUser);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setAppSetting(dynamic getAppSetting) {
    final _$actionInfo = _$_AppStoreActionController.startAction(
        name: '_AppStore.setAppSetting');
    try {
      return super.setAppSetting(getAppSetting);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setIsRememberMe(dynamic getRememberme) {
    final _$actionInfo = _$_AppStoreActionController.startAction(
        name: '_AppStore.setIsRememberMe');
    try {
      return super.setIsRememberMe(getRememberme);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setEmail(dynamic getEmail) {
    final _$actionInfo =
        _$_AppStoreActionController.startAction(name: '_AppStore.setEmail');
    try {
      return super.setEmail(getEmail);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPassword(dynamic getPassword) {
    final _$actionInfo =
        _$_AppStoreActionController.startAction(name: '_AppStore.setPassword');
    try {
      return super.setPassword(getPassword);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoggedIn: ${isLoggedIn},
isLoading: ${isLoading},
userToken: ${userToken},
userData: ${userData},
appSetting: ${appSetting},
isRememberMe: ${isRememberMe},
email: ${email},
password: ${password}
    ''';
  }
}
