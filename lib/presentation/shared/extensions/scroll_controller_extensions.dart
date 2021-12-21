import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

extension ScrollControllerExtensions on ScrollController {
  void handleScrollForFab(AnimationController hideFabController, {bool hideOnTop = true}) {
    switch (position.userScrollDirection) {
      case ScrollDirection.idle:
        break;
      case ScrollDirection.forward:
        hideFabController.forward();
        break;
      case ScrollDirection.reverse:
        hideFabController.reverse();
        break;
    }

    if (hideOnTop && position.pixels == 0 && position.atEdge) {
      hideFabController.reverse();
    }
  }

  void goToTheTop() => animateTo(0, duration: const Duration(milliseconds: 2000), curve: Curves.easeInOut);
}