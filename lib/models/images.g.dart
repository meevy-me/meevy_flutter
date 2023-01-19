// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'images.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProfileImagesAdapter extends TypeAdapter<ProfileImages> {
  @override
  final int typeId = 2;

  @override
  ProfileImages read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProfileImages(
      image: fields[2] as String,
      id: fields[0] as int,
      isDefault: fields[1] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ProfileImages obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.isDefault)
      ..writeByte(2)
      ..write(obj.image);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileImagesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
