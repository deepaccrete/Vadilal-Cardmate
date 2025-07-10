import 'dart:convert'; // For jsonEncode, etc.

class CardModel {
  int? success;
  List<DataCard>? data;
  String? message; // Added for error messages from API response

  CardModel({this.success, this.data, this.message});

  // Used for parsing API responses that return a list of cards (e.g., getCard)
  CardModel.fromJson(Map<String, dynamic> json) {
    success = json['success'] as int?;
    message = json['msg']?.toString(); // Assuming 'msg' for messages

    if (json['data'] != null && json['data'] is List) {
      data = <DataCard>[];
      json['data'].forEach((v) {
        data!.add(DataCard.fromJson(v as Map<String, dynamic>));
      });
    } else {
      data = []; // Ensure data is never null
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['msg'] = message; // Include message in toJson if needed for some reason
    return data;
  }
}

class DataCard {
  int? cardID;
  String? companyName;
  List<PersonDetails>? personDetails;
  String? companyPhoneNumber;
  List<String>? companyAddress; // Stored as List<String> in Dart
  String? companyEmail;
  String? webAddress;
  String? companySWorkDetails; // Corrected property name for Dart
  String? gSTIN;
  String? cardFrontImageBase64;
  String? cardBackImageBase64;
  int? createdBy;
  String? createdAt;
  String? extractedJSON;
  int? isBase64;

  int? tag_id;   // Matches API: "Tag ID"
  int? group_id; // Matches API: "Group ID"

  DataCard({
    this.cardID,
    this.companyName,
    this.personDetails,
    this.companyPhoneNumber,
    this.companyAddress,
    this.companyEmail,
    this.webAddress,
    this.companySWorkDetails,
    this.gSTIN,
    this.cardFrontImageBase64,
    this.cardBackImageBase64,
    this.createdBy,
    this.createdAt,
    this.extractedJSON,
    this.isBase64,
    this.tag_id,
    this.group_id,
  });

  // Used for parsing incoming JSON from API responses (e.g., for getCard)
  factory DataCard.fromJson(Map<String, dynamic> json) {
    // Note: The keys here must match what your API sends IN ITS RESPONSES
    return DataCard(
      cardID: json['Card ID'] as int?,
      companyName: json['Company Name']?.toString(),

      personDetails: (json['Person details'] is List)
          ? (json['Person details'] as List)
          .map((v) => PersonDetails.fromJson(v as Map<String, dynamic>))
          .toList()
          : [],

      companyPhoneNumber: json['Company Phone Number']?.toString(),

      // Robustly handle Company Address coming as String or List
      companyAddress: (json['Company Address'] is List)
          ? (json['Company Address'] as List)
          .map((e) => e?.toString() ?? '')
          .toList()
          : (json['Company Address'] is String)
          ? (json['Company Address'] as String)
          .split(RegExp(r'[\n\r]+')) // Split by one or more newlines/carriage returns
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty) // Filter out empty strings
          .toList()
          : [],

      companyEmail: json['Company  Email']?.toString(), // Keep double space if API sends it
      webAddress: json['Web Address']?.toString(),

      // Handling potential variations for 'Companys Work Details' or 'Company's Work Details'
      companySWorkDetails: json['Companys Work Details']?.toString() ?? json['Company\'s Work Details']?.toString(),

      gSTIN: json['GSTIN']?.toString(),
      cardFrontImageBase64: json['Card Front Image']?.toString(),
      cardBackImageBase64: json['Card Back Image']?.toString(),
      createdBy: json['Created By'] as int?,
      createdAt: json['Created At']?.toString(),
      extractedJSON: json['Extracted JSON']?.toString(),
      isBase64: json['Is Base64'] as int?,

      // Use "Group ID" and "Tag ID" as seen in your incoming JSON
      group_id: json['Group ID'] is int ? json['Group ID'] : (json['Group ID'] is String ? int.tryParse(json['Group ID']) : null),
      tag_id: json['Tag ID'] is int ? json['Tag ID'] : (json['Tag ID'] is String ? int.tryParse(json['Tag ID']) : null),
    );
  }

