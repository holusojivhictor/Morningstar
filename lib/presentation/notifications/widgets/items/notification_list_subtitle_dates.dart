import 'package:flutter/material.dart';
import 'package:morningstar/domain/utils/date_utils.dart' as utils;

class NotificationListSubtitleDates extends StatelessWidget {
  final DateTime createdAt;
  final DateTime completesAt;
  final bool useTwentyFourHoursFormat;
  const NotificationListSubtitleDates({
    Key? key,
    required this.createdAt,
    required this.completesAt,
    required this.useTwentyFourHoursFormat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: RichText(
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              children: [
                WidgetSpan(
                  child: Container(
                    margin: const EdgeInsets.only(right: 5),
                    child: const Icon(Icons.date_range, size: 13),
                  ),
                ),
                TextSpan(
                  text: utils.DateUtils.formatDateMilitaryTime(createdAt, useTwentyFourHoursFormat: useTwentyFourHoursFormat),
                  style: theme.textTheme.bodyText2,
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: RichText(
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            text: TextSpan(
              children: [
                WidgetSpan(
                  child: Container(
                    margin: const EdgeInsets.only(right: 5),
                    child: const Icon(Icons.notifications_active, size: 13),
                  ),
                ),
                TextSpan(
                  text: utils.DateUtils.formatDateMilitaryTime(completesAt, useTwentyFourHoursFormat: useTwentyFourHoursFormat),
                  style: theme.textTheme.bodyText2,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
