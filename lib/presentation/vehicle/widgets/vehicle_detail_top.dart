import 'package:flutter/material.dart';
import 'package:morningstar/domain/app_constants.dart';
import 'package:morningstar/presentation/shared/details/detail_top_layout.dart';
import 'package:morningstar/presentation/shared/extensions/rarity_extensions.dart';

class VehicleDetailTop extends StatelessWidget {
  final String name;
  final String image;
  final int rarity;
  final bool useMargin;

  const VehicleDetailTop({
    Key? key,
    required this.name,
    required this.image,
    this.rarity = 1,
    this.useMargin = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isPortrait = mediaQuery.orientation == Orientation.portrait;
    return DetailTopLayout(
      image: image,
      secondImage: image,
      name: name,
      useMargin: useMargin,
      webUrl: vehiclesImageUrl,
      gradient: rarity.getRarityGradient(),
      borderRadius: const BorderRadius.only(
        bottomRight: Radius.circular(20),
        bottomLeft: Radius.circular(20),
      ),
      showShadowImage: false,
      isASmallImage: isPortrait,
      generalCard: Container(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
    );
  }
}
