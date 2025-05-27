import'package:hive/hive.dart';
part 'cardDetailsModel.g.dart';

@HiveType(typeId: 1)

class CardDetails extends HiveObject{
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? fullname;

  @HiveField(2)
  String? designation;

  @HiveField(3)
  String? number;

  @HiveField(4)
  String? email;

  @HiveField(5)
  String? companyname;

  @HiveField(6)
  String? address;

  @HiveField(7)
  String? website;

  @HiveField(8)
  String? note;



  CardDetails({
     this.id,
     this.fullname,
     this.designation,
     this.number,
     this.email,
     this.companyname,
     this.address,
     this.website,
     this.note,
});

  CardDetails copyWith({
    String ? id,
    String ? fullname,
    String ? designation,
    String ? number,
    String ? email,
    String ? companyname,
    String ? address,
    String ? website,
    String ? note,
}){
    return CardDetails(
        id: id?? this.id,
        fullname: fullname?? this.fullname,
        designation: designation ?? this.designation,
        number: number ?? this.number,
        email: email ?? this.email,
        companyname: companyname ?? this.companyname,
        address: address ?? this.address,
        website: website ?? this .website,
        note: note ?? this.note
    );
  }

  factory CardDetails.fromMap(Map<String , dynamic> map){
    return CardDetails(id: map['id'],
        fullname: map['fullname'],
        designation: map['designation'],
        number: map['number'],
        email: map['email'],
        companyname: map['comapanyname'],
        address: map['address'],
        website: map['website'],
        note:map['note']
    );
  }


}