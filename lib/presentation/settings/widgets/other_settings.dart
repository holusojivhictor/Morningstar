import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morningstar/application/bloc.dart';
import 'package:morningstar/domain/assets.dart';
import 'package:morningstar/domain/enums/enums.dart';
import 'package:morningstar/presentation/shared/common_dropdown_button.dart';
import 'package:morningstar/presentation/shared/loading.dart';
import 'package:morningstar/presentation/shared/utils/enum_utils.dart';
import 'package:morningstar/theme.dart';

import 'settings_card.dart';

class OtherSettings extends StatelessWidget {
  const OtherSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SettingsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Icon(Icons.build),
              Container(
                margin: const EdgeInsets.only(left: 5),
                child: Text('Others', style: theme.textTheme.headline6),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(top: 5),
            child: Text(
              'General Settings',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) => state.map(
              loading: (_) => const Loading(useScaffold: false),
              loaded: (settingsState) => Column(
                children: [
                  SwitchListTile(
                    activeColor: theme.colorScheme.secondary,
                    title: const Text('Show soldier details'),
                    value: settingsState.showSoldierDetails,
                    onChanged: (newVal) => context.read<SettingsBloc>().add(SettingsEvent.showSoldierDetailsChanged(newValue: newVal)),
                  ),
                  SwitchListTile(
                    activeColor: theme.colorScheme.secondary,
                    title: const Text('Show weapon details'),
                    value: settingsState.showWeaponDetails,
                    onChanged: (newVal) => context.read<SettingsBloc>().add(SettingsEvent.showWeaponDetailsChanged(newValue: newVal)),
                  ),
                  SwitchListTile(
                    activeColor: theme.colorScheme.secondary,
                    title: const Text('Press back twice to exit'),
                    value: settingsState.doubleBackToClose,
                    onChanged: (newVal) => context.read<SettingsBloc>().add(SettingsEvent.doubleBackToCloseChanged(newValue: newVal)),
                  ),
                  SwitchListTile(
                    activeColor: theme.colorScheme.secondary,
                    title: const Text('Use 24 hours format on dates'),
                    value: settingsState.useTwentyFourHoursFormat,
                    onChanged: (newVal) => context.read<SettingsBloc>().add(SettingsEvent.useTwentyFourHoursFormat(newValue: newVal)),
                  ),
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Padding(
                      padding: Styles.edgeInsetHorizontal16,
                      child: CommonDropdownButton<AppServerResetTimeType>(
                        hint: 'Choose a server',
                        currentValue: settingsState.serverResetTime,
                        values: EnumUtils.getTranslatedAndSortedEnum<AppServerResetTimeType>(
                          AppServerResetTimeType.values, (val, _) => Assets.translateAppServerResetTimeType(val),
                        ),
                        onChanged: (v, context) => context.read<SettingsBloc>().add(SettingsEvent.serverResetTimeChanged(newValue: v)),
                      ),
                    ),
                    subtitle: Container(
                      margin: const EdgeInsets.only(left: 25),
                      child: Transform.translate(
                        offset: const Offset(0, -10),
                        child: const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'The server where you play',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
