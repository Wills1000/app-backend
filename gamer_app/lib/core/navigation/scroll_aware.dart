import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'nav_provider.dart';

class ScrollAware extends StatefulWidget {
  final Widget child;

  const ScrollAware({
    super.key,
    required this.child,
  });

  @override
  State<ScrollAware> createState() => _ScrollAwareState();
}

class _ScrollAwareState extends State<ScrollAware> {
  @override
  Widget build(BuildContext context) {
    return NotificationListener<UserScrollNotification>(
      onNotification: (notification) {
        final nav = NavProvider.of(context);

        switch (notification.direction) {
          case ScrollDirection.forward:
            nav.show();
            break;

          case ScrollDirection.reverse:
            nav.hide();
            break;

          case ScrollDirection.idle:
            break;
        }

        return false;
      },
      child: widget.child,
    );
  }
}