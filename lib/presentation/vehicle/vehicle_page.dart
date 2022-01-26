import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morningstar/application/bloc.dart';
import 'package:morningstar/domain/enums/enums.dart';
import 'package:morningstar/presentation/shared/item_description_detail.dart';
import 'package:morningstar/presentation/shared/loading.dart';
import 'package:morningstar/presentation/shared/sliver_scaffold_with_fab.dart';
import 'package:morningstar/presentation/vehicle/widgets/vehicle_detail_camo_build.dart';
import 'package:morningstar/presentation/vehicle/widgets/vehicle_detail_top.dart';
import 'package:morningstar/presentation/shared/extensions/element_type_extensions.dart';

import 'widgets/vehicle_detail_bottom.dart';

class VehiclePage extends StatelessWidget {
  const VehiclePage({Key? key}) : super(key: key);

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
    return BlocBuilder<VehicleBloc, VehicleState>(
      builder: (context, state) {
        return state.map(
          loading: (_) => const Loading(),
          loaded: (state) => SliverScaffoldWithFab(
            backgroundColor: Theme.of(context).cardColor,
            slivers: [
              SliverToBoxAdapter(
                child: Stack(
                  fit: StackFit.passthrough,
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  children: [
                    VehicleDetailTop(
                      name: state.name,
                      image: state.imageUrl,
                      useMargin: true,
                    ),
                    VehicleDetailBottom(
                      name: state.name,
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ItemDescriptionTitle(
                    title: 'Camos',
                    textColor: ElementType.common.getElementColorFromContext(context),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                sliver: VehicleDetailCamoBuild(
                  camos: state.camos,
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
  const _LandscapeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<VehicleBloc, VehicleState>(
          builder: (context, state) {
            return state.map(
              loading: (_) => const Loading(),
              loaded: (state) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 40,
                    child: VehicleDetailTop(
                      name: state.name,
                      image: state.imageUrl,
                    ),
                  ),
                  Expanded(
                    flex: 60,
                    child: VehicleDetailBottom(
                      name: state.name,
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