  // Used for sending JSON to the API (e.g., for createCard, updateCard)
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // The keys here MUST EXACTLY match what your UPDATE API expects
    data['Card ID'] = cardID;
    data['Group ID'] = group_id; // Matches API's "Group ID"
    data['Tag ID'] = tag_id;     // Matches API's "Tag ID"
    data['Company Name'] = companyName;
    if (personDetails != null) {
      data['Person details'] = personDetails!.map((v) => v.toJson()).toList();
    }
    data['Company Phone Number'] = companyPhoneNumber;
    // CRITICAL FIX: Join companyAddress list into a single string for the API
    data['Company Address'] = companyAddress?.join(', '); // Send as single string
    data['Company  Email'] = companyEmail; // Preserve double space
    data['Web Address'] = webAddress;
    data['Companys Work Details'] = companySWorkDetails; // Matches API's "Companys Work Details"
    data['GSTIN'] = gSTIN;
    data['Card Front Image'] = cardFrontImageBase64; // Matches API's "Card Front Image"
    data['Card Back Image'] = cardBackImageBase64;   // Matches API's "Card Back Image"
    data['Created By'] = createdBy;
    data['Created At'] = createdAt;
    data['Extracted JSON'] = extractedJSON;
    data['Is Base64'] = isBase64;
    return data;
  }

  // Your toShareString and helper methods are great and remain unchanged.
  String toShareString() {
    final StringBuffer buffer = StringBuffer();

    buffer.writeln('--- Business Card Details ---');
    buffer.writeln(''); // Blank line for spacing

    // Add Company Details
    _addDetail(buffer, 'Company Name', companyName);
    _addDetail(buffer, 'Work Details', companySWorkDetails);
    _addDetailList(buffer, 'Company Address', companyAddress, separator: '\n'); // Use newline for addresses
    _addDetail(buffer, 'Company Phone', companyPhoneNumber);
    _addDetail(buffer, 'Company Email', companyEmail);
    _addDetail(buffer, 'Web Address', webAddress);
    _addDetail(buffer, 'GSTIN', gSTIN);

    // Add Person Details
    if (personDetails != null && personDetails!.isNotEmpty) {
      buffer.writeln('\n--- Contact Persons ---');
      for (var i = 0; i < personDetails!.length; i++) {
        final person = personDetails![i];
        buffer.writeln('\nPerson ${i + 1}:');
        _addDetail(buffer, '  Name', person.name);
        _addDetail(buffer, '  Position', person.position);
        _addDetail(buffer, '  Phone', person.phoneNumber);
        _addDetail(buffer, '  Email', person.email);
      }
    }

    buffer.writeln('\n--- End of Details ---');
    return buffer.toString();
  }

  void _addDetail(StringBuffer buffer, String label, String? value) {
    if (value != null && value.isNotEmpty && value.toLowerCase() != 'null') {
      buffer.writeln('$label: $value');
    }
  }

  void _addDetailList(StringBuffer buffer, String label, List<String>? values, {String separator = ', '}) {
    if (values != null && values.isNotEmpty) {
      final filteredValues = values.where((e) => e.isNotEmpty && e.toLowerCase() != 'null').toList();
      if (filteredValues.isNotEmpty) {
        buffer.writeln('$label: ${filteredValues.join(separator)}');
      }
    }
  }
}

class PersonDetails {
  int? cardpersonsid;
  String? name;
  String? phoneNumber;
  String? email;
  String? position;

  PersonDetails({this.name, this.phoneNumber, this.email, this.position, this.cardpersonsid});

  // Used for parsing incoming JSON for person details
  factory PersonDetails.fromJson(Map<String, dynamic> json) {
    // Keys here must match what the API sends for person details
    return PersonDetails(
      cardpersonsid: json['cardpersonsid'] as int?,
      name: json['Name']?.toString(),
      phoneNumber: json['Phone Number']?.toString(),
      email: json['Email']?.toString(),
      position: json['Position']?.toString(),
    );
  }

