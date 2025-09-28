// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enums.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChecklistInstanceStatusAdapter
    extends TypeAdapter<ChecklistInstanceStatus> {
  @override
  final int typeId = 6;

  @override
  ChecklistInstanceStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ChecklistInstanceStatus.inProgress;
      case 1:
        return ChecklistInstanceStatus.completed;
      default:
        return ChecklistInstanceStatus.inProgress;
    }
  }

  @override
  void write(BinaryWriter writer, ChecklistInstanceStatus obj) {
    switch (obj) {
      case ChecklistInstanceStatus.inProgress:
        writer.writeByte(0);
        break;
      case ChecklistInstanceStatus.completed:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChecklistInstanceStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ResponseTypeAdapter extends TypeAdapter<ResponseType> {
  @override
  final int typeId = 7;

  @override
  ResponseType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ResponseType.okNotOkNA;
      case 1:
        return ResponseType.text;
      case 2:
        return ResponseType.number;
      default:
        return ResponseType.okNotOkNA;
    }
  }

  @override
  void write(BinaryWriter writer, ResponseType obj) {
    switch (obj) {
      case ResponseType.okNotOkNA:
        writer.writeByte(0);
        break;
      case ResponseType.text:
        writer.writeByte(1);
        break;
      case ResponseType.number:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResponseTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ItemResponseStatusAdapter extends TypeAdapter<ItemResponseStatus> {
  @override
  final int typeId = 8;

  @override
  ItemResponseStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ItemResponseStatus.ok;
      case 1:
        return ItemResponseStatus.notOk;
      case 2:
        return ItemResponseStatus.na;
      default:
        return ItemResponseStatus.ok;
    }
  }

  @override
  void write(BinaryWriter writer, ItemResponseStatus obj) {
    switch (obj) {
      case ItemResponseStatus.ok:
        writer.writeByte(0);
        break;
      case ItemResponseStatus.notOk:
        writer.writeByte(1);
        break;
      case ItemResponseStatus.na:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemResponseStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DeficiencyStatusAdapter extends TypeAdapter<DeficiencyStatus> {
  @override
  final int typeId = 9;

  @override
  DeficiencyStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DeficiencyStatus.open;
      case 1:
        return DeficiencyStatus.inProgress;
      case 2:
        return DeficiencyStatus.closed;
      default:
        return DeficiencyStatus.open;
    }
  }

  @override
  void write(BinaryWriter writer, DeficiencyStatus obj) {
    switch (obj) {
      case DeficiencyStatus.open:
        writer.writeByte(0);
        break;
      case DeficiencyStatus.inProgress:
        writer.writeByte(1);
        break;
      case DeficiencyStatus.closed:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeficiencyStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SyncStatusAdapter extends TypeAdapter<SyncStatus> {
  @override
  final int typeId = 10;

  @override
  SyncStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SyncStatus.synced;
      case 1:
        return SyncStatus.needsCreate;
      case 2:
        return SyncStatus.needsUpdate;
      default:
        return SyncStatus.synced;
    }
  }

  @override
  void write(BinaryWriter writer, SyncStatus obj) {
    switch (obj) {
      case SyncStatus.synced:
        writer.writeByte(0);
        break;
      case SyncStatus.needsCreate:
        writer.writeByte(1);
        break;
      case SyncStatus.needsUpdate:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SyncStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
