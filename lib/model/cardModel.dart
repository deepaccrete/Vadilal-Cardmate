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
  String? companySWorkDetails; // Corrected from 'Companys Work Details' for consistency
  String? gSTIN;
  String? cardFrontImageBase64;
  String? cardBackImageBase64;
  int? createdBy;
  String? createdAt;
  String? extractedJSON;
  int? isBase64;

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
  });

  DataCard.fromJson(Map<String, dynamic> json) {
    cardID = json['Card ID'] as int?;
    companyName = json['Company Name']?.toString();

    // Handle 'Person details' - ensure it's a list and map correctly
    if (json['Person details'] is List) {
      personDetails = (json['Person details'] as List)
          .map((v) => PersonDetails.fromJson(v as Map<String, dynamic>))
          .toList();
    } else {
      personDetails = []; // Initialize as empty list if not present or not a list
    }

    companyPhoneNumber = json['Company Phone Number']?.toString();

    // Handle 'Company Address' - it could be a single string or a list of strings
    if (json['Company Address'] is List) {
      companyAddress = (json['Company Address'] as List)
          .map((e) => e?.toString() ?? '')
          .toList();
    } else if (json['Company Address'] is String) {
      // If it's a single string, split it by newline characters
      companyAddress = (json['Company Address'] as String)
          .split(RegExp(r'[\n\r]+')) // Split by one or more newlines/carriage returns
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty) // Filter out empty strings from splitting
          .toList();
    } else {
      companyAddress = []; // Initialize as empty list
    }

    // Notice the double space in 'Company  Email' from your JSON example
    companyEmail = json['Company  Email']?.toString();
    webAddress = json['Web Address']?.toString();

    // Key 'Companys Work Details' or 'Company\'s Work Details'
    // Using json['Companys Work Details'] from your `toJson` implies this key.
    // If your actual incoming JSON uses 'Company\'s Work Details', adjust accordingly:
    companySWorkDetails = json['Companys Work Details']?.toString() ?? json['Company\'s Work Details']?.toString();

    gSTIN = json['GSTIN']?.toString();
    cardFrontImageBase64 = json['Card Front Image']?.toString(); // Check if your JSON key includes "Base64"
    cardBackImageBase64 = json['Card Back Image']?.toString();   // Check if your JSON key includes "Base64"
    createdBy = json['Created By'] as int?;
    createdAt = json['Created At']?.toString();
    extractedJSON = json['Extracted JSON']?.toString();
    isBase64 = json['Is Base64'] as int?;
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
    data['Company  Email'] = this.companyEmail; // Retaining double space as per your json
    data['Web Address'] = this.webAddress;
    data['Companys Work Details'] = this.companySWorkDetails; // Retaining this key as per your toJson
    data['GSTIN'] = this.gSTIN;
    data['Card Front Image'] = this.cardFrontImageBase64; // Retaining this key as per your toJson
    data['Card Back Image'] = this.cardBackImageBase64;   // Retaining this key as per your toJson
    data['Created By'] = this.createdBy;
    data['Created At'] = this.createdAt;
    data['Extracted JSON'] = this.extractedJSON;
    data['Is Base64'] = this.isBase64;
    return data;
  }

  /// Generates a comprehensive string containing all relevant card details for sharing.
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

  // Helper method to add details to the buffer if not null, empty, or "null" string
  void _addDetail(StringBuffer buffer, String label, String? value) {
    if (value != null && value.isNotEmpty && value.toLowerCase() != 'null') {
      buffer.writeln('$label: $value');
    }
  }

  // Helper method to add list details to the buffer
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
  String? name;
  String? phoneNumber;
  String? email;
  String? position;

  PersonDetails({this.name, this.phoneNumber, this.email, this.position});

  PersonDetails.fromJson(Map<String, dynamic> json) {
    name = json['Name']?.toString();
    phoneNumber = json['Phone Number']?.toString();
    email = json['Email']?.toString();
    position = json['Position']?.toString();
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