  // Used for sending JSON for person details to the API
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // Keys here must EXACTLY match what the API expects for person details in the update payload
    data['cardpersonsid'] = cardpersonsid;
    data['Name'] = name;
    data['Phone Number'] = phoneNumber;
    data['Email'] = email;
    data['Position'] = position;
    return data;
  }
}
//
// class CardModel {
//   int? success;
//   List<DataCard>? data;
//
//   CardModel({this.success, this.data});
//
//   CardModel.fromJson(Map<String, dynamic> json) {
//     success = json['success'];
//     if (json['data'] != null) {
//       data = <DataCard>[];
//       json['data'].forEach((v) { data!.add(new DataCard.fromJson(v)); });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['success'] = this.success;
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class DataCard {
//   int? cardID;
//   String? companyName;
//   List<PersonDetails>? personDetails;
//   String? companyPhoneNumber;
//   List<String>? companyAddress;
//   String? companyEmail;
//   String? webAddress;
//   String? companySWorkDetails;
//   String? gSTIN;
//   String? cardFrontImageBase64;
//   String? cardBackImageBase64;
//   int? createdBy;
//   String? createdAt;
//   String? extractedJSON;
//   int? isBase64;
//
//   DataCard({this.cardID, this.companyName, this.personDetails, this.companyPhoneNumber, this.companyAddress, this.companyEmail, this.webAddress, this.companySWorkDetails, this.gSTIN, this.cardFrontImageBase64, this.cardBackImageBase64, this.createdBy, this.createdAt, this.extractedJSON, this.isBase64});
//
//   DataCard.fromJson(Map<String, dynamic> json) {
//     cardID = json['Card ID'];
//     companyName = json['Company Name']?.toString();
//     if (json['Person details'] != null) {
//       personDetails = <PersonDetails>[];
//       json['Person details'].forEach((v) {
//         personDetails!.add(PersonDetails.fromJson(v));
//       });
//     }
//     companyPhoneNumber = json['Company Phone Number']?.toString();
//     companyAddress = (json['Company Address'] as List?)?.map((e) => e?.toString() ?? '').toList();
//     companyEmail = json['Company  Email']?.toString();
//     webAddress = json['Web Address']?.toString();
//     companySWorkDetails = json['Companys Work Details']?.toString();
//     gSTIN = json['GSTIN']?.toString();
//     cardFrontImageBase64 = json['Card Front Image']?.toString();
//     cardBackImageBase64 = json['Card Back Image']?.toString();
//     createdBy = json['Created By'];
//     createdAt = json['Created At']?.toString();
//     extractedJSON = json['Extracted JSON']?.toString();
//     isBase64 = json['Is Base64'];
//   }
//
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['Card ID'] = this.cardID;
//     data['Company Name'] = this.companyName;
//     if (this.personDetails != null) {
//       data['Person details'] = this.personDetails!.map((v) => v.toJson()).toList();
//     }
//     data['Company Phone Number'] = this.companyPhoneNumber;
//     data['Company Address'] = this.companyAddress;
//     data['Company  Email'] = this.companyEmail;
//     data['Web Address'] = this.webAddress;
//     data['Company s Work Details'] = this.companySWorkDetails;
//     data['GSTIN'] = this.gSTIN;
//     data['Card Front Image Base64'] = this.cardFrontImageBase64;
//     data['Card Back Image Base64'] = this.cardBackImageBase64;
//     data['Created By'] = this.createdBy;
//     data['Created At'] = this.createdAt;
//     data['Extracted JSON'] = this.extractedJSON;
//     data['Is Base64']= this.isBase64;
//     return data;
//   }
// }
//
//
// class PersonDetails {
//   String? name;
//   String? phoneNumber;
//   String? email;
//   String? position;
//
//   PersonDetails({this.name, this.phoneNumber, this.email, this.position});
//
//   PersonDetails.fromJson(Map<String, dynamic> json) {
//     name = json['Name'];
//     phoneNumber = json['Phone Number'];
//     email = json['Email'];
//     position = json['Position'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['Name'] = this.name;
//     data['Phone Number'] = this.phoneNumber;
//     data['Email'] = this.email;
//     data['Position'] = this.position;
//     return data;
//   }
// }
