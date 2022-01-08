import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morningstar/application/bloc.dart';
import 'package:morningstar/application/weapons/weapons_bloc.dart';
import 'package:morningstar/domain/assets.dart';
import 'package:morningstar/domain/enums/enums.dart';
import 'package:morningstar/presentation/shared/bottom_sheets/common_bottom_sheet.dart';
import 'package:morningstar/presentation/shared/bottom_sheets/common_button_bar.dart';
import 'package:morningstar/presentation/shared/bottom_sheets/right_bottom_sheet.dart';
import 'package:morningstar/presentation/shared/item_popupmenu_filter.dart';
import 'package:morningstar/presentation/shared/loading.dart';
import 'package:morningstar/presentation/shared/sort_direction_popumenu_filter.dart';
import 'package:morningstar/presentation/shared/weapons_button_bar.dart';
import 'package:morningstar/theme.dart';
import 'package:responsive_builder/responsive_builder.dart';

class WeaponBottomSheet extends StatelessWidget {
  const WeaponBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final forEndDrawer = getDeviceType(MediaQuery.of(context).size) != DeviceScreenType.mobile;
    if (!forEndDrawer) {
      return CommonBottomSheet(
        title: 'Filters',
        titleIcon: Icons.sort,
        showOkButton: false,
        showCancelButton: false,
        child: BlocBuilder<WeaponsBloc, WeaponsState>(
          builder: (context, state) => state.map(
            loading: (_) => const Loading(),
            loaded: (state) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text('Type'),
                WeaponsButtonBar(
                  iconSize: 50,
                  selectedValues: state.tempWeaponTypes,
                  onClick: (v) => context.read<WeaponsBloc>().add(WeaponsEvent.weaponTypeChanged(v)),
                ),
                const Text('Others'),
                _OtherFilters(
                  tempWeaponFilterType: state.tempWeaponFilterType,
                  tempSortDirectionType: state.tempSortDirectionType,
                ),
                const _ButtonBar(),
              ],
            ),
          ),
        ),
      );
    }

    return BlocBuilder<WeaponsBloc, WeaponsState>(
      builder: (ctx, state) => state.map(
        loading: (_) => const Loading(useScaffold: false),
        loaded: (state) => RightBottomSheet(
          bottom: const _ButtonBar(),
          children: [
            Container(margin: Styles.endDrawerFilterItemMargin, child: const Text('Type')),
            WeaponsButtonBar(
              selectedValues: state.weaponTypes,
              onClick: (v) => context.read<WeaponsBloc>().add(WeaponsEvent.weaponTypeChanged(v)),
              iconSize: 60,
            ),
            Container(margin: Styles.endDrawerFilterItemMargin, child: const Text('Others')),
            _OtherFilters(
              tempWeaponFilterType: state.tempWeaponFilterType,
              tempSortDirectionType: state.tempSortDirectionType,
              forEndDrawer: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _OtherFilters extends StatelessWidget {
  final WeaponFilterType tempWeaponFilterType;
  final SortDirectionType tempSortDirectionType;
  final bool forEndDrawer;

  const _OtherFilters({
    Key? key,
    required this.tempWeaponFilterType,
    required this.tempSortDirectionType,
    this.forEndDrawer = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonButtonBar(
      alignment: WrapAlignment.spaceEvenly,
      children: [
        ItemPopupMenuFilter<WeaponFilterType>(
          toolTipText: 'Sort by',
          onSelected: (v) => context.read<WeaponsBloc>().add(WeaponsEvent.weaponFilterTypeChanged(v)),
          selectedValue: tempWeaponFilterType,
          values: WeaponFilterType.values,
          itemText: (val, _) => Assets.translateWeaponFilterType(val),
          icon: Icon(Icons.filter_list, size: Styles.getIconSizeForItemPopupMenuFilter(forEndDrawer, true)),
        ),
        SortDirectionPopupMenuFilter(
          selectedSortDirection: tempSortDirectionType,
          onSelected: (v) => context.read<WeaponsBloc>().add(WeaponsEvent.sortDirectionChanged(v)),
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
            context.read<WeaponsBloc>().add(const WeaponsEvent.cancelChanges());
            Navigator.pop(context);
          },
          child: Text('Cancel', style: TextStyle(color: theme.primaryColor)),
        ),
        OutlinedButton(
          onPressed: () {
            context.read<WeaponsBloc>().add(const WeaponsEvent.resetFilters());
            Navigator.pop(context);
          },
          child: Text('Reset', style: TextStyle(color: theme.primaryColor)),
        ),
        ElevatedButton(
          onPressed: () {
            context.read<WeaponsBloc>().add(const WeaponsEvent.applyFilterChanges());
            Navigator.pop(context);
          },
          child: const Text('Ok'),
        ),
      ],
    );
  }
}

