class TagModel {
  int? success;
  List<Datatag>? data;

  TagModel({this.success, this.data});

  TagModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Datatag>[];
      json['data'].forEach((v) {
        data!.add(new Datatag.fromJson(v));
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

class Datatag {
  int? tagid;
  String? tagname;

  Datatag({this.tagid, this.tagname});

  Datatag.fromJson(Map<String, dynamic> json) {
    tagid = json['tagid'];
    tagname = json['tagname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tagid'] = this.tagid;
    data['tagname'] = this.tagname;
    return data;
  }
}
