// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checklist_template.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChecklistTemplateAdapter extends TypeAdapter<ChecklistTemplate> {
  @override
  final int typeId = 1;

  @override
  ChecklistTemplate read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChecklistTemplate(
      name: fields[0] as String,
      description: fields[1] as String?,
      version: fields[2] as int,
      items: (fields[3] as List).cast<ChecklistItem>(),
    );
  }

  @override
  void write(BinaryWriter writer, ChecklistTemplate obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.version)
      ..writeByte(3)
      ..write(obj.items);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChecklistTemplateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
