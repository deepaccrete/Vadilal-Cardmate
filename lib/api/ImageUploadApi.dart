import 'dart:io';

import 'package:camera_app/util/const.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

import 'dart:io';
import 'package:camera_app/util/const.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

import '../main.dart';

class ImageuploadApi {
  static Future<bool> uploadImage(File imageFile) async {
    final uri = Uri.parse(AppApiConst.imageupload);

    // ✅ Proper header with Bearer token
    final headers = {
      'Authorization': 'Bearer ${appStore.userData!.token}',
      'Accept': 'application/json',
    };

    var request = http.MultipartRequest('POST', uri)
      ..headers.addAll(headers)
      ..files.add(await http.MultipartFile.fromPath(
        'image', // 🔁 make sure this matches your backend field name
        imageFile.path,
        filename: basename(imageFile.path),
      ));

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        print("✅ Image uploaded successfully");
        return true;
      } else {
        print("❌ Upload failed: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("❗ Upload error: $e");
      return false;
    }
  }
}
