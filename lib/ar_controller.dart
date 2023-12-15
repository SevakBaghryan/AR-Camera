import 'package:flutter/services.dart';

class ARController {
  static const platform = MethodChannel('ar_view_channel');

  static Future<void> startAR() async {
    try {
      await platform.invokeMethod('startAR');
    } on PlatformException catch (e) {
      print("Failed to start AR: ${e.message}");
    }
  }
}
