import 'package:flutter/material.dart';

class NothingFound extends StatelessWidget {
  final String? msg;
  final IconData icon;
  final EdgeInsets padding;
  const NothingFound({
    Key? key,
    this.msg,
    this.icon = Icons.info,
    this.padding = const EdgeInsets.only(bottom: 30, right: 20, left: 20),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: padding,
      child: Center(
        child: Column(
          children: <Widget>[
            Icon(
              icon,
              color: theme.primaryColor,
              size: 60,
            ),
            Text(
              msg ?? 'Nothing to show',
              textAlign: TextAlign.center,
              style: theme.textTheme.headline6,
            ),
          ],
        ),
      ),
    );
  }
}
