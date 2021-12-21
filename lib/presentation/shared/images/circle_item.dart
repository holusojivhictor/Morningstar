import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class CircleItem extends StatelessWidget {
  final String image;
  final double radius;
  final bool forDrag;
  final bool imageSizeTimesTwo;
  final Function(String)? onTap;

  const CircleItem({
    Key? key,
    required this.image,
    this.radius = 35,
    this.forDrag = false,
    this.imageSizeTimesTwo = true,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Try adding a background with the material widget
    final size = imageSizeTimesTwo ? radius * 2 : radius;
    final avatar = CircleAvatar(
      radius: radius,
      backgroundColor: Colors.transparent,
      child: ClipOval(
        child: FadeInImage(
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
