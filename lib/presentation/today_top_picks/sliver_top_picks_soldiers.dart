import 'package:flutter/material.dart';
import 'package:morningstar/domain/models/home/today_top_pick_soldier_model.dart';
import 'package:morningstar/presentation/shared/utils/size_utils.dart';
import 'package:morningstar/presentation/soldiers/widgets/soldier_card.dart';
import 'package:morningstar/theme.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:responsive_grid/responsive_grid.dart';

class SliverTopPicksSoldiers extends StatelessWidget {
  final List<TodayTopPickSoldierModel> topPicksSoldiers;
  final bool useListView;

  const SliverTopPicksSoldiers({
    Key? key,
    required this.topPicksSoldiers,
    this.useListView = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (useListView) {
      final mediaQuery = MediaQuery.of(context);
      final isPortrait = mediaQuery.orientation == Orientation.portrait;
      return SliverToBoxAdapter(
        child: SizedBox(
          height: Styles.materialCardHeight,
          child: ListView.builder(
            itemCount: topPicksSoldiers.length,
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemBuilder: (ctx, index) {
              final e = topPicksSoldiers[index];
              return SoldierCard.days(topPick: e, width: SizeUtils.getWidthForHomeCard(context));
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
        children: topPicksSoldiers.map((e) {
          final child = SoldierCard.days(topPick: e, width: SizeUtils.getWidthForHomeCard(context));

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
