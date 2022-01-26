import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:morningstar/domain/models/models.dart';
import 'package:morningstar/theme.dart';
import 'package:transparent_image/transparent_image.dart';

class PageCard extends StatelessWidget {
  final int number;
  final String image;
  final double imgWidth;
  final double imgHeight;
  final bool withElevation;

  const PageCard({
    Key? key,
    required this.number,
    required this.image,
    this.imgHeight = 140,
    this.imgWidth = 160,
    this.withElevation = true,
  }) : super(key: key);

  PageCard.item({
    Key? key,
    required ComicPageCardModel comicPage,
    this.imgHeight = 210,
    this.imgWidth = 160,
    this.withElevation = false,
  })  : number = comicPage.number,
        image = comicPage.imagePath,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final width = MediaQuery.of(context).size.width * (isPortrait ? 0.95 : 0.47);
    final height = MediaQuery.of(context).size.height * (isPortrait ? 0.24 : 0.5);

    return Card(
      color: Theme.of(context).scaffoldBackgroundColor,
      clipBehavior: Clip.hardEdge,
      shape: Styles.mainComicCardShape,
      elevation: withElevation ? Styles.cardTenElevation : 0,
      child: Padding(
        padding: Styles.edgeInsetAll5,
        child: ClipRect(
          clipper: RectClipper(),
          child: FadeInImage(
            width: width,
            height: height,
            fadeInDuration: const Duration(milliseconds: 100),
            placeholder: MemoryImage(kTransparentImage),
            image: CachedNetworkImageProvider(image),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class RectClipper extends CustomClipper<Rect> {
  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(size.width - 1, size.height - 1, 1, 1);
  }
}
