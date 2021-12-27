import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'constants.dart';

class DetailTopLayout extends StatelessWidget {
  final String image;
  final String name;
  final String? secondImage;
  final Color? color;
  final Widget generalCard;
  final Widget? appBar;
  final BorderRadius? borderRadius;

  final bool isASmallImage;
  final bool showShadowImage;
  final double soldierDescriptionHeight;

  const DetailTopLayout({
    Key? key,
    required this.image,
    required this.name,
    this.secondImage,
    this.color,
    required this.generalCard,
    this.appBar,
    this.borderRadius,
    this.isASmallImage = false,
    this.showShadowImage = true,
    this.soldierDescriptionHeight = 240,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isPortrait = mediaQuery.orientation == Orientation.portrait;
    final device = getDeviceType(mediaQuery.size);
    final descriptionWidth = (mediaQuery.size.width / (isPortrait ? 1 : 2)) / (device == DeviceScreenType.mobile ? 1.2 : 1.5);
    final imgAlignment = showShadowImage
        ? isPortrait
            ? Alignment.center
            : Alignment.bottomLeft
        : Alignment.center;
    return Container(
      height: isPortrait ? getTopHeightForPortrait(context, isASmallImage) : null,
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius,
      ),
      child: Stack(
        fit: StackFit.passthrough,
        alignment: Alignment.center,
        children: <Widget>[
          if (showShadowImage)
            ShadowImage(
              image: image,
              secondImage: secondImage,
              isASmallImage: isASmallImage,
            ),
          Align(
            alignment: imgAlignment,
            child: Image.asset(
              image,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
            ),
          ),
          Positioned(
            top: 45.0,
            left: 15.0,
            child: RotatedBox(
              quarterTurns: 1,
              child: AnimatedTextKit(
                totalRepeatCount: 1,
                animatedTexts: [
                  TyperAnimatedText(
                    name,
                    speed: const Duration(milliseconds: 80),
                    textStyle: Theme.of(context).textTheme.headline4!.copyWith(fontSize: 22, letterSpacing: 2.5),
                  ),
                ],
              ),
            ),
          ),
          // Padding(
          //   padding: isPortrait ? const EdgeInsets.only(bottom: 30) : EdgeInsets.zero,
          //   child: Align(
          //     alignment: isPortrait ? Alignment.bottomCenter : Alignment.bottomCenter,
          //     child: SizedBox(
          //       height: soldierDescriptionHeight,
          //       width: descriptionWidth,
          //       child: generalCard,
          //     ),
          //   ),
          // ),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: appBar ?? const SizedBox(),
          ),
        ],
      ),
    );
  }
}

class ShadowImage extends StatelessWidget {
  final String image;
  final String? secondImage;
  final bool isASmallImage;
  const ShadowImage({
    Key? key,
    required this.image,
    this.secondImage,
    this.isASmallImage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isPortrait = mediaQuery.orientation == Orientation.portrait;
    if (!isPortrait) {
      return Align(
        alignment: Alignment.topRight,
        child: Opacity(
          opacity: 0.3,
          child: Image.asset(
            secondImage ?? image,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
          ),
        ),
      );
    }
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        transform: Matrix4.translationValues(isASmallImage ? 30 : 60, isASmallImage ? -10 : -30, 0.0),
        child: Opacity(
          opacity: 0.3,
          child: Image.asset(
            secondImage ?? image,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
          ),
        ),
      ),
    );
  }
}

