import 'package:flutter/material.dart';
import 'package:morningstar/domain/assets.dart';

class CodIcon extends StatelessWidget {
  final double iconSize;
  final bool smallImage;
  const CodIcon({
    Key? key,
    this.iconSize = 25,
    this.smallImage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final largeImagePath = Assets.getCODMLogoPath('codm-logo.png');
    final smallImagePath = Assets.getCODMLogoPath('small-codm-logo.png');
    return IconButton(
      iconSize: iconSize,
      icon: smallImage ? Image.asset(smallImagePath) : Image.asset(largeImagePath),
      onPressed: null,
    );
  }
}
