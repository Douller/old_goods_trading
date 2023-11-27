import 'package:flutter/cupertino.dart';

class AppRouter {
  static Future<dynamic> push(BuildContext context, Widget page) {
    return Navigator.push(
        context, CupertinoPageRoute(builder: (context) => page));
  }

  static Future<Object?> replace(BuildContext context,
      {required Widget newPage}) {
    return Navigator.pushReplacement(
        context, CupertinoPageRoute(builder: (context) => newPage));
  }
}
