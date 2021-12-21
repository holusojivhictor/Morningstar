import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morningstar/application/bloc.dart';
import 'package:morningstar/presentation/home/widgets/card_item.dart';
import 'package:morningstar/presentation/inventory/inventory_page.dart';

import 'card_description.dart';

class MyInventoryCard extends StatelessWidget {
  final bool iconToTheLeft;
  const MyInventoryCard({
    Key? key,
    required this.iconToTheLeft,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CardItem(
      title: 'My Inventory',
      iconToTheLeft: iconToTheLeft,
      icon: Icon(Icons.inventory, size: 60, color: theme.colorScheme.secondary),
      onClick: _goToInventoryPage,
      children: const [
        CardDescription(text: 'Add the items you have in the game'),
      ],
    );
  }

  Future<void> _goToInventoryPage(BuildContext context) async {
    context.read<InventoryBloc>().add(const InventoryEvent.init());
    final route = MaterialPageRoute(builder: (c) => const InventoryPage());
    await Navigator.push(context, route);
    await route.completed;
    context.read<InventoryBloc>().add(const InventoryEvent.close());
  }
}
