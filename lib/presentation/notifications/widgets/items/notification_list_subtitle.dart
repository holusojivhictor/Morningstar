import 'package:flutter/material.dart';
import 'package:morningstar/domain/extensions/string_extensions.dart';

import 'notification_list_subtitle_dates.dart';

class NotificationSubtitle extends StatelessWidget {
  final DateTime createdAt;
  final DateTime completesAt;
  final String? note;
  final List<Widget> children;
  final bool useTwentyFourHoursFormat;
  const NotificationSubtitle({
    Key? key,
    required this.createdAt,
    required this.completesAt,
    required this.useTwentyFourHoursFormat,
    this.note,
    this.children = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (note.isNotNullEmptyOrWhitespace)
          Text(
            note!,
            style: theme.textTheme.bodyText1,
            overflow: TextOverflow.ellipsis,
          ),
        ...children,
        NotificationListSubtitleDates(
          createdAt: createdAt,
          completesAt: completesAt,
          useTwentyFourHoursFormat: useTwentyFourHoursFormat,
        ),
      ],
    );
  }
}
