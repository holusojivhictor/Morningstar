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

class ThemeSettingsCard extends StatelessWidget {
  const ThemeSettingsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SettingsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Icon(Icons.color_lens),
              Container(
                margin: const EdgeInsets.only(left: 5),
                child: Text(
                  'Theme',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(top: 5),
            child: Text(
              'Choose base app theme',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) => state.map(
              loading: (_) => const Loading(useScaffold: false),
              loaded: (state) => Padding(
                padding: Styles.edgeInsetHorizontal16,
                child: CommonDropdownButton<AppThemeType>(
                  hint: 'Choose base app theme',
                  currentValue: state.currentTheme,
                  values: EnumUtils.getTranslatedAndSortedEnum<AppThemeType>(AppThemeType.values, (val, _) => Assets.translateAppThemeType(val)),
                  onChanged: _appThemeChanged,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _appThemeChanged(AppThemeType newValue, BuildContext context) {
    context.read<SettingsBloc>().add(SettingsEvent.themeChanged(newValue: newValue));
  }
}
