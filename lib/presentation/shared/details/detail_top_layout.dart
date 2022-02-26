import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:morningstar/domain/extensions/string_extensions.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

class DetailTopLayout extends StatelessWidget {
  final String image;
  final String name;
  final String? secondImage;
  final Color? color;
  final Gradient? gradient;
  final Widget generalCard;
  final Widget? appBar;
  final BorderRadius? borderRadius;
  final String webUrl;

  final bool isASmallImage;
  final bool showShadowImage;
  final bool useMargin;
  final double soldierDescriptionHeight;

  const DetailTopLayout({
    Key? key,
    required this.image,
    required this.name,
    this.secondImage,
    this.color,
    this.gradient,
    required this.generalCard,
    this.appBar,
    this.borderRadius,
    required this.webUrl,
    this.isASmallImage = false,
    this.showShadowImage = true,
    this.useMargin = false,
    this.soldierDescriptionHeight = 240,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isPortrait = mediaQuery.orientation == Orientation.portrait;
    final imgAlignment = showShadowImage
        ? isPortrait
            ? Alignment.center
            : Alignment.bottomLeft
        : Alignment.center;
    return Container(
      height:
      isPortrait ? getTopHeightForPortrait(context, isASmallImage) : null,
      decoration: BoxDecoration(
        color: color,
        gradient: gradient,
        borderRadius: borderRadius,
      ),
      child: Stack(
        fit: StackFit.passthrough,
        alignment: Alignment.center,
        children: <Widget>[
          if (showShadowImage)
            ShadowImage(
              image: image,
              webUrl: webUrl,
              secondImage: secondImage,
              isASmallImage: isASmallImage,
            ),
          useMargin
              ? Align(
                  alignment: imgAlignment,
                  child: FutureBuilder(
                    future: image.getImage(),
                    builder: (context, AsyncSnapshot<String?> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Image(
                          width: 280,
                          height: 280,
                          image: CachedNetworkImageProvider(snapshot.data!),
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.high,
                        );
                      } else {
                        return const SizedBox(height: 280, width: 280);
                      }
                    },
                  ),
                )
              : Align(
                  alignment: imgAlignment,
                  child: FutureBuilder(
                    future: image.getImage(),
                    builder: (context, AsyncSnapshot<String?> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Image(
                          image: CachedNetworkImageProvider(snapshot.data!),
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.high,
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                ),
          if (!isASmallImage)
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
  final String webUrl;
  const ShadowImage({
    Key? key,
    required this.image,
    this.secondImage,
    this.isASmallImage = false,
    required this.webUrl,
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
          child: FutureBuilder(
            future: image.getImage(),
            builder: (context, AsyncSnapshot<String?> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Image(
                  image: CachedNetworkImageProvider(snapshot.data!),
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                );
              } else {
                return const SizedBox();
              }
            },
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
          child: FutureBuilder(
            future: image.getImage(),
            builder: (context, AsyncSnapshot<String?> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Image(
                  image: CachedNetworkImageProvider(snapshot.data!),
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ),
      ),
    );
  }
}
