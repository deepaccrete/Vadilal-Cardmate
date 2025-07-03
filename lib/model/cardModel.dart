class CardModel {
  int? success;
  List<DataCard>? data;

  CardModel({this.success, this.data});

  CardModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <DataCard>[];
      json['data'].forEach((v) { data!.add(new DataCard.fromJson(v)); });
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

class DataCard {
  int? cardID;
  String? companyName;
  List<PersonDetails>? personDetails;
  String? companyPhoneNumber;
  List<String>? companyAddress;
  String? companyEmail;
  String? webAddress;
  String? companySWorkDetails;
  String? gSTIN;
  String? cardFrontImageBase64;
  String? cardBackImageBase64;
  int? createdBy;
  String? createdAt;
  String? extractedJSON;
  int? isBase64;

  DataCard({this.cardID, this.companyName, this.personDetails, this.companyPhoneNumber, this.companyAddress, this.companyEmail, this.webAddress, this.companySWorkDetails, this.gSTIN, this.cardFrontImageBase64, this.cardBackImageBase64, this.createdBy, this.createdAt, this.extractedJSON, this.isBase64});

  DataCard.fromJson(Map<String, dynamic> json) {
    cardID = json['Card ID'];
    companyName = json['Company Name']?.toString();
    if (json['Person details'] != null) {
      personDetails = <PersonDetails>[];
      json['Person details'].forEach((v) {
        personDetails!.add(PersonDetails.fromJson(v));
      });
    }
    companyPhoneNumber = json['Company Phone Number']?.toString();
    companyAddress = (json['Company Address'] as List?)?.map((e) => e?.toString() ?? '').toList();
    companyEmail = json['Company  Email']?.toString();
    webAddress = json['Web Address']?.toString();
    companySWorkDetails = json['Companys Work Details']?.toString();
    gSTIN = json['GSTIN']?.toString();
    cardFrontImageBase64 = json['Card Front Image']?.toString();
    cardBackImageBase64 = json['Card Back Image']?.toString();
    createdBy = json['Created By'];
    createdAt = json['Created At']?.toString();
    extractedJSON = json['Extracted JSON']?.toString();
    isBase64 = json['Is Base64'];
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Card ID'] = this.cardID;
    data['Company Name'] = this.companyName;
    if (this.personDetails != null) {
      data['Person details'] = this.personDetails!.map((v) => v.toJson()).toList();
    }
    data['Company Phone Number'] = this.companyPhoneNumber;
    data['Company Address'] = this.companyAddress;
    data['Company  Email'] = this.companyEmail;
    data['Web Address'] = this.webAddress;
    data['Company s Work Details'] = this.companySWorkDetails;
    data['GSTIN'] = this.gSTIN;
    data['Card Front Image Base64'] = this.cardFrontImageBase64;
    data['Card Back Image Base64'] = this.cardBackImageBase64;
    data['Created By'] = this.createdBy;
    data['Created At'] = this.createdAt;
    data['Extracted JSON'] = this.extractedJSON;
    data['Is Base64']= this.isBase64;
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
