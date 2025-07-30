// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deficiency.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DeficiencyAdapter extends TypeAdapter<Deficiency> {
  @override
  final int typeId = 5;

  @override
  Deficiency read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Deficiency(
      description: fields[0] as String,
      instanceId: fields[1] as int?,
      checklistItemId: fields[2] as int?,
      status: fields[3] as DeficiencyStatus,
      assignedTo: fields[4] as String?,
      dueDate: fields[5] as DateTime?,
      correctiveActions: fields[6] as String?,
      resolutionDate: fields[7] as DateTime?,
      photoPath: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Deficiency obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.description)
      ..writeByte(1)
      ..write(obj.instanceId)
      ..writeByte(2)
      ..write(obj.checklistItemId)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.assignedTo)
      ..writeByte(5)
      ..write(obj.dueDate)
      ..writeByte(6)
      ..write(obj.correctiveActions)
      ..writeByte(7)
      ..write(obj.resolutionDate)
      ..writeByte(8)
      ..write(obj.photoPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeficiencyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
