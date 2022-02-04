import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morningstar/application/bloc.dart';
import 'package:morningstar/domain/app_constants.dart';
import 'package:morningstar/presentation/shared/dialogs/changelog_dialog.dart';
import 'package:morningstar/presentation/shared/loading.dart';
import 'package:morningstar/presentation/shared/text_link.dart';
import 'package:morningstar/theme.dart';

import 'settings_card.dart';

class AboutSettingsCard extends StatelessWidget {
  const AboutSettingsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SettingsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Icon(Icons.info_outline, size: 20),
              Container(
                margin: const EdgeInsets.only(left: 5),
                child: Text(
                  'About',
                  style: theme.textTheme.headline6,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(top: 5),
            child: Text(
              'App information',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          Container(
            margin: Styles.edgeInsetHorizontal16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 40,
                    child: ClipOval(child: Image.asset(Styles.appIconPath)),
                  ),
                ),
                Text(
                  'MorningStar',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyText1,
                ),
                BlocBuilder<SettingsBloc, SettingsState>(
                  builder: (context, state) {
                    return state.map(
                      loading: (_) => const Loading(useScaffold: false),
                      loaded: (state) => Text(
                        'Version: ${state.appVersion}',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyText1,
                      ),
                    );
                  },
                ),
                const Text('A CODM guide/database app.', textAlign: TextAlign.center),
                TextLink.withoutLink(
                  text: 'Changelog',
                  onTap: () => showDialog(context: context, builder: (ctx) => const ChangelogDialog()),
                ),
                const TextLink(text: 'Discord server', url: ''),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Text(
                    'Disclaimer',
                    style: theme.textTheme.headline4!.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: const Text('This app is not affiliated or endorsed by Activision, the creators of Call of Duty Mobile. This is just supposed to be a guide app of sorts.'),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Text(
                    'Privacy',
                    style: theme.textTheme.headline4!.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: const [
                      Text('This app does not collect any personal data or information that could be used to track or identify you, the user.'),
                      Text('The only collected data are crashes and app usage. This information is useful for identifying and fixing bugs. It is also useful to identify which features are the most used within the app and which ones should be prioritized.'),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Text(
                    'Support',
                    style: theme.textTheme.headline4!.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: const Text('This app is open source and up on GitHub. If you would like to help in anyway like report an issue or suggest a feature to be implemented, please open an issue on GitHub.'),
                ),
                const TextLink(text: 'GitHub', url: '$githubPage/issues'),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: const Text('You can also send me an email:', textAlign: TextAlign.center),
                ),
                const TextLink(text: 'holusojivhictor@gmail.com', url: 'mailto:holusojivhictor@gmail.com?subject=Subject&body=Hello'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
