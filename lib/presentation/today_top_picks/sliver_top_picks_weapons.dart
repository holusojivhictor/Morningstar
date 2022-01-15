import 'package:flutter/material.dart';
import 'package:morningstar/domain/models/models.dart';
import 'package:morningstar/presentation/weapons/widgets/weapon_card.dart';
import 'package:morningstar/theme.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:responsive_grid/responsive_grid.dart';

class SliverTopPicksWeapons extends StatelessWidget {
  final List<TodayTopPickWeaponModel> topPicksWeapons;
  final bool useListView;

  const SliverTopPicksWeapons({
    Key? key,
    required this.topPicksWeapons,
    this.useListView = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (useListView) {
      return SliverToBoxAdapter(
        child: SizedBox(
          height: Styles.materialWeaponCardHeight,
          child: ListView.builder(
            itemCount: topPicksWeapons.length,
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemBuilder: (ctx, index) {
              final e = topPicksWeapons[index];
              return WeaponCard.days(topPick: e);
            },
          ),
        ),
      );
    }

    final mediaQuery = MediaQuery.of(context);
    final deviceType = getDeviceType(mediaQuery.size);
    final isPortrait = mediaQuery.orientation == Orientation.portrait;
    return SliverToBoxAdapter(
      child: ResponsiveGridRow(
        children: topPicksWeapons.map((e) {
          final child = WeaponCard.days(topPick: e);

          switch (deviceType) {
            case DeviceScreenType.mobile:
              return ResponsiveGridCol(
                sm: isPortrait ? 12 : 6,
                md: isPortrait ? 6 : 4,
                xs: isPortrait ? 6 : 3,
                xl: isPortrait ? 3 : 2,
                child: child,
              );
            case DeviceScreenType.desktop:
            case DeviceScreenType.tablet:
              return ResponsiveGridCol(
                sm: isPortrait ? 3 : 4,
                md: isPortrait ? 4 : 3,
                xs: 3,
                xl: 3,
                child: child,
              );
            default:
              return ResponsiveGridCol(sm: 4, md: 3, xs: 4, xl: 3,child: child);
          }
        }).toList(),
      ),
    );
  }
}
