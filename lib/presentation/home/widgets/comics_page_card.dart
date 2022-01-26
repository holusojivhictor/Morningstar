import 'package:flutter/material.dart';
import 'package:morningstar/presentation/comics/comics_page.dart';
import 'package:morningstar/presentation/home/widgets/card_description.dart';

import 'card_item.dart';

class ComicsPageCard extends StatelessWidget {
  final bool iconToTheLeft;

  const ComicsPageCard({Key? key, required this.iconToTheLeft}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CardItem(
      title: 'Comics',
      iconToTheLeft: iconToTheLeft,
      onClick: _goToComicsPage,
      icon: Icon(Icons.style, size: 60, color: theme.colorScheme.secondary),
      children: const [
        CardDescription(text: 'Read the in-game seasonal comics.')
      ],
    );
  }

  Future<void> _goToComicsPage(BuildContext context) async {
    final route = MaterialPageRoute(builder: (c) => const ComicsPage());
    await Navigator.push(context, route);
    await route.completed;
  }
}