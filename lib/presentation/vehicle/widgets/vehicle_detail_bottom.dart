import 'package:flutter/material.dart';
import 'package:morningstar/domain/enums/enums.dart';
import 'package:morningstar/presentation/shared/details/detail_bottom_portrait_layout.dart';
import 'package:morningstar/presentation/shared/details/detail_tab_landscape_layout.dart';
import 'package:morningstar/presentation/shared/item_description_detail.dart';
import 'package:morningstar/presentation/shared/extensions/element_type_extensions.dart';
import 'package:morningstar/presentation/vehicle/widgets/vehicle_detail_general_map.dart';
import 'package:responsive_builder/responsive_builder.dart';

class VehicleDetailBottom extends StatelessWidget {
  final String name;
  final int rarity;
  final ElementType elementType;

  const VehicleDetailBottom({
    Key? key,
    required this.name,
    this.rarity = 1,
    this.elementType = ElementType.common,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return isPortrait
        ? _PortraitLayout(
            vehicleDescriptionHeight: 120,
            name: name,
            rarity: rarity,
            elementType: elementType,
          )
        : _LandscapeLayout(
            vehicleDescriptionHeight: 120,
            name: name,
            rarity: rarity,
            elementType: elementType,
          );
  }
}

class _PortraitLayout extends StatelessWidget {
  final double vehicleDescriptionHeight;
  final String name;
  final int rarity;
  final ElementType elementType;

  const _PortraitLayout({
    Key? key,
    required this.name,
    required this.rarity,
    required this.elementType,
    this.vehicleDescriptionHeight = 150,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isPortrait = mediaQuery.orientation == Orientation.portrait;
    final device = getDeviceType(mediaQuery.size);
    final descriptionWidth = (mediaQuery.size.width / (isPortrait ? 1 : 2)) / (device == DeviceScreenType.mobile ? 1.2 : 1.5);
    final theme = Theme.of(context);

    return DetailBottomPortraitLayout(
      isVehicle: true,
      children: [
        SizedBox(
          height: vehicleDescriptionHeight,
          width: descriptionWidth,
          child: VehicleDetailGeneralCard(
            elementType: elementType,
            name: name,
            rarity: rarity,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: ItemDescriptionDetail(
            title: 'Description',
            body: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                'No description available for this item.',
                style: theme.textTheme.headline3,
              ),
            ),
            textColor: elementType.getElementColorFromContext(context),
          ),
        ),
      ],
    );
  }
}

class _LandscapeLayout extends StatelessWidget {
  final double vehicleDescriptionHeight;
  final String name;
  final int rarity;
  final ElementType elementType;

  const _LandscapeLayout({
    Key? key,
    required this.name,
    required this.rarity,
    required this.elementType,
    this.vehicleDescriptionHeight = 150,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isPortrait = mediaQuery.orientation == Orientation.portrait;
    final device = getDeviceType(mediaQuery.size);
    final descriptionWidth = (mediaQuery.size.width / (isPortrait ? 1 : 2)) / (device == DeviceScreenType.mobile ? 1.2 : 1.5);

    final tabs = [
      'Description',
    ];
    return DetailTabLandscapeLayout(
      color: elementType.getElementColorFromContext(context),
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
                      child: const Text('No description available')),
                  textColor: elementType.getElementColorFromContext(context),
                ),
              ),
              SizedBox(
                height: vehicleDescriptionHeight,
                width: descriptionWidth,
                child: VehicleDetailGeneralCard(
                  elementType: elementType,
                  name: name,
                  rarity: rarity,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
