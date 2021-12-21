import 'package:flutter/material.dart';
import 'package:morningstar/domain/enums/enums.dart';
import 'package:morningstar/presentation/shared/bottom_sheets/custom_bottom_sheet.dart';
import 'package:morningstar/theme.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:morningstar/presentation/soldiers/widgets/soldier_bottom_sheet.dart' as soldiers;
import 'package:morningstar/presentation/notifications/widgets/add_edit_notification_bottom_sheet.dart' as notifications;

class ModalBottomSheetUtils {
  static Widget getBottomSheetFromEndDrawerItemType(BuildContext context, EndDrawerItemType? type, {Map<String, dynamic>? args}) {
    switch (type) {
      case EndDrawerItemType.soldiers:
        return const soldiers.SoldierBottomSheet();
      case EndDrawerItemType.notifications:
        assert(args != null);
        return notifications.AddEditNotificationBottomSheet.getWidgetFromArgs(context, args!);
    }
    return Container();
  }

  static Future<void> showAppModalBottomSheet(BuildContext context, EndDrawerItemType type, {Map<String, dynamic>? args}) async {
    final size = MediaQuery.of(context).size;
    final device = getDeviceType(size);

    if (device == DeviceScreenType.mobile) {
      await showModalBottomSheet(
        backgroundColor: Colors.grey.shade900,
        context: context,
        shape: Styles.modalBottomSheetShape,
        isDismissible: true,
        isScrollControlled: true,
        builder: (ctx) => getBottomSheetFromEndDrawerItemType(context, type, args: args),
      );
      return;
    }

    await showCustomModalBottomSheet(
      context: context,
      builder: (ctx) => getBottomSheetFromEndDrawerItemType(context, type, args: args),
    );
  }
}