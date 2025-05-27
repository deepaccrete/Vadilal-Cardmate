// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cardDetailsModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CardDetailsAdapter extends TypeAdapter<CardDetails> {
  @override
  final int typeId = 1;

  @override
  CardDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CardDetails(
      id: fields[0] as String?,
      fullname: fields[1] as String?,
      designation: fields[2] as String?,
      number: fields[3] as String?,
      email: fields[4] as String?,
      companyname: fields[5] as String?,
      address: fields[6] as String?,
      website: fields[7] as String?,
      note: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CardDetails obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fullname)
      ..writeByte(2)
      ..write(obj.designation)
      ..writeByte(3)
      ..write(obj.number)
      ..writeByte(4)
      ..write(obj.email)
      ..writeByte(5)
      ..write(obj.companyname)
      ..writeByte(6)
      ..write(obj.address)
      ..writeByte(7)
      ..write(obj.website)
      ..writeByte(8)
      ..write(obj.note);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CardDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
