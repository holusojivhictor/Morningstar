import 'package:flutter/material.dart';
import 'package:morningstar/presentation/home/widgets/card_description.dart';
import 'package:morningstar/presentation/notifications/notifications_page.dart';

import 'card_item.dart';

class NotificationsCard extends StatelessWidget {
  final bool iconToTheLeft;
  const NotificationsCard({
    Key? key,
    required this.iconToTheLeft,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CardItem(
      title: 'Notifications',
      onClick: (context) => _goToNotificationsPage(context),
      iconToTheLeft: iconToTheLeft,
      icon: Icon(Icons.notifications, color: theme.colorScheme.secondary, size: 60),
      children: const [
        CardDescription(text: 'Create your own custom notifications'),
      ],
    );
  }

  Future<void> _goToNotificationsPage(BuildContext context) async {
    final route = MaterialPageRoute(builder: (c) => const NotificationsPage());
    await Navigator.push(context, route);
    await route.completed;
  }
}
