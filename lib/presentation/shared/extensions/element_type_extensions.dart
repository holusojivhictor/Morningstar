import 'package:flutter/material.dart';
import 'package:morningstar/domain/assets.dart';

import 'package:morningstar/domain/enums/enums.dart';

extension ElementTypeExtensions on ElementType {
  String getElementAssetPath() {
    return Assets.getElementPathFromType(this);
  }

  Color getElementColorFromContext(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final darkModeOn = brightness == Brightness.dark;
    return getElementColor(!darkModeOn);
  }

  Color getElementColor(bool useDarkColors) {
    const alpha = 255;
    Color color;
    switch (this) {
      case ElementType.common:
        color = useDarkColors ? const Color.fromARGB(alpha, 182, 182, 182) : const Color.fromARGB(alpha, 218, 218, 218);
        break;
      case ElementType.uncommon:
        color = useDarkColors ? const Color.fromARGB(alpha, 76, 220, 172) : const Color.fromARGB(alpha, 161, 241, 201);
        break;
      case ElementType.rare:
        color = useDarkColors ? const Color.fromARGB(alpha, 33, 33, 144) : const Color.fromARGB(alpha, 63, 63, 159);
        break;
      case ElementType.epic:
        color = useDarkColors ? const Color.fromARGB(alpha, 212, 132, 252) : const Color.fromARGB(alpha, 203, 127, 252);
        break;
      case ElementType.legendary:
        color = useDarkColors ? const Color.fromARGB(alpha, 255, 165, 1) : const Color.fromARGB(alpha, 255, 196, 87);
        break;
      default:
        throw Exception('Invalid element type = ${this}');
    }

    return useDarkColors ? color.withOpacity(0.5) : color.withOpacity(0.5);
  }
}

// type             dark                light
// legendary        255, 165, 1         255, 196, 87
// epic(purple)     159, 81, 231        202, 159, 242
// rare(blue)       33, 33, 144         63, 63, 159
// uncommon(green)  12, 134, 12         68, 162, 68
// common           182, 182, 182       218, 218, 218