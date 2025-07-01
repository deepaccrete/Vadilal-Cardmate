import 'package:nb_utils/nb_utils.dart';
import'package:web/web.dart' as web ;


// /// Works only on Flutter Web
// Future<bool> checkInternet() async {
//   return html.window.navigator.onLine ?? false;
// }


/// Works only on Flutter Web
Future<bool> checkInternet() async {
  try {
    final online = web.window.navigator.onLine;
    print('Web Internet status: $online');
    return online ?? false;
  } catch (e) {
    print('Internet Error: $e');
    return false;
  }
}
