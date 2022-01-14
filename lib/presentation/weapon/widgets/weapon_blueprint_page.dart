import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morningstar/application/bloc.dart';
import 'package:morningstar/domain/enums/enums.dart';
import 'package:morningstar/presentation/shared/loading.dart';
import 'package:morningstar/presentation/shared/scaffold_with_fab.dart';
import 'package:morningstar/presentation/weapon/widgets/weapon_detail_bottom.dart';
import 'package:morningstar/presentation/weapon/widgets/weapon_detail_top.dart';

class WeaponBlueprintPage extends StatelessWidget {
  final String name;
  final String image;
  final int rarity;
  final ElementType elementType;

  const WeaponBlueprintPage({
    Key? key,
    required this.name,
    required this.image,
    required this.rarity,
    required this.elementType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return isPortrait
        ? _PortraitLayout(
            name: name,
            image: image,
            rarity: rarity,
            elementType: elementType,
          )
        : _LandscapeLayout(
            name: name,
            image: image,
            rarity: rarity,
            elementType: elementType,
          );
  }
}

class _PortraitLayout extends StatelessWidget {
  final String name;
  final String image;
  final int rarity;
  final ElementType elementType;

  const _PortraitLayout({
    Key? key,
    required this.name,
    required this.image,
    required this.rarity,
    required this.elementType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithFab(
      child: BlocBuilder<WeaponBloc, WeaponState>(
        builder: (context, state) {
          return state.map(
            loading: (_) => const Loading(useScaffold: false),
            loaded: (state) => Stack(
              fit: StackFit.passthrough,
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                WeaponDetailTop(
                  name: name,
                  image: image,
                  rarity: rarity,
                ),
                WeaponDetailBottom(
                  name: name,
                  rarity: rarity,
                  elementType: elementType,
                  description: state.description,
                  damage: state.damage,
                  accuracy: state.accuracy,
                  control: state.control,
                  fireRate: state.fireRate,
                  range: state.range,
                  mobility: state.mobility,
                  type: state.weaponType,
                  blueprints: const [],
                  isBlueprintPage: true,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _LandscapeLayout extends StatelessWidget {
  final String name;
  final String image;
  final int rarity;
  final ElementType elementType;

  const _LandscapeLayout({
    Key? key,
    required this.name,
    required this.image,
    required this.rarity,
    required this.elementType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<WeaponBloc, WeaponState>(
          builder: (context, state) {
            return state.map(
              loading: (_) => const Loading(useScaffold: false),
              loaded: (state) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 40,
                    child: WeaponDetailTop(
                      name: name,
                      image: image,
                      rarity: rarity,
                    ),
                  ),
                  Expanded(
                    flex: 60,
                    child: WeaponDetailBottom(
                      name: name,
                      rarity: rarity,
                      elementType: elementType,
                      description: state.description,
                      damage: state.damage,
                      accuracy: state.accuracy,
                      control: state.control,
                      fireRate: state.fireRate,
                      range: state.range,
                      mobility: state.mobility,
                      type: state.weaponType,
                      blueprints: const [],
                      isBlueprintPage: true,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
