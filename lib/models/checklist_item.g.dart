// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checklist_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChecklistItemAdapter extends TypeAdapter<ChecklistItem> {
  @override
  final int typeId = 2;

  @override
  ChecklistItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChecklistItem(
      text: fields[0] as String,
      details: fields[1] as String?,
      order: fields[2] as int,
      responseType: fields[3] as ResponseType,
      regulationRef: fields[4] as String?,
      section: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ChecklistItem obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.text)
      ..writeByte(1)
      ..write(obj.details)
      ..writeByte(2)
      ..write(obj.order)
      ..writeByte(3)
      ..write(obj.responseType)
      ..writeByte(4)
      ..write(obj.regulationRef)
      ..writeByte(5)
      ..write(obj.section);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChecklistItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
