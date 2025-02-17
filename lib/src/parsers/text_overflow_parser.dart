import 'package:flutter/widgets.dart';

class TextOverflowParser {
  static TextOverflow? parseOverflow(String className) {
    if (className.contains("truncate")) {
      return TextOverflow.ellipsis;
    } else if (className.contains("text-clip")) {
      return TextOverflow.clip;
    } else if (className.contains("text-fade")) {
      return TextOverflow.fade;
    }
    return null;
  }

  static int? parseMaxLines(String className) {
    final RegExp regex = RegExp(r'max-lines-(\d+)');
    final match = regex.firstMatch(className);
    if (match != null) {
      return int.tryParse(match.group(1)!);
    }
    return null;
  }

  static bool? parseSoftWrap(String className) {
    if (className.contains("no-wrap")) {
      return false;
    }
    return null;
  }

  static String applyMaxChars(String text, String className) {
    final RegExp regex = RegExp(r'max-chars-(\d+)');
    final match = regex.firstMatch(className);
    if (match != null) {
      int maxChars = int.tryParse(match.group(1)!) ?? text.length;
      if (text.length > maxChars) {
        return text.substring(0, maxChars) + "...";
      }
    }
    return text;
  }
}