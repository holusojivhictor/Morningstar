import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morningstar/application/bloc.dart';

class NotificationSwitch extends StatelessWidget {
  final bool showNotification;
  const NotificationSwitch({Key? key, required this.showNotification}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: const Text('Show notification'),
      value: showNotification,
      onChanged: (newValue) => context.read<NotificationBloc>().add(NotificationEvent.showNotificationChanged(show: newValue)),
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: theme.colorScheme.secondary,
    );
  }
}
