// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checklist_item_response.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChecklistItemResponseAdapter extends TypeAdapter<ChecklistItemResponse> {
  @override
  final int typeId = 4;

  @override
  ChecklistItemResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChecklistItemResponse(
      itemId: fields[0] as int,
      status: fields[1] as ItemResponseStatus?,
      textValue: fields[2] as String?,
      numberValue: fields[3] as double?,
      photoPath: fields[4] as String?,
      comment: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ChecklistItemResponse obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.itemId)
      ..writeByte(1)
      ..write(obj.status)
      ..writeByte(2)
      ..write(obj.textValue)
      ..writeByte(3)
      ..write(obj.numberValue)
      ..writeByte(4)
      ..write(obj.photoPath)
      ..writeByte(5)
      ..write(obj.comment);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChecklistItemResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
