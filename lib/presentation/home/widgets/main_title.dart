import 'package:flutter/material.dart';
import 'package:morningstar/theme.dart';

class MainTitle extends StatelessWidget {
  final String title;
  const MainTitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: Styles.edgeInsetHorizontal16,
      child: Text(
        title,
        style: theme.textTheme.headline2!.copyWith(
          fontWeight: FontWeight.bold,
          letterSpacing: 0.15,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
