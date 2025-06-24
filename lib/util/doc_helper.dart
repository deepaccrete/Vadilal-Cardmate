import 'package:flutter/services.dart';

class DocScannerHelper {
  static const MethodChannel _channel = MethodChannel('flutter_doc_scanner');

  static Future<String?> scanDocument() async {
    try {
      final String? imagePath = await _channel.invokeMethod<String>('scanDocument');
      return imagePath;
    } on PlatformException catch (e) {
      print('Failed to scan document: ${e.message}');
      return null;
    }
  }
}
