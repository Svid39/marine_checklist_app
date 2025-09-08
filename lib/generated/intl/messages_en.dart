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

  static String m1(name) => "Check Report: ${name}";

  static String m2(count) => "Checks In Progress (${count})";

  static String m3(count) => "Completed Checks (${count})";

  static String m4(date) => "Completed: ${date}";

  static String m5(checklistName) =>
      "Are you sure you want to delete the check:\n\"${checklistName}\"?\n\nThis action cannot be undone!";

  static String m6(name) => "Generating PDF for \"${name}\"...";

  static String m7(name) => "Inspector: ${name}";

  static String m8(name) => "Port: ${name}";

  static String m9(date) => "Started: ${date}";

  static String m10(name) => "Vessel: ${name}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "captain": m0,
        "checkDeleted": MessageLookupByLibrary.simpleMessage("Check deleted"),
        "checkReportSubject": m1,
        "checksInProgress": m2,
        "completedChecks": m3,
        "completedOn": m4,
        "completedOnUnknownDate": MessageLookupByLibrary.simpleMessage(
            "Completed: Date not specified"),
        "confirmDeletion":
            MessageLookupByLibrary.simpleMessage("Confirm Deletion"),
        "createPdfReport":
            MessageLookupByLibrary.simpleMessage("Create PDF Report"),
        "dashboard": MessageLookupByLibrary.simpleMessage("Dashboard"),
        "deleteButton": MessageLookupByLibrary.simpleMessage("DELETE"),
        "deleteCheck": MessageLookupByLibrary.simpleMessage("Delete check"),
        "deleteChecklistConfirmation": m5,
        "deleteWord": MessageLookupByLibrary.simpleMessage("Delete"),
        "enterDeleteToConfirm": MessageLookupByLibrary.simpleMessage(
            "Please type the word \'Delete\' to confirm:"),
        "errorDeleting": MessageLookupByLibrary.simpleMessage("Error deleting"),
        "errorLoadingData":
            MessageLookupByLibrary.simpleMessage("Error loading data"),
        "generatingPdfFor": m6,
        "inspector": m7,
        "instanceNotFound":
            MessageLookupByLibrary.simpleMessage("Check instance not found"),
        "noActiveChecks":
            MessageLookupByLibrary.simpleMessage("No active checks"),
        "noCompletedChecks":
            MessageLookupByLibrary.simpleMessage("No completed checks"),
        "openDeficiencies":
            MessageLookupByLibrary.simpleMessage("Open Deficiencies"),
        "pdfError": MessageLookupByLibrary.simpleMessage("PDF Error"),
        "port": m8,
        "profileSettings":
            MessageLookupByLibrary.simpleMessage("Profile Settings"),
        "report": MessageLookupByLibrary.simpleMessage("Report"),
        "startNewCheck":
            MessageLookupByLibrary.simpleMessage("Start New Check"),
        "startedOn": m9,
        "templateNotFound":
            MessageLookupByLibrary.simpleMessage("Template not found"),
        "unknownTemplate":
            MessageLookupByLibrary.simpleMessage("Unknown template"),
        "unnamedCheck": MessageLookupByLibrary.simpleMessage("Unnamed"),
        "user": MessageLookupByLibrary.simpleMessage("User"),
        "vessel": m10
      };
}
