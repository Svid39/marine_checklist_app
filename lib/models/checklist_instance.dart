// Файл: lib/models/checklist_instance.dart

import 'package:hive/hive.dart';
import 'checklist_item_response.dart'; 
import 'enums.dart'; 

part 'checklist_instance.g.dart'; 

@HiveType(typeId: 3) 
class ChecklistInstance extends HiveObject {

  @HiveField(0)
  late int templateId;

  @HiveField(1)
  String? shipName;

  @HiveField(2)
  late DateTime date; 

  @HiveField(3)
  late ChecklistInstanceStatus status;

  @HiveField(4)
  late List<ChecklistItemResponse> responses; 

  @HiveField(5)
  DateTime? completionDate; 

  @HiveField(6)
  String? port; 

  @HiveField(7)
  String? captainNameOnCheck; 

  @HiveField(8)
  String? inspectorName; 

  ChecklistInstance({
    required this.templateId,
    this.shipName,
    required this.date,
    this.status = ChecklistInstanceStatus.inProgress,
    this.responses = const [], 
    this.completionDate,
    this.port,
    this.captainNameOnCheck,
    this.inspectorName,
  });
}