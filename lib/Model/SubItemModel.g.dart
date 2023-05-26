// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SubItemModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubItemModelAdapter extends TypeAdapter<SubItemModel> {
  @override
  final int typeId = 5;

  @override
  SubItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubItemModel(
      title: fields[1] as String,
      price: fields[2] as int,
    ).._listSubItem = (fields[3] as List).cast<SubItemModel>();
  }

  @override
  void write(BinaryWriter writer, SubItemModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj._listSubItem);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
