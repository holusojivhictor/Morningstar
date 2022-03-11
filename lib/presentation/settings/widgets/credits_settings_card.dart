import 'package:flutter/material.dart';
import 'package:morningstar/presentation/shared/bullet_link.dart';
import 'package:morningstar/theme.dart';

import 'settings_card_content.dart';

class CreditsSettingsCard extends StatelessWidget {
  const CreditsSettingsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SettingsCardContent(
      title: 'Credits',
      subtitle: 'Contributors',
      icon: const Icon(Icons.info_outline, size: 20),
      child: Container(
        padding: const EdgeInsets.only(top: 5),
        margin: Styles.edgeInsetHorizontal16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text('Making this app would not have been possible without the following contributors', textAlign: TextAlign.center),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Expanded(child: BulletLink(name: 'Efrain', url: '')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
