import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morningstar/application/bloc.dart';
import 'package:morningstar/presentation/shared/loading.dart';
import 'package:morningstar/presentation/shared/scaffold_with_fab.dart';

import 'widgets/weapon_detail_bottom.dart';
import 'widgets/weapon_detail_top.dart';

class WeaponPage extends StatelessWidget {
  const WeaponPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return isPortrait ? const _PortraitLayout() : const _LandscapeLayout();
  }
}

class _PortraitLayout extends StatelessWidget {
  const _PortraitLayout({Key? key}) : super(key: key);

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
                  name: state.name,
                  image: state.fullImage,
                ),
                WeaponDetailBottom(
                  name: state.name,
                  description: state.description,
                  damage: state.damage,
                  accuracy: state.accuracy,
                  control: state.control,
                  fireRate: state.fireRate,
                  range: state.range,
                  mobility: state.mobility,
                  type: state.weaponType,
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
  const _LandscapeLayout({Key? key}) : super(key: key);

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
                      name: state.name,
                      image: state.fullImage,
                    ),
                  ),
                  Expanded(
                    flex: 60,
                    child: WeaponDetailBottom(
                      name: state.name,
                      description: state.description,
                      damage: state.damage,
                      accuracy: state.accuracy,
                      control: state.control,
                      fireRate: state.fireRate,
                      range: state.range,
                      mobility: state.mobility,
                      type: state.weaponType,
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


