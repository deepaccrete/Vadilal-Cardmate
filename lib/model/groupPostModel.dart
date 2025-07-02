class GroupPostModel {
  int? success;
  String ? msg;

  GroupPostModel({this.success});

  GroupPostModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['msg'] = msg;
    return data;
  }
}
