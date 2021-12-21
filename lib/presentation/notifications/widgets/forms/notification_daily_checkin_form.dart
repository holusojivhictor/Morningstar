import 'package:flutter/material.dart';
import 'package:morningstar/domain/enums/enums.dart';
import 'package:morningstar/domain/models/models.dart';
import 'package:morningstar/presentation/notifications/widgets/forms/notification_circle_item.dart';
import 'package:morningstar/presentation/notifications/widgets/forms/notification_dropdown_type.dart';
import 'package:morningstar/presentation/notifications/widgets/forms/notification_note.dart';
import 'package:morningstar/presentation/notifications/widgets/forms/notification_switch.dart';
import 'package:morningstar/presentation/notifications/widgets/forms/notification_title_body.dart';

class NotificationDailyCheckInForm extends StatelessWidget {
  final String title;
  final String body;
  final String note;
  final bool showNotification;
  final bool isInEditMode;
  final List<NotificationItemImage> images;
  final bool showOtherImages;

  const NotificationDailyCheckInForm({
    Key? key,
    required this.title,
    required this.body,
    required this.note,
    required this.showNotification,
    required this.isInEditMode,
    required this.images,
    required this.showOtherImages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        NotificationCircleItem(type: AppNotificationType.dailyCheckIn, images: images, showOtherImages: showOtherImages),
        NotificationDropdownType(selectedValue: AppNotificationType.dailyCheckIn, isInEditMode: isInEditMode),
        Container(
          margin: const EdgeInsets.only(top: 15),
          child: NotificationTitleBody(title: title, body: body),
        ),
        NotificationNote(note: note),
        NotificationSwitch(showNotification: showNotification),
      ],
    );
  }
}
