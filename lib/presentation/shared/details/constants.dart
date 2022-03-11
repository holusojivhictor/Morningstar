import 'package:flutter/material.dart';

double getTopHeightForPortrait(BuildContext context, bool isASmallImage) {
  final factor = isASmallImage ? 0.45 : 0.5;
  final value = MediaQuery.of(context).size.height * factor;
  // Max soldier height
  if (value > 700) {
    return 700;
  }
  return value;
}

double getTopMarginForPortrait(BuildContext context, double soldierDescriptionHeight, bool isASmallImage) {
  final maxTopHeight = (getTopHeightForPortrait(context, isASmallImage)) - (isASmallImage ? 80 : 50);
  return maxTopHeight;
}