import 'package:flutter/material.dart';
import 'package:morningstar/domain/enums/enums.dart';
import 'package:morningstar/domain/models/db/weapons/weapon_file_model.dart';
import 'package:morningstar/domain/models/models.dart';
import 'package:morningstar/presentation/shared/details/detail_bottom_portrait_layout.dart';
import 'package:morningstar/presentation/shared/details/detail_tab_landscape_layout.dart';
import 'package:morningstar/presentation/shared/item_description_detail.dart';
import 'package:morningstar/presentation/weapon/widgets/weapon_detail_blueprint_build.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:morningstar/presentation/shared/extensions/element_type_extensions.dart';

import 'weapon_detail_general_card.dart';

class WeaponDetailBottom extends StatelessWidget {
  final String name;
  final String description;
  final WeaponType type;
  final double damage;
  final double accuracy;
  final double range;
  final double fireRate;
  final double mobility;
  final double control;
  final List<WeaponBlueprintCardModel> blueprints;
  final bool isBlueprintPage;
  final int rarity;
  final ElementType elementType;

  const WeaponDetailBottom({
    Key? key,
    required this.name,
    required this.description,
    required this.type,
    required this.damage,
    required this.accuracy,
    required this.range,
    required this.fireRate,
    required this.mobility,
    required this.control,
    required this.blueprints,
    this.isBlueprintPage = false,
    this.rarity = 1,
    this.elementType = ElementType.epic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return isPortrait ? _PortraitLayout(
      name: name,
      weaponDescriptionHeight: 220,
      description: description,
      type: type,
      damage: damage,
      accuracy: accuracy,
      range: range,
      fireRate: fireRate,
      mobility: mobility,
      control: control,
      blueprints: blueprints,
      isBlueprintPage: isBlueprintPage,
      rarity: rarity,
      elementType: elementType,
    ) :  _LandscapeLayout(
      name: name,
      weaponDescriptionHeight: 220,
      description: description,
      type: type,
      damage: damage,
      accuracy: accuracy,
      range: range,
      fireRate: fireRate,
      mobility: mobility,
      control: control,
      rarity: rarity,
      elementType: elementType,
    );
  }
}

class _PortraitLayout extends StatelessWidget {
  final String name;
  final double weaponDescriptionHeight;
  final String description;
  final WeaponType type;
  final double damage;
  final double accuracy;
  final double range;
  final double fireRate;
  final double mobility;
  final double control;
  final List<WeaponBlueprintCardModel> blueprints;
  final bool isBlueprintPage;
  final int rarity;
  final ElementType elementType;

  const _PortraitLayout({
    Key? key,
    required this.name,
    this.weaponDescriptionHeight = 150,
    required this.description,
    required this.type,
    required this.damage,
    required this.accuracy,
    required this.range,
    required this.fireRate,
    required this.mobility,
    required this.control,
    required this.blueprints,
    required this.isBlueprintPage,
    required this.rarity,
    required this.elementType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isPortrait = mediaQuery.orientation == Orientation.portrait;
    final device = getDeviceType(mediaQuery.size);
    final descriptionWidth = (mediaQuery.size.width / (isPortrait ? 1 : 2)) / (device == DeviceScreenType.mobile ? 1.2 : 1.5);
    final theme = Theme.of(context);

    return DetailBottomPortraitLayout(
      children: [
        SizedBox(
          height: weaponDescriptionHeight,
          width: descriptionWidth,
          child: WeaponDetailGeneralCard(
            name: name,
            type: type,
            damage: damage,
            accuracy: accuracy,
            range: range,
            fireRate: fireRate,
            mobility: mobility,
            control: control,
            rarity: rarity,
            elementType: elementType,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: ItemDescriptionDetail(
            title: 'Description',
            body: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                description,
                style: theme.textTheme.headline3,
              ),
            ),
            textColor: ElementType.epic.getElementColorFromContext(context),
          ),
        ),
        if (!isBlueprintPage && blueprints.isNotEmpty)
          ItemDescriptionDetail(
            title: 'Blueprints',
            body: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              child: Blueprints(
                blueprints: blueprints,
              ),
            ),
            textColor: ElementType.epic.getElementColorFromContext(context),
          ),
      ],
    );
  }
}

class _LandscapeLayout extends StatelessWidget {
  final String name;
  final double weaponDescriptionHeight;
  final String description;
  final WeaponType type;
  final double damage;
  final double accuracy;
  final double range;
  final double fireRate;
  final double mobility;
  final double control;
  final int rarity;
  final ElementType elementType;

  const _LandscapeLayout({
    Key? key,
    required this.name,
    this.weaponDescriptionHeight = 150,
    required this.description,
    required this.type,
    required this.damage,
    required this.accuracy,
    required this.range,
    required this.fireRate,
    required this.mobility,
    required this.control,
    required this.rarity,
    required this.elementType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isPortrait = mediaQuery.orientation == Orientation.portrait;
    final device = getDeviceType(mediaQuery.size);
    final descriptionWidth = (mediaQuery.size.width / (isPortrait ? 1 : 2)) / (device == DeviceScreenType.mobile ? 1.2 : 1.5);
    final theme = Theme.of(context);

    final tabs = [
      'Description',
    ];

    return DetailTabLandscapeLayout(
      color: ElementType.epic.getElementColorFromContext(context),
      tabs: tabs,
      children: [
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: ItemDescriptionDetail(
                  title: 'Description',
                  body: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      description,
                      style: theme.textTheme.headline3,
                    ),
                  ),
                  textColor: ElementType.epic.getElementColorFromContext(context),
                ),
              ),
              SizedBox(
                height: weaponDescriptionHeight,
                width: descriptionWidth,
                child: WeaponDetailGeneralCard(
                  name: name,
                  type: type,
                  damage: damage,
                  accuracy: accuracy,
                  range: range,
                  fireRate: fireRate,
                  mobility: mobility,
                  control: control,
                  rarity: rarity,
                  elementType: elementType,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


