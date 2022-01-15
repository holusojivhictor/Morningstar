import 'package:flutter/material.dart';
import 'package:morningstar/theme.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:morningstar/presentation/soldier/widgets/soldier_detail.dart';

import 'constants.dart';

class DetailBottomPortraitLayout extends StatelessWidget {
  final List<Widget> children;
  final bool isASmallImage;
  const DetailBottomPortraitLayout({
    Key? key,
    required this.children,
    this.isASmallImage = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final maxTopHeight = getTopMarginForPortrait(context, soldierDescriptionHeight, isASmallImage);
    final device = getDeviceType(size);
    final width = size.width * (device == DeviceScreenType.mobile ? 1 : 0.9);
    return SizedBox(
      width: width,
      child: Card(
        margin: EdgeInsets.only(top: maxTopHeight),
        shape: Styles.cardItemDetailShape,
        elevation: 0,
        child: Padding(
          padding: Styles.edgeInsetAll10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
      ),
    );
  }
}
