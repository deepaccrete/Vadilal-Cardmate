class AddManualCardModel {
  int? groupID;
  int? tagID;
  String? companyName;
  List<PersonDetails>? personDetails;
  String? companyPhoneNumber;
  String? companyAddress;
  String? companyEmail;
  String? webAddress;

  AddManualCardModel(
      {this.groupID,
        this.tagID,
        this.companyName,
        this.personDetails,
        this.companyPhoneNumber,
        this.companyAddress,
        this.companyEmail,
        this.webAddress});

  AddManualCardModel.fromJson(Map<String, dynamic> json) {
    groupID = json['Group ID'];
    tagID = json['Tag ID'];
    companyName = json['Company Name'];
    if (json['Person details'] != null) {
      personDetails = <PersonDetails>[];
      json['Person details'].forEach((v) {
        personDetails!.add(new PersonDetails.fromJson(v));
      });
    }
    companyPhoneNumber = json['Company Phone Number'];
    companyAddress = json['Company Address'];
    companyEmail = json['Company  Email'];
    webAddress = json['Web Address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Group ID'] = this.groupID;
    data['Tag ID'] = this.tagID;
    data['Company Name'] = this.companyName;
    if (this.personDetails != null) {
      data['Person details'] =
          this.personDetails!.map((v) => v.toJson()).toList();
    }
    data['Company Phone Number'] = this.companyPhoneNumber;
    data['Company Address'] = this.companyAddress;
    data['Company  Email'] = this.companyEmail;
    data['Web Address'] = this.webAddress;
    return data;
  }
}

class PersonDetails {
  String? name;
  String? phoneNumber;
  String? email;
  String? position;

  PersonDetails({this.name, this.phoneNumber, this.email, this.position});

  PersonDetails.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    phoneNumber = json['Phone Number'];
    email = json['Email'];
    position = json['Position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['Phone Number'] = this.phoneNumber;
    data['Email'] = this.email;
    data['Position'] = this.position;
    return data;
  }
}
