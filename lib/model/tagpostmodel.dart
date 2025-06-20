class TagPostModel {
  int? success;
  String ? msg;

  TagPostModel({this.success});

  TagPostModel.fromJson(Map<String, dynamic> json) {
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
