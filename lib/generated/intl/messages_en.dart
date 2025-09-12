// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(name) => "Captain: ${name}";

  static String m1(templateName) => "Check details for \"${templateName}\"";

  static String m2(name) => "Check Report: ${name}";

  static String m3(count) => "Checks In Progress (${count})";

  static String m4(itemOrder) => "Comment on item no. ${itemOrder}";

  static String m5(count) => "Completed Checks (${count})";

  static String m6(date) => "Completed: ${date}";

  static String m7(error) => "Critical error creating check: ${error}";

  static String m8(key) => "Deficiency with key ${key} not found!";

  static String m9(vesselName) => "Deficiency report for vessel: ${vesselName}";

  static String m10(checklistName) =>
      "Are you sure you want to delete the check:\n\"${checklistName}\"?\n\nThis action cannot be undone!";

  static String m11(description) =>
      "Are you sure you want to delete the deficiency:\n\"${description}\"?\n\nThis action is irreversible!";

  static String m12(date) => " - Due: ${date}";

  static String m13(error) => "Error loading check data: ${error}";

  static String m14(error) => "Error loading templates: ${error}";

  static String m15(error) => "Error saving profile: ${error}";

  static String m16(name) => "Generating PDF for \"${name}\"...";

  static String m17(vesselName) =>
      "Generating PDF report for vessel \"${vesselName}\"...";

  static String m18(name) => "Inspector: ${name}";

  static String m19(key) => "Instance with key ${key} not found!";

  static String m20(itemOrder, itemText) =>
      "Item ${itemOrder}: ${itemText} is marked as \"Not OK\".";

  static String m21(vesselName) =>
      "No deficiencies found for vessel \"${vesselName}\"";

  static String m22(permissionName) =>
      "Permission required for access to ${permissionName}";

  static String m23(permissionName) =>
      "Permission to access \"${permissionName}\" is required to add a photo.";

  static String m24(error) => "Photo error: ${error}";

  static String m25(name) => "Port: ${name}";

  static String m26(date) => "Started: ${date}";

  static String m27(status) => "Status: ${status}";

  static String m28(key) => "Template with key ${key} not found!";

  static String m29(version) => "Version: ${version}";

  static String m30(name) => "Vessel: ${name}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "addComment": MessageLookupByLibrary.simpleMessage("Add comment"),
        "addDeficiency": MessageLookupByLibrary.simpleMessage("Add Deficiency"),
        "addDeficiencyPhoto": MessageLookupByLibrary.simpleMessage("Add Photo"),
        "addPhoto": MessageLookupByLibrary.simpleMessage("Add photo"),
        "appLanguage":
            MessageLookupByLibrary.simpleMessage("Application Language"),
        "appSettings": MessageLookupByLibrary.simpleMessage("App Settings"),
        "assignedTo": MessageLookupByLibrary.simpleMessage("Assigned To:"),
        "camera": MessageLookupByLibrary.simpleMessage("Camera"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "captain": m0,
        "captainNameCannotBeEmpty": MessageLookupByLibrary.simpleMessage(
            "Captain\'s name cannot be empty"),
        "captainNameForCheck": MessageLookupByLibrary.simpleMessage(
            "Captain\'s Name (for this check)"),
        "captainNameForReports": MessageLookupByLibrary.simpleMessage(
            "Captain\'s Name (for reports):"),
        "captainNameHint":
            MessageLookupByLibrary.simpleMessage("E.g., Peter Jones"),
        "checkCompleted":
            MessageLookupByLibrary.simpleMessage("Check completed"),
        "checkDeleted": MessageLookupByLibrary.simpleMessage("Check deleted"),
        "checkDetailsFor": m1,
        "checkReportSubject": m2,
        "checksInProgress": m3,
        "close": MessageLookupByLibrary.simpleMessage("Close"),
        "commentToItem": m4,
        "completeCheck": MessageLookupByLibrary.simpleMessage("Complete Check"),
        "completedChecks": m5,
        "completedOn": m6,
        "completedOnUnknownDate": MessageLookupByLibrary.simpleMessage(
            "Completed: Date not specified"),
        "confirmDeletion":
            MessageLookupByLibrary.simpleMessage("Confirm Deletion"),
        "correctiveActions":
            MessageLookupByLibrary.simpleMessage("Corrective Actions:"),
        "create": MessageLookupByLibrary.simpleMessage("Create"),
        "createDeficiency":
            MessageLookupByLibrary.simpleMessage("Create Deficiency?"),
        "createPdfReport":
            MessageLookupByLibrary.simpleMessage("Create PDF Report"),
        "criticalErrorCreatingCheck": m7,
        "dashboard": MessageLookupByLibrary.simpleMessage("Dashboard"),
        "defaultVesselName":
            MessageLookupByLibrary.simpleMessage("Default Vessel Name:"),
        "defaultVesselNameHint":
            MessageLookupByLibrary.simpleMessage("E.g., MV Example"),
        "deficiencyDeleted":
            MessageLookupByLibrary.simpleMessage("Deficiency deleted"),
        "deficiencyDescription":
            MessageLookupByLibrary.simpleMessage("Deficiency Description:"),
        "deficiencyDetails":
            MessageLookupByLibrary.simpleMessage("Deficiency Details"),
        "deficiencyList":
            MessageLookupByLibrary.simpleMessage("Deficiency List"),
        "deficiencyNotFound": m8,
        "deficiencyPhoto":
            MessageLookupByLibrary.simpleMessage("Deficiency Photo:"),
        "deficiencyReportForVessel": m9,
        "deficiencySaved":
            MessageLookupByLibrary.simpleMessage("Deficiency saved"),
        "delete": MessageLookupByLibrary.simpleMessage("Delete"),
        "deleteButton": MessageLookupByLibrary.simpleMessage("DELETE"),
        "deleteCheck": MessageLookupByLibrary.simpleMessage("Delete check"),
        "deleteChecklistConfirmation": m10,
        "deleteDeficiency":
            MessageLookupByLibrary.simpleMessage("Delete deficiency"),
        "deleteDeficiencyConfirmation": m11,
        "deleteWord": MessageLookupByLibrary.simpleMessage("Delete"),
        "describeTheProblem":
            MessageLookupByLibrary.simpleMessage("Describe the problem..."),
        "describeWhatWasDone":
            MessageLookupByLibrary.simpleMessage("Describe what was done..."),
        "dueDate": MessageLookupByLibrary.simpleMessage("Due Date:"),
        "dueDateLabel": m12,
        "editComment": MessageLookupByLibrary.simpleMessage("Edit comment"),
        "enterComment":
            MessageLookupByLibrary.simpleMessage("Enter comment..."),
        "enterDeleteToConfirm": MessageLookupByLibrary.simpleMessage(
            "Please type the word \'Delete\' to confirm:"),
        "enterOrConfirmCaptainName": MessageLookupByLibrary.simpleMessage(
            "Enter or confirm captain\'s name"),
        "enterOrConfirmVesselName": MessageLookupByLibrary.simpleMessage(
            "Enter or confirm vessel name"),
        "enterPort": MessageLookupByLibrary.simpleMessage("Enter port"),
        "errorDeleting": MessageLookupByLibrary.simpleMessage("Error deleting"),
        "errorDeletingDeficiency":
            MessageLookupByLibrary.simpleMessage("Error deleting deficiency"),
        "errorDeletingFile":
            MessageLookupByLibrary.simpleMessage("Error deleting file"),
        "errorDeletingPhoto": MessageLookupByLibrary.simpleMessage(
            "Error deleting old item photo file"),
        "errorHiveBoxesNotOpen": MessageLookupByLibrary.simpleMessage(
            "Error: Not all Hive boxes are open."),
        "errorLoadingCheckData": m13,
        "errorLoadingData":
            MessageLookupByLibrary.simpleMessage("Error loading data"),
        "errorLoadingDeficiency": MessageLookupByLibrary.simpleMessage(
            "Error loading deficiency data"),
        "errorLoadingTemplates": m14,
        "errorSaving": MessageLookupByLibrary.simpleMessage("Save error!"),
        "errorSavingDeficiency":
            MessageLookupByLibrary.simpleMessage("Error saving deficiency"),
        "errorSavingProfile": m15,
        "failedToLoadCheckData":
            MessageLookupByLibrary.simpleMessage("Failed to load check data."),
        "failedToProcessPhoto":
            MessageLookupByLibrary.simpleMessage("Failed to process photo"),
        "filterAll": MessageLookupByLibrary.simpleMessage("All"),
        "gallery": MessageLookupByLibrary.simpleMessage("Gallery"),
        "generatingPdfFor": m16,
        "generatingPdfReportForVessel": m17,
        "inspector": m18,
        "instanceNotFound":
            MessageLookupByLibrary.simpleMessage("Check instance not found"),
        "instanceNotFoundForKey": m19,
        "itemMarkedAsNotOk": m20,
        "later": MessageLookupByLibrary.simpleMessage("Later"),
        "managePhoto": MessageLookupByLibrary.simpleMessage("Photo: Manage"),
        "na": MessageLookupByLibrary.simpleMessage("N/A"),
        "nameCannotBeEmpty":
            MessageLookupByLibrary.simpleMessage("Name cannot be empty"),
        "nameOrPosition":
            MessageLookupByLibrary.simpleMessage("Name or position..."),
        "newDeficiency": MessageLookupByLibrary.simpleMessage("New Deficiency"),
        "noActiveChecks":
            MessageLookupByLibrary.simpleMessage("No active checks"),
        "noCompletedChecks":
            MessageLookupByLibrary.simpleMessage("No completed checks"),
        "noDeficienciesFoundForVessel": m21,
        "noDeficienciesRegistered":
            MessageLookupByLibrary.simpleMessage("No deficiencies registered."),
        "noDescription": MessageLookupByLibrary.simpleMessage("No description"),
        "notOk": MessageLookupByLibrary.simpleMessage("Not OK"),
        "notSet": MessageLookupByLibrary.simpleMessage("Not set"),
        "notSetFeminine": MessageLookupByLibrary.simpleMessage("Not set"),
        "ok": MessageLookupByLibrary.simpleMessage("OK"),
        "openDeficiencies":
            MessageLookupByLibrary.simpleMessage("Open Deficiencies"),
        "otherItems": MessageLookupByLibrary.simpleMessage("Other Items"),
        "pdfError": MessageLookupByLibrary.simpleMessage("PDF Error"),
        "pdfReportForDeficienciesTooltip": MessageLookupByLibrary.simpleMessage(
            "PDF report for deficiencies of the current vessel"),
        "permissionPermanentlyDenied": MessageLookupByLibrary.simpleMessage(
            " Please enable the permission in the app settings."),
        "permissionRequired": m22,
        "permissionRequiredFor": m23,
        "photoAddedOrUpdated":
            MessageLookupByLibrary.simpleMessage("Photo added/updated"),
        "photoDeleted":
            MessageLookupByLibrary.simpleMessage("Item photo deleted"),
        "photoError": m24,
        "pleaseFixErrorsInForm": MessageLookupByLibrary.simpleMessage(
            "Please fix the errors in the form."),
        "port": m25,
        "portCannotBeEmpty":
            MessageLookupByLibrary.simpleMessage("Port cannot be empty"),
        "portOfCheck": MessageLookupByLibrary.simpleMessage("Port of Check"),
        "positionCannotBeEmpty":
            MessageLookupByLibrary.simpleMessage("Position cannot be empty"),
        "processingPhoto":
            MessageLookupByLibrary.simpleMessage("Processing photo..."),
        "profileSettings":
            MessageLookupByLibrary.simpleMessage("Profile Settings"),
        "profileSetup": MessageLookupByLibrary.simpleMessage("Profile Setup"),
        "replacePhoto": MessageLookupByLibrary.simpleMessage("Replace photo"),
        "report": MessageLookupByLibrary.simpleMessage("Report"),
        "resolutionDate":
            MessageLookupByLibrary.simpleMessage("Resolution Date:"),
        "save": MessageLookupByLibrary.simpleMessage("Save"),
        "selectCheckTemplate":
            MessageLookupByLibrary.simpleMessage("Select Check Template"),
        "selectDueDate":
            MessageLookupByLibrary.simpleMessage("Select due date"),
        "selectResolutionDate":
            MessageLookupByLibrary.simpleMessage("Select resolution date"),
        "settingsSaved":
            MessageLookupByLibrary.simpleMessage("Settings saved!"),
        "startCheck": MessageLookupByLibrary.simpleMessage("Start Check"),
        "startNewCheck":
            MessageLookupByLibrary.simpleMessage("Start New Check"),
        "startedOn": m26,
        "status": MessageLookupByLibrary.simpleMessage("Status:"),
        "statusClosed": MessageLookupByLibrary.simpleMessage("Closed"),
        "statusInProgress": MessageLookupByLibrary.simpleMessage("In Progress"),
        "statusLabel": m27,
        "statusOpen": MessageLookupByLibrary.simpleMessage("Open"),
        "templateNotFound":
            MessageLookupByLibrary.simpleMessage("Template not found"),
        "templateNotFoundForKey": m28,
        "templatesNotFound": MessageLookupByLibrary.simpleMessage(
            "Templates not found. Please seed the database."),
        "unknownTemplate":
            MessageLookupByLibrary.simpleMessage("Unknown template"),
        "unnamedCheck": MessageLookupByLibrary.simpleMessage("Unnamed"),
        "user": MessageLookupByLibrary.simpleMessage("User"),
        "version": m29,
        "vessel": m30,
        "vesselName": MessageLookupByLibrary.simpleMessage("Vessel Name"),
        "vesselNameCannotBeEmpty":
            MessageLookupByLibrary.simpleMessage("Vessel name cannot be empty"),
        "vesselNameNotInProfile": MessageLookupByLibrary.simpleMessage(
            "Vessel name is not specified in the profile!"),
        "viewOrReplacePhoto":
            MessageLookupByLibrary.simpleMessage("View/Replace Photo"),
        "yourName": MessageLookupByLibrary.simpleMessage("Your Name:"),
        "yourNameHint":
            MessageLookupByLibrary.simpleMessage("E.g., John Smith"),
        "yourPosition": MessageLookupByLibrary.simpleMessage("Your Position:"),
        "yourPositionHint":
            MessageLookupByLibrary.simpleMessage("E.g., 2nd Engineer")
      };
}
