import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morningstar/application/bloc.dart';
import 'package:morningstar/domain/assets.dart';
import 'package:morningstar/domain/enums/enums.dart';
import 'package:morningstar/domain/models/models.dart';
import 'package:morningstar/domain/utils/date_utils.dart' as utils;
import 'package:morningstar/presentation/notifications/widgets/forms/notification_circle_item.dart';
import 'package:morningstar/presentation/notifications/widgets/forms/notification_dropdown_type.dart';
import 'package:morningstar/presentation/notifications/widgets/forms/notification_note.dart';
import 'package:morningstar/presentation/notifications/widgets/forms/notification_switch.dart';
import 'package:morningstar/presentation/notifications/widgets/forms/notification_title_body.dart';
import 'package:morningstar/presentation/shared/dropdown_button_with_title.dart';
import 'package:morningstar/presentation/shared/utils/enum_utils.dart';
import 'package:morningstar/presentation/shared/utils/toast_utils.dart';

class NotificationCustomForm extends StatelessWidget {
  final AppNotificationItemType itemType;
  final String title;
  final String body;
  final String note;
  final bool showNotification;
  final bool isInEditMode;
  final List<NotificationItemImage> images;
  final bool showOtherImages;
  final DateTime scheduledDate;
  final LanguageModel language;
  final bool useTwentyFourHoursFormat;

  const NotificationCustomForm({
    Key? key,
    required this.itemType,
    required this.title,
    required this.body,
    required this.note,
    required this.showNotification,
    required this.isInEditMode,
    required this.images,
    required this.showOtherImages,
    required this.scheduledDate,
    required this.language,
    required this.useTwentyFourHoursFormat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        NotificationCircleItem.custom(itemType: itemType, images: images, showOtherImages: showOtherImages),
        NotificationDropdownType(selectedValue: AppNotificationType.custom, isInEditMode: isInEditMode),
        Row(
          children: [
            Expanded(
              flex: 40,
              child: DropdownButtonWithTitle<AppNotificationItemType>(
                title: 'Type',
                currentValue: itemType,
                items: EnumUtils.getTranslatedAndSortedEnum(AppNotificationItemType.values, (val, _) => Assets.translateAppNotificationItemType(val)),
                onChanged: (v) => context.read<NotificationBloc>().add(NotificationEvent.itemTypeChanged(newValue: v)),
              ),
            ),
            const Spacer(flex: 10),
            Expanded(
              flex: 40,
              child: OutlinedButton(
                onPressed: () => _showDatePickerDialog(context),
                child: Text(
                  utils.DateUtils.formatDateMilitaryTime(scheduledDate, useTwentyFourHoursFormat: useTwentyFourHoursFormat),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
        NotificationTitleBody(title: title, body: body),
        NotificationNote(note: note),
        NotificationSwitch(showNotification: showNotification),
      ],
    );
  }

  Future<void> _showDatePickerDialog(BuildContext context) async {
    final now = DateTime.now();
    final locale = Locale(language.code, language.countryCode);
    final date = await showDatePicker(
      context: context,
      initialDate: scheduledDate,
      firstDate: now,
      lastDate: now.add(const Duration(days: 30)),
      locale: locale,
    );

    if (date == null) {
      return;
    }

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(scheduledDate),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: useTwentyFourHoursFormat),
        child: child!,
      ),
    );

    if (time == null) {
      return;
    }

    // The time of day returned is always in 24 hours format
    final finalScheduledDate = DateTime(date.year, date.month, date.day, date.hour, date.minute);
    if (finalScheduledDate.isBefore(DateTime.now().add(const Duration(minutes: 5)))) {
      ToastUtils.showInfoToast(ToastUtils.of(context), 'Invalid date');
      return;
    }
    context.read<NotificationBloc>().add(NotificationEvent.customDateChanged(newValue: finalScheduledDate));
  }
}
