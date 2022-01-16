import 'package:flutter/material.dart';
import 'package:morningstar/presentation/home/widgets/card_description.dart';
import 'package:morningstar/presentation/tier_list/tier_list_page.dart';

import 'card_item.dart';

class TierListCard extends StatelessWidget {
  final bool iconToTheLeft;

  const TierListCard({Key? key, required this.iconToTheLeft}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CardItem(
      title: 'Tier List Builder',
      iconToTheLeft: iconToTheLeft,
      onClick: _goToTierListPage,
      icon: Icon(Icons.category_outlined, size: 60, color: theme.colorScheme.secondary),
      children: const [
        CardDescription(text: 'Build your own weapon tier list'),
      ],
    );
  }

  Future<void> _goToTierListPage(BuildContext context) async {
    final route = MaterialPageRoute(builder: (c) => const TierListPage());
    await Navigator.push(context, route);
    await route.completed;
  }
}
