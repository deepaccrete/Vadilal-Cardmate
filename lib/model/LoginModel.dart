class LoginModel {
  int? success;
  String? msg;
  UserData? userData;

  LoginModel({this.success, this.msg, this.userData});

  LoginModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    msg = json['msg'];
    userData = json['userData'] != null
        ? new UserData.fromJson(json['userData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['msg'] = this.msg;
    if (this.userData != null) {
      data['userData'] = this.userData!.toJson();
    }
    return data;
  }
}

class UserData {
  int? userid;
  String? firstname;
  String? lastname;
  String? email;
  int? roleid;
  String? rolename;
  String? designation;
  String? phoneno;
  String? token;

  UserData(
      {this.userid,
        this.firstname,
        this.lastname,
        this.email,
        this.roleid,
        this.rolename,
        this.designation,
        this.phoneno,
        this.token});

  UserData.fromJson(Map<String, dynamic> json) {
    userid = json['userid'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    roleid = json['roleid'];
    rolename = json['rolename'];
    designation = json['designation'];
    phoneno = json['phoneno'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userid'] = this.userid;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['email'] = this.email;
    data['roleid'] = this.roleid;
    data['rolename'] = this.rolename;
    data['designation'] = this.designation;
    data['phoneno'] = this.phoneno;
    data['token'] = this.token;
    return data;
  }
}