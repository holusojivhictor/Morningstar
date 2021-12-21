import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morningstar/application/bloc.dart';
import 'package:morningstar/presentation/shared/details/detail_bottom_portrait_layout.dart';
import 'package:morningstar/presentation/shared/details/detail_tab_landscape_layout.dart';
import 'package:morningstar/presentation/shared/item_description_detail.dart';
import 'package:morningstar/presentation/shared/extensions/element_type_extensions.dart';
import 'package:morningstar/presentation/shared/loading.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'soldier_detail_general_card.dart';

class SoldierDetailBottom extends StatelessWidget {
  const SoldierDetailBottom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return isPortrait ? const _PortraitLayout(soldierDescriptionHeight: 120) : const _LandscapeLayout();
  }
}

class _PortraitLayout extends StatelessWidget {
  final double soldierDescriptionHeight;
  const _PortraitLayout({
    Key? key,
    this.soldierDescriptionHeight = 150,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isPortrait = mediaQuery.orientation == Orientation.portrait;
    final device = getDeviceType(mediaQuery.size);
    final descriptionWidth = (mediaQuery.size.width / (isPortrait ? 1 : 2)) / (device == DeviceScreenType.mobile ? 1.2 : 1.5);
    final theme = Theme.of(context);

    return BlocBuilder<SoldierBloc, SoldierState>(
      builder: (ctx, state) => state.map(
        loading: (_) => const Loading(useScaffold: false),
        loaded: (state) => DetailBottomPortraitLayout(
          isASmallImage: false,
          children: [
            SizedBox(
              height: soldierDescriptionHeight,
              width: descriptionWidth,
              child: SoldierDetailGeneralCard(
                elementType: state.elementType,
                name: state.name,
                rarity: state.rarity,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: ItemDescriptionDetail(
                title: 'Description',
                body: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    'No description available for this soldier.',
                    style: theme.textTheme.headline3,
                  ),
                ),
                textColor: state.elementType.getElementColorFromContext(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LandscapeLayout extends StatelessWidget {
  const _LandscapeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tabs = [
      'Description',
    ];
    return BlocBuilder<SoldierBloc, SoldierState>(
      builder: (ctx, state) => state.map(
        loading: (_) => const Loading(),
        loaded: (state) => DetailTabLandscapeLayout(
          color: state.elementType.getElementColorFromContext(context),
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
                      body: Container(margin: const EdgeInsets.symmetric(horizontal: 5), child: const Text('No description available')),
                      textColor: state.elementType.getElementColorFromContext(context),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

