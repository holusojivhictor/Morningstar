import 'package:flutter/material.dart';
import 'package:morningstar/presentation/shared/smooth_star_rating.dart';

class RarityRating extends StatelessWidget {
  final int rarity;
  final int stars;
  final double size;
  final Function(int) onRated;
  const RarityRating({
    Key? key,
    required this.rarity,
    required this.onRated,
    this.size = 30.0,
    required this.stars,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: SmoothStarRating(
        starCount: stars,
        rating: rarity.toDouble(),
        allowHalfRating: false,
        onRated: (v) => onRated(v!.toInt()),
        size: size,
        color: Colors.yellowAccent,
        borderColor: theme.brightness == Brightness.dark ? Colors.white : Colors.black,
      ),
    );
  }
}
