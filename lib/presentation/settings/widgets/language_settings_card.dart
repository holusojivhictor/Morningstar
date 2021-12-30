import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morningstar/application/bloc.dart';
import 'package:morningstar/domain/assets.dart';
import 'package:morningstar/domain/enums/enums.dart';
import 'package:morningstar/presentation/shared/common_dropdown_button.dart';
import 'package:morningstar/presentation/shared/loading.dart';
import 'package:morningstar/presentation/shared/utils/enum_utils.dart';
import 'package:morningstar/presentation/shared/utils/toast_utils.dart';
import 'package:morningstar/theme.dart';

import 'settings_card.dart';

class LanguageSettingsCard extends StatelessWidget {
  const LanguageSettingsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SettingsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Icon(Icons.language, size: 20),
              Container(
                margin: const EdgeInsets.only(left: 5),
                child: Text(
                  'Language',
                  style: theme.textTheme.headline6,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(top: 5),
            child: Text(
              'Choose a language',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) => state.map(
              loading: (_) => const Loading(useScaffold: false),
              loaded: (state) => Padding(
                padding: Styles.edgeInsetHorizontal16,
                child: CommonDropdownButton<AppLanguageType>(
                  hint: 'Choose a language',
                  currentValue: state.currentLanguage,
                  values: EnumUtils.getTranslatedAndSortedEnum<AppLanguageType>(AppLanguageType.values, (val, _) => Assets.translateAppLanguageType(val)),
                  onChanged: _languageChanged,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _languageChanged(AppLanguageType newValue, BuildContext context) {
    final fToast = ToastUtils.of(context);
    ToastUtils.showInfoToast(fToast, 'A restart may be needed for the changes to take effect');
    context.read<SettingsBloc>().add(SettingsEvent.languageChanged(newValue: newValue));
  }
}
