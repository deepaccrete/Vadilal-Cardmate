class GroupModel {
  int? success;
  List<Data>? data;

  GroupModel({this.success, this.data});

  GroupModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? groupid;
  String? groupname;

  Data({this.groupid, this.groupname});

  Data.fromJson(Map<String, dynamic> json) {
    groupid = json['groupid'];
    groupname = json['groupname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['groupid'] = this.groupid;
    data['groupname'] = this.groupname;
    return data;
  }
}
