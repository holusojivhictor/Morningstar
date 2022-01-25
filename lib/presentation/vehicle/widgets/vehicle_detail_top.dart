import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morningstar/application/bloc.dart';
import 'package:morningstar/domain/app_constants.dart';
import 'package:morningstar/presentation/shared/details/detail_top_layout.dart';
import 'package:morningstar/presentation/shared/extensions/rarity_extensions.dart';
import 'package:morningstar/presentation/shared/loading.dart';
import 'package:morningstar/theme.dart';

class VehicleDetailTop extends StatelessWidget {
  final String name;
  final String image;
  final int rarity;

  const VehicleDetailTop({
    Key? key,
    required this.name,
    required this.image,
    this.rarity = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isPortrait = mediaQuery.orientation == Orientation.portrait;
    return DetailTopLayout(
      image: image,
      secondImage: image,
      name: name,
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
