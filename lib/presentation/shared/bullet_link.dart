import 'package:flutter/material.dart';
import 'package:morningstar/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class BulletLink extends StatelessWidget {
  final String name;
  final Widget icon;
  final String url;
  final double fontSize;
  final bool hint;
  const BulletLink({
    Key? key,
    required this.name,
    required this.url,
    this.icon = const Icon(Icons.fiber_manual_record, size: 15),
    this.fontSize = 11,
    this.hint = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.only(left: 10),
      visualDensity: const VisualDensity(vertical: -4),
      onTap: () => _launchUrl(url),
      leading: icon,
      title: Transform.translate(
        offset: Styles.listItemWithIconOffset,
        child: Tooltip(message: hint ? 'My favorite!' : name, child: Text(name, style: theme.textTheme.bodyText2!.copyWith(fontSize: fontSize))),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}
