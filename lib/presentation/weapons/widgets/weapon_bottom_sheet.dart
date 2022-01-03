import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morningstar/application/bloc.dart';
import 'package:morningstar/application/weapons/weapons_bloc.dart';
import 'package:morningstar/presentation/shared/bottom_sheets/common_bottom_sheet.dart';
import 'package:morningstar/presentation/shared/bottom_sheets/common_button_bar.dart';
import 'package:morningstar/presentation/shared/bottom_sheets/right_bottom_sheet.dart';
import 'package:morningstar/presentation/shared/loading.dart';
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
                  selectedValues: state.tempWeaponTypes,
                  onClick: (v) => context.read<WeaponsBloc>().add(WeaponsEvent.weaponTypeChanged(v)),
                ),
                const Text('Others'),
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
              iconSize: 50,
            ),
            Container(margin: Styles.endDrawerFilterItemMargin, child: const Text('Others')),
          ],
        ),
      ),
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

