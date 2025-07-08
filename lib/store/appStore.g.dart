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

  late final _$isShowAddAtom =
      Atom(name: '_AppStore.isShowAdd', context: context);

  @override
  bool? get isShowAdd {
    _$isShowAddAtom.reportRead();
    return super.isShowAdd;
  }

  @override
  set isShowAdd(bool? value) {
    _$isShowAddAtom.reportWrite(value, super.isShowAdd, () {
      super.isShowAdd = value;
    });
  }

  late final _$isShowShareAtom =
      Atom(name: '_AppStore.isShowShare', context: context);

  @override
  bool? get isShowShare {
    _$isShowShareAtom.reportRead();
    return super.isShowShare;
  }

  @override
  set isShowShare(bool? value) {
    _$isShowShareAtom.reportWrite(value, super.isShowShare, () {
      super.isShowShare = value;
    });
  }

  late final _$isShowEditAtom =
      Atom(name: '_AppStore.isShowEdit', context: context);

  @override
  bool? get isShowEdit {
    _$isShowEditAtom.reportRead();
    return super.isShowEdit;
  }

  @override
  set isShowEdit(bool? value) {
    _$isShowEditAtom.reportWrite(value, super.isShowEdit, () {
      super.isShowEdit = value;
    });
  }

  late final _$isShowDeleteAtom =
      Atom(name: '_AppStore.isShowDelete', context: context);

  @override
  bool? get isShowDelete {
    _$isShowDeleteAtom.reportRead();
    return super.isShowDelete;
  }

  @override
  set isShowDelete(bool? value) {
    _$isShowDeleteAtom.reportWrite(value, super.isShowDelete, () {
      super.isShowDelete = value;
    });
  }

  late final _$isShowGroupAtom =
      Atom(name: '_AppStore.isShowGroup', context: context);

  @override
  bool? get isShowGroup {
    _$isShowGroupAtom.reportRead();
    return super.isShowGroup;
  }

  @override
  set isShowGroup(bool? value) {
    _$isShowGroupAtom.reportWrite(value, super.isShowGroup, () {
      super.isShowGroup = value;
    });
  }

  late final _$isShowTagAtom =
      Atom(name: '_AppStore.isShowTag', context: context);

  @override
  bool? get isShowTag {
    _$isShowTagAtom.reportRead();
    return super.isShowTag;
  }

  @override
  set isShowTag(bool? value) {
    _$isShowTagAtom.reportWrite(value, super.isShowTag, () {
      super.isShowTag = value;
    });
  }

  late final _$isShowButtonsAtom =
      Atom(name: '_AppStore.isShowButtons', context: context);

  @override
  bool get isShowButtons {
    _$isShowButtonsAtom.reportRead();
    return super.isShowButtons;
  }

  @override
  set isShowButtons(bool value) {
    _$isShowButtonsAtom.reportWrite(value, super.isShowButtons, () {
      super.isShowButtons = value;
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
  void setIsAdd(dynamic getIsAdd) {
    final _$actionInfo =
        _$_AppStoreActionController.startAction(name: '_AppStore.setIsAdd');
    try {
      return super.setIsAdd(getIsAdd);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setIsShare(dynamic getIsShare) {
    final _$actionInfo =
        _$_AppStoreActionController.startAction(name: '_AppStore.setIsShare');
    try {
      return super.setIsShare(getIsShare);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setIsEdit(dynamic getIsEdit) {
    final _$actionInfo =
        _$_AppStoreActionController.startAction(name: '_AppStore.setIsEdit');
    try {
      return super.setIsEdit(getIsEdit);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setIsDelete(dynamic getIsDelete) {
    final _$actionInfo =
        _$_AppStoreActionController.startAction(name: '_AppStore.setIsDelete');
    try {
      return super.setIsDelete(getIsDelete);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setIsGroup(dynamic getIsGroup) {
    final _$actionInfo =
        _$_AppStoreActionController.startAction(name: '_AppStore.setIsGroup');
    try {
      return super.setIsGroup(getIsGroup);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setIsTag(dynamic getIsTag) {
    final _$actionInfo =
        _$_AppStoreActionController.startAction(name: '_AppStore.setIsTag');
    try {
      return super.setIsTag(getIsTag);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setButtons(dynamic getISShowButtons) {
    final _$actionInfo =
        _$_AppStoreActionController.startAction(name: '_AppStore.setButtons');
    try {
      return super.setButtons(getISShowButtons);
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
isRememberMe: ${isRememberMe},
email: ${email},
password: ${password},
isShowAdd: ${isShowAdd},
isShowShare: ${isShowShare},
isShowEdit: ${isShowEdit},
isShowDelete: ${isShowDelete},
isShowGroup: ${isShowGroup},
isShowTag: ${isShowTag},
isShowButtons: ${isShowButtons}
    ''';
  }
}
