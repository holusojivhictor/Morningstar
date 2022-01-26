import 'package:flutter/material.dart';
import 'package:morningstar/presentation/home/widgets/card_description.dart';
import 'package:morningstar/presentation/vehicles/vehicles_page.dart';

import 'card_item.dart';

class VehiclePageCard extends StatelessWidget {
  final bool iconToTheLeft;

  const VehiclePageCard({Key? key, required this.iconToTheLeft}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CardItem(
      title: 'Vehicles',
      iconToTheLeft: iconToTheLeft,
      onClick: _goToVehiclesPage,
      icon: Icon(Icons.two_wheeler, size: 60, color: theme.colorScheme.secondary),
      children: const [
        CardDescription(text: 'Check out the Vehicles in Battle Royale.')
      ],
    );
  }

  Future<void> _goToVehiclesPage(BuildContext context) async {
    final route = MaterialPageRoute(builder: (c) => const VehiclesPage());
    await Navigator.push(context, route);
    await route.completed;
  }
}