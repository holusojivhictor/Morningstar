import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:morningstar/application/bloc.dart';
import 'package:morningstar/domain/enums/enums.dart';
import 'package:morningstar/domain/models/models.dart';
import 'package:morningstar/presentation/shared/gradient_card.dart';
import 'package:morningstar/presentation/shared/extensions/rarity_extensions.dart';
import 'package:morningstar/presentation/shared/images/comingsoon_new_avatar.dart';
import 'package:morningstar/presentation/vehicle/vehicle_page.dart';
import 'package:morningstar/presentation/vehicle/widgets/vehicle_build_page.dart';
import 'package:morningstar/domain/extensions/string_extensions.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../theme.dart';

class VehicleCard extends StatelessWidget {
  final String keyName;
  final String image;
  final String name;
  final int rarity;
  final ElementType elementType;
  final bool isComingSoon;

  final double imgWidth;
  final double imgHeight;
  final bool withoutDetails;
  final bool withElevation;
  final bool isBuild;

  const VehicleCard({
    Key? key,
    required this.keyName,
    required this.image,
    required this.name,
    required this.rarity,
    required this.elementType,
    required this.isComingSoon,
    this.imgHeight = 140,
    this.imgWidth = 160,
    this.withElevation = true,
  })  : withoutDetails = false,
        isBuild = false,
        super(key: key);

  VehicleCard.camo({
    Key? key,
    required VehicleCamoCardModel camo,
    this.imgHeight = 120,
    this.imgWidth = 140,
    this.withElevation = true,
  })  : keyName = camo.name,
        name = camo.name,
        image = camo.imagePath,
        rarity = camo.rarity,
        elementType = camo.elementType,
        withoutDetails = true,
        isComingSoon = camo.isComingSoon,
        isBuild = true,
        super(key: key);

  VehicleCard.item({
    Key? key,
    required VehicleCardModel vehicle,
    this.imgHeight = 120,
    this.imgWidth = 140,
    this.rarity = 1,
    this.elementType = ElementType.epic,
    this.withElevation = true,
  })  : keyName = vehicle.key,
        name = vehicle.name,
        image = vehicle.imagePath,
        withoutDetails = false,
        isComingSoon = vehicle.isComingSoon,
        isBuild = false,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: Styles.mainWeaponCardBorderRadius,
      onTap: () => !isBuild ? _goToVehiclePage(context) : _goToBuildPage(context),
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
                alignment: AlignmentDirectional.center,
                fit: StackFit.passthrough,
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: FutureBuilder(
                      future: image.getImage(),
                      builder: (context, AsyncSnapshot<String?> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return FadeInImage(
                            width: imgWidth,
                            height: imgHeight,
                            fadeInDuration: const Duration(milliseconds: 500),
                            placeholder: MemoryImage(kTransparentImage),
                            image: CachedNetworkImageProvider(snapshot.data!),
                          );
                        } else {
                          return SizedBox(height: imgHeight, width: imgWidth);
                        }
                      },
                    ),
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
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _goToVehiclePage(BuildContext context) async {
    final bloc = context.read<VehicleBloc>();
    bloc.add(VehicleEvent.loadFromKey(key: keyName));
    final route = MaterialPageRoute(builder: (c) => const VehiclePage());
    await Navigator.push(context, route);
    await route.completed;
    bloc.pop();
  }

  Future<void> _goToBuildPage(BuildContext context) async {
    final route = MaterialPageRoute(builder: (ct) => VehicleBuildPage(
      name: name,
      image: image,
      rarity: rarity,
      elementType: elementType,
    ));

    await Navigator.push(context, route);
    await route.completed;
  }
}
