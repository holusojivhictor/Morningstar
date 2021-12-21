import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:morningstar/theme.dart';
import 'package:responsive_builder/responsive_builder.dart';

class CommonButtonBar extends StatelessWidget {
  final List<Widget> children;
  final WrapAlignment alignment;
  final EdgeInsets margin;
  final double? runSpacing;
  final double spacing;
  const CommonButtonBar({
    Key? key,
    required this.children,
    this.alignment = WrapAlignment.end,
    this.margin = Styles.edgeInsetVertical5,
    this.runSpacing,
    this.spacing = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final forEndDrawer =
        getDeviceType(MediaQuery.of(context).size) != DeviceScreenType.mobile;
    return Container(
      margin: margin,
      child: Wrap(
        alignment: alignment,
        spacing: spacing,
        runSpacing: runSpacing != null
            ? runSpacing!
            : forEndDrawer
                ? 10
                : 0,
        children: children,
      ),
    );
  }
}
