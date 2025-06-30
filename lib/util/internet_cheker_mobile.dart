import 'package:http/http.dart' as http;

/// Works on Android, iOS, Desktop
Future<bool> checkInternet() async {
  try {
    final response = await http.get(Uri.parse('https://www.google.com'));
    print('Internet is Working');
    return response.statusCode == 200;

  } catch (_) {
    print('no Internnet');
    return false;
  }
}
