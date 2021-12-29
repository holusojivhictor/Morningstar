import 'package:flutter/material.dart';
import 'package:morningstar/theme.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'widgets/language_settings_card.dart';
import 'widgets/other_settings.dart';
import 'widgets/theme_settings_card.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(
      body: SafeArea(
        child: ResponsiveBuilder(
          builder: (ctx, size) => isPortrait ? const _MobileLayout() : const _DesktopTabletLayout(),
        ),
      ),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  const _MobileLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: Styles.edgeInsetAll10,
      shrinkWrap: true,
      children: const [
        ThemeSettingsCard(),
        LanguageSettingsCard(),
        OtherSettings(),
      ],
    );
  }
}


class _DesktopTabletLayout extends StatelessWidget {
  const _DesktopTabletLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: Styles.edgeInsetAll10,
      shrinkWrap: true,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: const [
                  ThemeSettingsCard(),
                  LanguageSettingsCard(),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: const [
                  OtherSettings(),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
