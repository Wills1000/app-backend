import 'package:flutter/material.dart';
import 'nav_controller.dart';

class NavProvider extends InheritedNotifier<NavController> {
  const NavProvider({
    super.key,
    required NavController controller,
    required Widget child,
  }) : super(
          notifier: controller,
          child: child,
        );

  static NavController of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<NavProvider>();

    assert(provider != null, 'No NavProvider found.');

    return provider!.notifier!;
  }
}