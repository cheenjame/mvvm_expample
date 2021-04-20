// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "carRemaining" : MessageLookupByLibrary.simpleMessage("Car remaining parking spaces:"),
    "drawerList" : MessageLookupByLibrary.simpleMessage("List"),
    "holiday" : MessageLookupByLibrary.simpleMessage("Holiday charging method"),
    "locomotiveRemaining" : MessageLookupByLibrary.simpleMessage("Locomotive remaining parking spaces:"),
    "totalCar" : MessageLookupByLibrary.simpleMessage("Total car parking spaces:"),
    "totalLocomotive" : MessageLookupByLibrary.simpleMessage("Total Locomotive Parking Space:"),
    "trafficInformation" : MessageLookupByLibrary.simpleMessage("Traffic Information"),
    "weekdays" : MessageLookupByLibrary.simpleMessage("How to charge on weekdays")
  };
}
