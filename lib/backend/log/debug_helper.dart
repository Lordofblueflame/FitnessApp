import 'package:flutter/foundation.dart';

class DebugHelper {
  static void printFunctionName() {
    final currentStackTrace = StackTrace.current;
    final stackFrames = currentStackTrace.toString().split("\n");
    if (stackFrames.length > 2) {
      final currentFunction = stackFrames[1].trim();
      if (kDebugMode) {
        print('Current Function: $currentFunction');
      }
    }
  }
}


