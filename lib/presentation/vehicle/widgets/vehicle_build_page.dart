import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morningstar/application/bloc.dart';
import 'package:morningstar/domain/enums/enums.dart';
import 'package:morningstar/presentation/shared/loading.dart';
import 'package:morningstar/presentation/shared/sliver_scaffold_with_fab.dart';

import 'vehicle_detail_bottom.dart';
import 'vehicle_detail_top.dart';

class VehicleBuildPage extends StatelessWidget {
  final String name;
  final String image;
  final int rarity;
  final ElementType elementType;

  const VehicleBuildPage({
    Key? key,
    required this.name,
    required this.image,
    required this.rarity,
    required this.elementType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
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
    return BlocBuilder<VehicleBloc, VehicleState>(
      builder: (context, state) {
        return state.map(
          loading: (_) => const Loading(useScaffold: false),
          loaded: (state) => SliverScaffoldWithFab(
            slivers: [
              SliverToBoxAdapter(
                child: Stack(
                  fit: StackFit.passthrough,
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  children: [
                    VehicleDetailTop(
                      name: name,
                      image: image,
                      rarity: rarity,
                    ),
                    VehicleDetailBottom(
                      name: name,
                      rarity: rarity,
                      elementType: elementType,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
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
        child: BlocBuilder<VehicleBloc, VehicleState>(
          builder: (context, state) {
            return state.map(
              loading: (_) => const Loading(useScaffold: false),
              loaded: (state) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 40,
                    child: VehicleDetailTop(
                      name: name,
                      image: image,
                      rarity: rarity,
                    ),
                  ),
                  VehicleDetailBottom(
                    name: name,
                    rarity: rarity,
                    elementType: elementType,
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
