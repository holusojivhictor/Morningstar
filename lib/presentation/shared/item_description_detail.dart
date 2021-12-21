import 'package:flutter/material.dart';
import 'package:morningstar/presentation/shared/images/cod_icon.dart';
import 'package:morningstar/theme.dart';

class ItemDescriptionDetail extends StatelessWidget {
  final String title;
  final Widget? body;
  final Color textColor;
  const ItemDescriptionDetail({
    Key? key,
    required this.title,
    this.body,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ItemDescriptionTitle(title: title, textColor: textColor),
        if (body != null) body!,
      ],
    );
  }
}

class ItemDescriptionTitle extends StatelessWidget {
  final String title;
  final Color textColor;
  const ItemDescriptionTitle({
    Key? key,
    required this.title,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      visualDensity: VisualDensity.compact,
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: const CodIcon(),
      title: Transform.translate(
        offset: Styles.listItemWithIconOffset,
        child: Tooltip(
          message: title,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title,
                style: theme.textTheme.headline6!.copyWith(color: textColor, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
