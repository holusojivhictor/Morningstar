import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morningstar/application/bloc.dart';
import 'package:morningstar/domain/assets.dart';
import 'package:morningstar/domain/enums/enums.dart';
import 'package:morningstar/presentation/shared/dropdown_button_with_title.dart';
import 'package:morningstar/presentation/shared/utils/enum_utils.dart';

class NotificationDropdownType extends StatelessWidget {
  final AppNotificationType selectedValue;
  final bool isInEditMode;
  final bool isExpanded;

  const NotificationDropdownType({
    Key? key,
    required this.selectedValue,
    required this.isInEditMode,
    this.isExpanded = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final translatedValues = EnumUtils.getTranslatedAndSortedEnum<AppNotificationType>(
      AppNotificationType.values,
        (type, _) => Assets.translateAppNotificationType(type),
    );

    return DropdownButtonWithTitle<AppNotificationType>(
      margin: EdgeInsets.zero,
      title: 'Notification Type',
      isExpanded: isExpanded,
      currentValue: translatedValues.firstWhere((el) => el.enumValue == selectedValue).enumValue,
      items: translatedValues,
      onChanged: isInEditMode ? null : (v) => context.read<NotificationBloc>().add(NotificationEvent.typeChanged(newValue: v)),
    );
  }
}
