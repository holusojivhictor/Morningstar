import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morningstar/application/bloc.dart';
import 'package:morningstar/domain/assets.dart';
import 'package:morningstar/domain/enums/enums.dart';
import 'package:morningstar/domain/models/models.dart';
import 'package:morningstar/presentation/shared/gradient_card.dart';
import 'package:morningstar/presentation/shared/images/comingsoon_new_avatar.dart';
import 'package:morningstar/presentation/shared/loading.dart';
import 'package:morningstar/theme.dart';
import 'package:transparent_image/transparent_image.dart';

class WeaponCard extends StatelessWidget {
  final String keyName;
  final String image;
  final String name;
  final double? damage;
  final WeaponType? type;
  final WeaponModel? model;
  final bool isComingSoon;

  final double imgWidth;
  final double imgHeight;
  final bool withoutDetails;
  final bool isInSelectionMode;
  final bool withElevation;

  const WeaponCard({
    Key? key,
    required this.keyName,
    required this.image,
    required this.name,
    required this.damage,
    required this.type,
    required this.model,
    required this.isComingSoon,
    this.imgHeight = 140,
    this.imgWidth = 160,
    this.isInSelectionMode = false,
    this.withElevation = true,
  })  : withoutDetails = false,
        super(key: key);

  const WeaponCard.withoutDetails({
    Key? key,
    required this.keyName,
    required this.image,
    required this.name,
    required this.isComingSoon,
    this.imgHeight = 140,
    this.imgWidth = 160,
  })  : model = null,
        type = null,
        damage = null,
        withoutDetails = true,
        isInSelectionMode = false,
        withElevation = false,
        super(key: key);

  WeaponCard.item({
    Key? key,
    required WeaponCardModel weapon,
    this.imgHeight = 140,
    this.imgWidth = 160,
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
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: Styles.mainWeaponCardBorderRadius,
      onTap: () {},
      child: GradientCard(
        clipBehavior: Clip.hardEdge,
        shape: Styles.mainWeaponCardShape,
        elevation: withElevation ? Styles.cardTenElevation : 0,
        gradient: getRarityGradient(),
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
                    placeholder: MemoryImage(kTransparentImage),
                    image: AssetImage(image),
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
              if (!withoutDetails)
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

  LinearGradient getRarityGradient() {
    final colors = getRarityColors();
    return LinearGradient(
      colors: colors,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  List<Color> getRarityColors() {
    return const [
      Color.fromARGB(255, 92, 85, 131),
      Color.fromARGB(255, 131, 108, 168),
      Color.fromARGB(255, 179, 131, 197),
    ];
  }
}
