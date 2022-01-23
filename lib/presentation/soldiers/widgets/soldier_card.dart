import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morningstar/application/bloc.dart';
import 'package:morningstar/domain/app_constants.dart';
import 'package:morningstar/domain/assets.dart';
import 'package:morningstar/domain/enums/enums.dart';
import 'package:morningstar/domain/models/models.dart';
import 'package:morningstar/presentation/shared/images/comingsoon_new_avatar.dart';
import 'package:morningstar/presentation/shared/images/element_image.dart';
import 'package:morningstar/presentation/shared/images/rarity.dart';
import 'package:morningstar/presentation/shared/utils/toast_utils.dart';
import 'package:morningstar/presentation/soldier/soldier_page.dart';
import 'package:morningstar/theme.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:morningstar/presentation/shared/extensions/rarity_extensions.dart';
import 'package:morningstar/presentation/shared/extensions/element_type_extensions.dart';

class SoldierCard extends StatelessWidget {
  final String keyName;
  final String image;
  final String name;
  final int rarity;
  final ElementType elementType;
  final bool isNew;
  final bool isComingSoon;
  final bool isInSelectionMode;
  final bool useSolidBackground;
  final bool topPickPage;
  final double? width;
  const SoldierCard({
    Key? key,
    required this.keyName,
    required this.image,
    required this.name,
    required this.rarity,
    required this.elementType,
    required this.isNew,
    required this.isComingSoon,
    this.isInSelectionMode = false,
    this.useSolidBackground = false,
    this.topPickPage = false,
    this.width,
  }) : super(key: key);

  SoldierCard.item({
    Key? key,
    required SoldierCardModel soldierModel,
    this.isInSelectionMode = false,
    this.useSolidBackground = false,
    this.topPickPage = false,
    this.width,
  })  : keyName = soldierModel.key,
        elementType = soldierModel.elementType,
        isComingSoon = soldierModel.isComingSoon,
        isNew = soldierModel.isNew,
        image = soldierModel.imageUrl,
        name = soldierModel.name,
        rarity = soldierModel.stars,
        super(key: key);

  SoldierCard.days({
    Key? key,
    required TodayTopPickSoldierModel topPick,
    this.isInSelectionMode = false,
    this.useSolidBackground = false,
    this.topPickPage = true,
    this.width,
  })  : keyName = topPick.key,
        elementType = topPick.elementType,
        isComingSoon = topPick.isComingSoon,
        isNew = topPick.isNew,
        image = topPick.imageUrl,
        name = topPick.name,
        rarity = topPick.stars,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final isPortrait = mediaQuery.orientation == Orientation.portrait;
    final size = mediaQuery.size;
    var height = size.height / 2.85;
    if (height > 500) {
      height = 500;
    } else if (height < 260) {
      height = 260;
    }

    return InkWell(
      borderRadius: Styles.mainCardBorderRadius,
      onTap: () => _goToSoldierPage(context),
      child: Card(
        clipBehavior: Clip.hardEdge,
        shape: Styles.mainCardShape,
        elevation: Styles.cardTenElevation,
        color: Colors.transparent,
        shadowColor: Colors.transparent,
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: height,
              width: width,
              child: Stack(
                alignment: AlignmentDirectional.topCenter,
                fit: StackFit.passthrough,
                children: [
                  ClipPath(
                    clipper: BackgroundClipper(),
                    child: Container(
                      height: height,
                      width: width,
                      decoration: useSolidBackground
                          ? BoxDecoration(
                              color: elementType.getElementColorFromContext(context),
                            )
                          : ShapeDecoration(
                              gradient: rarity.getRarityGradient(),
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                            ),
                    ),
                  ),
                  Positioned(
                    left: isNew
                        ? topPickPage ? 8 : isPortrait ? 0 : 140
                        : topPickPage ? 8 : isPortrait ? 40 : 140,
                    bottom: 5,
                    child: Container(
                      height: height,
                      width: width,
                      alignment: Alignment.bottomRight,
                      child: FadeInImage(
                        fadeInDuration: const Duration(milliseconds: 500),
                        placeholder: MemoryImage(kTransparentImage),
                        image: CachedNetworkImageProvider('$soldiersImageUrl$image'),
                      ),
                    ),
                  ),
                  Positioned(
                    top: height * 0.42,
                    left: 0.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Tooltip(
                          message: Assets.translateElementType(elementType),
                          child: Container(
                            margin: const EdgeInsets.only(top: 10, left: 5),
                            child: ElementImage.fromType(type: elementType, radius: 15, useDarkForBackgroundColor: true),
                          ),
                        ),
                        if (topPickPage)
                          const RadiantGradientMask(
                            child: Icon(Icons.local_fire_department, color: Colors.white),
                          ),
                        const SizedBox(),
                        ComingSoonNewAvatar(
                          isNew: isNew,
                          isComingSoon: isComingSoon,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (!topPickPage)
              Padding(
                padding: Styles.edgeInsetAll10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Text(
                        name,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.headline4!.copyWith(fontWeight: FontWeight.bold, letterSpacing: 0.15),
                      ),
                    ),
                    Rarity(stars: rarity, starSize: 15),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _goToSoldierPage(BuildContext context) async {
    if (isComingSoon && !isInSelectionMode) {
      final fToast = ToastUtils.of(context);
      ToastUtils.showWarningToast(fToast, 'Coming soon');
      return;
    }

    if (isInSelectionMode) {
      Navigator.pop(context, keyName);
      return;
    }

    final bloc = context.read<SoldierBloc>();
    bloc.add(SoldierEvent.loadFromKey(key: keyName));
    final route = MaterialPageRoute(builder: (c) => const SoldierPage());
    await Navigator.push(context, route);
    await route.completed;
    bloc.pop();
  }
}

class BackgroundClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var roundnessFactor = 30.0;
    var path = Path();

    path.moveTo(0, size.height * 0.33);
    path.lineTo(0, size.height - roundnessFactor);
    path.quadraticBezierTo(0, size.height, roundnessFactor, size.height);
    //
    path.lineTo(size.width - roundnessFactor, size.height);
    path.quadraticBezierTo(size.width, size.height, size.width, size.height - roundnessFactor);
    //
    path.lineTo(size.width, roundnessFactor * 3);
    path.quadraticBezierTo(size.width, roundnessFactor * 2, size.width * 0.75, roundnessFactor * 2.5);
    //
    path.lineTo(roundnessFactor, size.height * 0.33 + 20);
    path.quadraticBezierTo(0, size.height * 0.33 + roundnessFactor + 6, 0, size.height * 0.33 + roundnessFactor * 2);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class RadiantGradientMask extends StatelessWidget {
  final Widget child;
  const RadiantGradientMask({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const RadialGradient(
        center: Alignment.center,
        radius: 0.5,
        colors: [Colors.red, Colors.yellow],
        tileMode: TileMode.mirror,
      ).createShader(bounds),
      child: child,
    );
  }
}
