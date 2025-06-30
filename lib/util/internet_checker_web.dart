import 'dart:html' as html;

/// Works only on Flutter Web
Future<bool> checkInternet() async {
  return html.window.navigator.onLine ?? false;
}
