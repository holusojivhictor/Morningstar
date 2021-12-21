import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morningstar/application/bloc.dart';
import 'package:morningstar/domain/assets.dart';
import 'package:morningstar/domain/enums/enums.dart';
import 'package:morningstar/presentation/shared/bottom_sheets/common_bottom_sheet.dart';
import 'package:morningstar/presentation/shared/bottom_sheets/common_button_bar.dart';
import 'package:morningstar/presentation/shared/bottom_sheets/right_bottom_sheet.dart';
import 'package:morningstar/presentation/shared/elements_button_bar.dart';
import 'package:morningstar/presentation/shared/item_popupmenu_filter.dart';
import 'package:morningstar/presentation/shared/loading.dart';
import 'package:morningstar/presentation/shared/rarity_rating.dart';
import 'package:morningstar/presentation/shared/sort_direction_popumenu_filter.dart';
import 'package:morningstar/theme.dart';
import 'package:responsive_builder/responsive_builder.dart';

class SoldierBottomSheet extends StatelessWidget {
  const SoldierBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final forEndDrawer = getDeviceType(MediaQuery.of(context).size) != DeviceScreenType.mobile;
    if (!forEndDrawer) {
      return CommonBottomSheet(
        title: 'Filters',
        titleIcon: Icons.sort,
        showCancelButton: false,
        showOkButton: false,
        child: BlocBuilder<SoldiersBloc, SoldiersState>(
          builder: (context, state) => state.map(
            loading: (_) => const Loading(useScaffold: false),
            loaded: (state) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text('Elements'),
                ElementsButtonBar(
                  selectedValues: state.tempElementTypes,
                  onClick: (v) => context.read<SoldiersBloc>().add(SoldiersEvent.elementTypeChanged(v)),
                ),
                const Text('Rarity'),
                RarityRating(
                  rarity: state.rarity,
                  onRated: (v) => context.read<SoldiersBloc>().add(SoldiersEvent.rarityChanged(v)),
                  stars: 5,
                ),
                const Text('Others'),
                _OtherFilters(
                  tempSoldierFilterType: state.tempSoldierFilterType,
                  tempSortDirectionType: state.tempSortDirectionType,
                  tempStatusType: state.tempStatusType,
                ),
                const _ButtonBar(),
              ],
            ),
          ),
        ),
      );
    }

    return BlocBuilder<SoldiersBloc, SoldiersState>(
      builder: (ctx, state) => state.map(
        loading: (_) => const Loading(useScaffold: false),
        loaded: (state) => RightBottomSheet(
          bottom: const _ButtonBar(),
          children: [
            Container(margin: Styles.endDrawerFilterItemMargin, child: const Text('Elements')),
            ElementsButtonBar(
              selectedValues: state.tempElementTypes,
              iconSize: Styles.endDrawerIconSize,
              onClick: (v) => context.read<SoldiersBloc>().add(SoldiersEvent.elementTypeChanged(v)),
            ),
            Container(margin: Styles.endDrawerFilterItemMargin, child: const Text('Rarity')),
            RarityRating(
              rarity: state.rarity,
              size: Styles.endDrawerIconSize,
              onRated: (v) => context.read<SoldiersBloc>().add(SoldiersEvent.rarityChanged(v)),
              stars: 5,
            ),
            Container(margin: Styles.endDrawerFilterItemMargin, child: const Text('Others')),
            _OtherFilters(
              tempSoldierFilterType: state.tempSoldierFilterType,
              tempSortDirectionType: state.tempSortDirectionType,
              tempStatusType: state.tempStatusType,
              forEndDrawer: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _OtherFilters extends StatelessWidget {
  final ItemStatusType? tempStatusType;
  final SoldierFilterType tempSoldierFilterType;
  final SortDirectionType tempSortDirectionType;
  final bool forEndDrawer;
  const _OtherFilters({
    Key? key,
    required this.tempStatusType,
    required this.tempSoldierFilterType,
    required this.tempSortDirectionType,
    this.forEndDrawer = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonButtonBar(
      spacing: 5,
      alignment: WrapAlignment.spaceBetween,
      children: [
        ItemPopupMenuFilterWithAllValue(
          toolTipText: 'Released / New / Coming Soon',
          values: ItemStatusType.values.map((e) => e.index).toList(),
          selectedValue: tempStatusType?.index,
          onAllOrValueSelected: (v) => context.read<SoldiersBloc>().add(SoldiersEvent.itemStatusChanged(v != null ? ItemStatusType.values[v] : null)),
          icon: Icon(Icons.tune, size: Styles.getIconSizeForItemPopupMenuFilter(forEndDrawer, true)),
          itemText: (val, _) => Assets.translateReleasedUnreleasedType(ItemStatusType.values[val]),
        ),
        ItemPopupMenuFilter<SoldierFilterType>(
          toolTipText: 'Sort by',
          selectedValue: tempSoldierFilterType,
          values: SoldierFilterType.values,
          onSelected: (v) => context.read<SoldiersBloc>().add(SoldiersEvent.soldierFilterTypeChanged(v)),
          itemText: (val ,_) => Assets.translateSoldierFilterType(val),
          icon: Icon(Icons.filter_list, size: Styles.getIconSizeForItemPopupMenuFilter(forEndDrawer, true)),
        ),
        SortDirectionPopupMenuFilter(
          selectedSortDirection: tempSortDirectionType,
          onSelected: (v) => context.read<SoldiersBloc>().add(SoldiersEvent.sortDirectionTypeChanged(v)),
          icon: Icon(Icons.sort, size: Styles.getIconSizeForItemPopupMenuFilter(forEndDrawer, true)),
        ),
      ],
    );
  }
}


class _ButtonBar extends StatelessWidget {
  const _ButtonBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CommonButtonBar(
      children: <Widget>[
        OutlinedButton(
          onPressed: () {
            context.read<SoldiersBloc>().add(const SoldiersEvent.cancelChanges());
            Navigator.pop(context);
          },
          child: Text('Cancel', style: TextStyle(color: theme.primaryColor)),
        ),
        OutlinedButton(
          onPressed: () {
            context.read<SoldiersBloc>().add(const SoldiersEvent.resetFilters());
            Navigator.pop(context);
          },
          child: Text('Reset', style: TextStyle(color: theme.primaryColor)),
        ),
        OutlinedButton(
          onPressed: () {
            context.read<SoldiersBloc>().add(const SoldiersEvent.applyFilterChanges());
            Navigator.pop(context);
          },
          child: const Text('Ok'),
        ),
      ],
    );
  }
}

