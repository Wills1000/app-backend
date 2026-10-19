import 'package:flutter/material.dart';

class AppRoutes {
  static Future<dynamic> go(
    BuildContext context,
    Widget page,
  ) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => page,
      ),
    );
  }

  static void back(BuildContext context) {
    Navigator.pop(context);
  }

  static Future<dynamic> replace(
    BuildContext context,
    Widget page,
  ) {
    return Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => page,
      ),
    );
  }

  static Future<dynamic> clearStack(
    BuildContext context,
    Widget page,
  ) {
    return Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => page,
      ),
      (route) => false,
    );
  }
}