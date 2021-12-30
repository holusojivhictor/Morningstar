import 'package:flutter/material.dart';

import 'settings_card.dart';

class SettingsCardContent extends StatelessWidget {
  final String title;
  final String subtitle;
  final Icon icon;
  final Widget child;

  const SettingsCardContent({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SettingsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              icon,
              Container(
                margin: const EdgeInsets.only(left: 5),
                child: Text(title, style: textTheme.headline6),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              subtitle,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
