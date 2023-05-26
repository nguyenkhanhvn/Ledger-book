// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RecordModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecordModelAdapter extends TypeAdapter<RecordModel> {
  @override
  final int typeId = 1;

  @override
  RecordModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecordModel(
      title: fields[0] as String,
    ).._records = (fields[1] as Map).cast<RecordCategory, _RecordData>();
  }

  @override
  void write(BinaryWriter writer, RecordModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj._records);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecordModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RecordDataAdapter extends TypeAdapter<_RecordData> {
  @override
  final int typeId = 3;

  @override
  _RecordData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _RecordData()
      .._startDate = fields[0] as DateTime?
      .._endDate = fields[1] as DateTime?
      .._listItem = (fields[2] as List).cast<ItemModel>();
  }

  @override
  void write(BinaryWriter writer, _RecordData obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj._startDate)
      ..writeByte(1)
      ..write(obj._endDate)
      ..writeByte(2)
      ..write(obj._listItem);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecordDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RecordCategoryAdapter extends TypeAdapter<RecordCategory> {
  @override
  final int typeId = 2;

  @override
  RecordCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return RecordCategory.income;
      case 1:
        return RecordCategory.expense;
      default:
        return RecordCategory.income;
    }
  }

  @override
  void write(BinaryWriter writer, RecordCategory obj) {
    switch (obj) {
      case RecordCategory.income:
        writer.writeByte(0);
        break;
      case RecordCategory.expense:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecordCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
