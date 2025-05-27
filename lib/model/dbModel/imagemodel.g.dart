// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'imagemodel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PendingImageAdapter extends TypeAdapter<PendingImage> {
  @override
  final int typeId = 2;

  @override
  PendingImage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PendingImage(
      id: fields[0] as String,
      frontImage: fields[1] as String,
      backPath: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PendingImage obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.frontImage)
      ..writeByte(2)
      ..write(obj.backPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PendingImageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
