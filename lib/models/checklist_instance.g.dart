// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checklist_instance.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChecklistInstanceAdapter extends TypeAdapter<ChecklistInstance> {
  @override
  final int typeId = 3;

  @override
  ChecklistInstance read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChecklistInstance(
      templateId: fields[0] as int,
      shipName: fields[1] as String?,
      date: fields[2] as DateTime,
      status: fields[3] as ChecklistInstanceStatus,
      responses: (fields[4] as List).cast<ChecklistItemResponse>(),
      completionDate: fields[5] as DateTime?,
      port: fields[6] as String?,
      captainNameOnCheck: fields[7] as String?,
      inspectorName: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ChecklistInstance obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.templateId)
      ..writeByte(1)
      ..write(obj.shipName)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.responses)
      ..writeByte(5)
      ..write(obj.completionDate)
      ..writeByte(6)
      ..write(obj.port)
      ..writeByte(7)
      ..write(obj.captainNameOnCheck)
      ..writeByte(8)
      ..write(obj.inspectorName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChecklistInstanceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
