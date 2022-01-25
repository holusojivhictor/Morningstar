import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morningstar/application/bloc.dart';
import 'package:morningstar/domain/app_constants.dart';
import 'package:morningstar/domain/assets.dart';
import 'package:morningstar/domain/enums/enums.dart';
import 'package:morningstar/domain/models/models.dart';
import 'package:morningstar/presentation/shared/gradient_card.dart';
import 'package:morningstar/presentation/shared/images/comingsoon_new_avatar.dart';
import 'package:morningstar/presentation/shared/extensions/rarity_extensions.dart';
import 'package:morningstar/presentation/shared/loading.dart';
import 'package:morningstar/presentation/weapon/weapon_page.dart';
import 'package:morningstar/presentation/weapon/widgets/weapon_build_page.dart';
import 'package:morningstar/theme.dart';
import 'package:transparent_image/transparent_image.dart';

class WeaponCard extends StatelessWidget {
  final String keyName;
  final String image;
  final String name;
  final int rarity;
  final double? damage;
  final WeaponType? type;
  final WeaponModel? model;
  final ElementType elementType;
  final bool isComingSoon;

  final double imgWidth;
  final double imgHeight;
  final bool withoutDetails;
  final bool isInSelectionMode;
  final bool withElevation;
  final bool isBuild;

  const WeaponCard({
    Key? key,
    required this.keyName,
    required this.image,
    required this.name,
    required this.rarity,
    required this.damage,
    required this.type,
    required this.model,
    required this.elementType,
    required this.isComingSoon,
    this.imgHeight = 140,
    this.imgWidth = 160,
    this.isInSelectionMode = false,
    this.withElevation = true,
  })  : withoutDetails = false,
        isBuild = false,
        super(key: key);

  const WeaponCard.withoutDetails({
    Key? key,
    required this.keyName,
    required this.image,
    required this.name,
    required this.isComingSoon,
    this.rarity = 4,
    this.elementType = ElementType.epic,
    this.imgHeight = 140,
    this.imgWidth = 160,
  })  : model = null,
        type = null,
        damage = null,
        withoutDetails = true,
        isInSelectionMode = false,
        withElevation = false,
        isBuild = false,
        super(key: key);

  WeaponCard.blueprint({
    Key? key,
    required WeaponBlueprintCardModel blueprint,
    this.imgHeight = 140,
    this.imgWidth = 160,
    this.isInSelectionMode = false,
    this.withElevation = true,
  })  : rarity = blueprint.rarity,
        keyName = blueprint.weaponKey,
        damage = null,
        image = blueprint.imagePath,
        name = blueprint.name,
        model = null,
        type = null,
        elementType = blueprint.elementType,
        isComingSoon = false,
        withoutDetails = true,
        isBuild = true,
        super(key: key);

  WeaponCard.camo({
    Key? key,
    required WeaponCamoCardModel camo,
    this.imgHeight = 140,
    this.imgWidth = 160,
    this.isInSelectionMode = false,
    this.withElevation = true,
  })  : rarity = camo.rarity,
        keyName = camo.weaponKey,
        damage = null,
        image = camo.imagePath,
        name = camo.name,
        model = null,
        type = null,
        elementType = camo.elementType,
        isComingSoon = false,
        withoutDetails = true,
        isBuild = true,
        super(key: key);

  WeaponCard.item({
    Key? key,
    required WeaponCardModel weapon,
    this.imgHeight = 140,
    this.imgWidth = 160,
    this.rarity = 4,
    this.elementType = ElementType.epic,
    this.isInSelectionMode = false,
    this.withElevation = true,
  })  : keyName = weapon.key,
        damage = weapon.damage,
        image = weapon.imageUrl,
        name = weapon.name,
        model = weapon.model,
        type = weapon.type,
        isComingSoon = weapon.isComingSoon,
        withoutDetails = false,
        isBuild = false,
        super(key: key);

  WeaponCard.days({
    Key? key,
    required TodayTopPickWeaponModel topPick,
    this.imgHeight = 140,
    this.imgWidth = 160,
    this.rarity = 4,
    this.elementType = ElementType.epic,
    this.isInSelectionMode = false,
    this.withElevation = true,
  })  : keyName = topPick.key,
        damage = topPick.damage,
        image = topPick.imageUrl,
        name = topPick.name,
        model = topPick.model,
        type = topPick.type,
        isComingSoon = topPick.isComingSoon,
        withoutDetails = true,
        isBuild = false,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: Styles.mainWeaponCardBorderRadius,
      onTap: () => isBuild
          ? _goToBuildPage(context)
          : _goToWeaponPage(context),
      child: GradientCard(
        clipBehavior: Clip.hardEdge,
        shape: Styles.mainWeaponCardShape,
        elevation: withElevation ? Styles.cardTenElevation : 0,
        gradient: rarity.getRarityGradient(),
        child: Padding(
          padding: Styles.edgeInsetAll5,
          child: Column(
            children: [
              Stack(
                alignment: AlignmentDirectional.topCenter,
                fit: StackFit.passthrough,
                children: [
                  FadeInImage(
                    width: imgWidth,
                    height: imgHeight,
                    fadeInDuration: const Duration(milliseconds: 500),
                    placeholder: MemoryImage(kTransparentImage),
                    image: CachedNetworkImageProvider('$weaponsImageUrl$image'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ComingSoonNewAvatar(
                        isNew: false,
                        isComingSoon: isComingSoon,
                      ),
                    ],
                  ),
                ],
              ),
              Center(
                child: Tooltip(
                  message: name,
                  child: Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.headline4!.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              BlocBuilder<SettingsBloc, SettingsState>(
                builder: (context, state) {
                  return state.map(
                    loading: (_) => const Loading(useScaffold: false),
                    loaded: (settingsState) {
                      if (withoutDetails || !settingsState.showWeaponDetails) {
                        return const SizedBox();
                      }
                      return Container(
                        margin: Styles.edgeInsetHorizontal16,
                        child: Column(
                          children: [
                            Text(
                              'Damage: $damage',
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white),
                            ),
                            Text(
                              'Type: ${Assets.translateWeaponModel(model!)}',
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _goToWeaponPage(BuildContext context) async {
    if (isInSelectionMode) {
      Navigator.pop(context, keyName);
      return;
    }

    final bloc = context.read<WeaponBloc>();
    bloc.add(WeaponEvent.loadFromKey(key: keyName));
    final route = MaterialPageRoute(builder: (c) => const WeaponPage());
    await Navigator.push(context, route);
    await route.completed;
    bloc.pop();
  }

  Future<void> _goToBuildPage(BuildContext context) async {
    final route = MaterialPageRoute(builder: (ct) => WeaponBuildPage(
      name: name,
      image: image,
      rarity: rarity,
      elementType: elementType,
    ));

    await Navigator.push(context, route);
    await route.completed;
  }
}
