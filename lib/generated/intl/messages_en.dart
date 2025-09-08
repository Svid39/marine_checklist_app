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

  static String m4(count) => "Completed Checks (${count})";

  static String m5(date) => "Completed: ${date}";

  static String m6(error) => "Critical error creating check: ${error}";

  static String m7(checklistName) =>
      "Are you sure you want to delete the check:\n\"${checklistName}\"?\n\nThis action cannot be undone!";

  static String m8(error) => "Error loading templates: ${error}";

  static String m9(name) => "Generating PDF for \"${name}\"...";

  static String m10(name) => "Inspector: ${name}";

  static String m11(name) => "Port: ${name}";

  static String m12(date) => "Started: ${date}";

  static String m13(version) => "Version: ${version}";

  static String m14(name) => "Vessel: ${name}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "captain": m0,
        "captainNameCannotBeEmpty": MessageLookupByLibrary.simpleMessage(
            "Captain\'s name cannot be empty"),
        "captainNameForCheck": MessageLookupByLibrary.simpleMessage(
            "Captain\'s Name (for this check)"),
        "checkDeleted": MessageLookupByLibrary.simpleMessage("Check deleted"),
        "checkDetailsFor": m1,
        "checkReportSubject": m2,
        "checksInProgress": m3,
        "completedChecks": m4,
        "completedOn": m5,
        "completedOnUnknownDate": MessageLookupByLibrary.simpleMessage(
            "Completed: Date not specified"),
        "confirmDeletion":
            MessageLookupByLibrary.simpleMessage("Confirm Deletion"),
        "createPdfReport":
            MessageLookupByLibrary.simpleMessage("Create PDF Report"),
        "criticalErrorCreatingCheck": m6,
        "dashboard": MessageLookupByLibrary.simpleMessage("Dashboard"),
        "deleteButton": MessageLookupByLibrary.simpleMessage("DELETE"),
        "deleteCheck": MessageLookupByLibrary.simpleMessage("Delete check"),
        "deleteChecklistConfirmation": m7,
        "deleteWord": MessageLookupByLibrary.simpleMessage("Delete"),
        "enterDeleteToConfirm": MessageLookupByLibrary.simpleMessage(
            "Please type the word \'Delete\' to confirm:"),
        "enterOrConfirmCaptainName": MessageLookupByLibrary.simpleMessage(
            "Enter or confirm captain\'s name"),
        "enterOrConfirmVesselName": MessageLookupByLibrary.simpleMessage(
            "Enter or confirm vessel name"),
        "enterPort": MessageLookupByLibrary.simpleMessage("Enter port"),
        "errorDeleting": MessageLookupByLibrary.simpleMessage("Error deleting"),
        "errorLoadingData":
            MessageLookupByLibrary.simpleMessage("Error loading data"),
        "errorLoadingTemplates": m8,
        "generatingPdfFor": m9,
        "inspector": m10,
        "instanceNotFound":
            MessageLookupByLibrary.simpleMessage("Check instance not found"),
        "noActiveChecks":
            MessageLookupByLibrary.simpleMessage("No active checks"),
        "noCompletedChecks":
            MessageLookupByLibrary.simpleMessage("No completed checks"),
        "openDeficiencies":
            MessageLookupByLibrary.simpleMessage("Open Deficiencies"),
        "pdfError": MessageLookupByLibrary.simpleMessage("PDF Error"),
        "port": m11,
        "portCannotBeEmpty":
            MessageLookupByLibrary.simpleMessage("Port cannot be empty"),
        "portOfCheck": MessageLookupByLibrary.simpleMessage("Port of Check"),
        "profileSettings":
            MessageLookupByLibrary.simpleMessage("Profile Settings"),
        "report": MessageLookupByLibrary.simpleMessage("Report"),
        "selectCheckTemplate":
            MessageLookupByLibrary.simpleMessage("Select Check Template"),
        "startCheck": MessageLookupByLibrary.simpleMessage("Start Check"),
        "startNewCheck":
            MessageLookupByLibrary.simpleMessage("Start New Check"),
        "startedOn": m12,
        "templateNotFound":
            MessageLookupByLibrary.simpleMessage("Template not found"),
        "templatesNotFound": MessageLookupByLibrary.simpleMessage(
            "Templates not found. Please seed the database."),
        "unknownTemplate":
            MessageLookupByLibrary.simpleMessage("Unknown template"),
        "unnamedCheck": MessageLookupByLibrary.simpleMessage("Unnamed"),
        "user": MessageLookupByLibrary.simpleMessage("User"),
        "version": m13,
        "vessel": m14,
        "vesselName": MessageLookupByLibrary.simpleMessage("Vessel Name"),
        "vesselNameCannotBeEmpty":
            MessageLookupByLibrary.simpleMessage("Vessel name cannot be empty")
      };
}
