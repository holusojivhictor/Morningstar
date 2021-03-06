import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:morningstar/domain/extensions/string_extensions.dart';

class CircleItem extends StatelessWidget {
  final String image;
  final double radius;
  final bool forDrag;
  final bool imageSizeTimesTwo;
  final Function(String)? onTap;
  final bool isTierItem;

  const CircleItem({
    Key? key,
    required this.image,
    this.radius = 35,
    this.forDrag = false,
    this.imageSizeTimesTwo = true,
    this.onTap,
    this.isTierItem = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Try adding a background with the material widget
    final size = imageSizeTimesTwo ? radius * 2 : radius;
    final avatar = CircleAvatar(
      radius: radius,
      backgroundColor: isTierItem ? Colors.black.withOpacity(0.1) : Colors.transparent,
      child: ClipOval(
        child: isTierItem
            ? FutureBuilder(
              future: 'weapons-private/$image'.getImage(),
              builder: (context, AsyncSnapshot<String?> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return FadeInImage(
                    width: size,
                    height: size,
                    fadeInDuration: const Duration(milliseconds: 400),
                    placeholder: MemoryImage(kTransparentImage),
                    image: CachedNetworkImageProvider(snapshot.data!),
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                  );
                } else {
                  return SizedBox(height: size, width: size);
                }
              },
            )
            : FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                image: AssetImage(image),
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
                height: size,
                width: size,
              ),
      ),
    );

    if (forDrag) {
      return avatar;
    }

    return Container(
      margin: const EdgeInsets.all(3),
      child: InkWell(
        radius: radius,
        borderRadius: BorderRadius.circular(radius),
        onTap: () => onTap != null ? onTap!(image) : {},
        child: avatar,
      ),
    );
  }
}
