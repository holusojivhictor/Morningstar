import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:morningstar/application/bloc.dart';
import 'package:morningstar/domain/assets.dart';
import 'package:morningstar/domain/enums/end_drawer_item_type.dart';
import 'package:morningstar/injection.dart';
import 'package:morningstar/domain/models/models.dart' as models;
import 'package:morningstar/presentation/notifications/widgets/add_edit_notification_bottom_sheet.dart';
import 'package:morningstar/presentation/shared/app_fab.dart';
import 'package:morningstar/presentation/shared/dialogs/info_dialog.dart';
import 'package:morningstar/presentation/shared/mixins/app_fab_mixin.dart';
import 'package:morningstar/presentation/shared/nothing_found_column.dart';
import 'package:morningstar/presentation/shared/utils/modal_bottom_sheet_utils.dart';
import 'package:morningstar/theme.dart';

import 'widgets/items/notification_list_subtitle.dart';
import 'widgets/items/notification_list_title.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> with SingleTickerProviderStateMixin, AppFabMixin {
  @override
  bool get isInitiallyVisible => true;

  @override
  bool get hideOnTop => false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider<NotificationsBloc>(
      create: (ctx) => Injection.notificationsBloc..add(const NotificationsEvent.init()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Notifications'),
          actions: [
            IconButton(
              tooltip: 'Information',
              icon: const Icon(Icons.info),
              onPressed: () => _showInfoDialog(context),
            ),
          ],
        ),
        body: SafeArea(
          child: BlocBuilder<NotificationsBloc, NotificationsState>(
            builder: (ctx, state) => state.map(
              initial: (state) {
                if (state.notifications.isEmpty) {
                  return const NothingFoundColumn(msg: 'Start by creating a notification');
                }

                return GroupedListView<models.NotificationItem, String>(
                  elements: state.notifications,
                  controller: scrollController,
                  groupBy: (item) => Assets.translateAppNotificationType(item.type),
                  itemBuilder: (context, element) => _NotificationItem(
                    useTwentyFourHoursFormat: state.useTwentyFourHoursFormat,
                    element: element,
                  ),
                  groupSeparatorBuilder: (type) => Container(
                    margin: const EdgeInsets.only(bottom: 5),
                    color: theme.colorScheme.secondary.withOpacity(0.3),
                    padding: Styles.edgeInsetAll5,
                    child: Text(type, style: theme.textTheme.headline4),
                  ),
                );
              },
            ),
          ),
        ),
        floatingActionButton: Builder(
          builder: (ctx) => AppFab(
            onPressed: () => _showAppModal(ctx),
            icon: const Icon(Icons.add),
            hideFabAnimController: hideFabAnimController,
            scrollController: scrollController,
            mini: false,
          ),
        ),
      ),
    );
  }

  Future<void> _showAppModal(BuildContext context) async {
    await ModalBottomSheetUtils.showAppModalBottomSheet(
      context,
      EndDrawerItemType.notifications,
      args: AddEditNotificationBottomSheet.buildNavigationArgsForAdd('Morningstar', 'Notifications'),
    );
  }

  Future<void> _showInfoDialog(BuildContext context) async {
    final explanations = [
      'You can schedule notifications that remind you of certain things in the game.',
      'Some of these can be customized to suit your needs.',
      'The bell icon indicates that a notification is scheduled to be shown on your device even when the app is not running.',
      'Some notifications allow you to change the shown image on the list',
      'You can swipe to the right or left to see more options on each item.',
      'Some Android OEMs have their own customized Android OS that can prevent applications from running in the background.\nConsequently, scheduled notifications may not work when the application is in the background on certain devices (e.g. by Xiaomi, Huawei).\nSo if you encounter this problem, you may have to look for a setting that allows you to control which applications run in the background.',
    ];
    await showDialog(
      context: context,
      builder: (context) => InfoDialog(explanations: explanations),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final bool useTwentyFourHoursFormat;
  final models.NotificationItem element;
  const _NotificationItem({
    Key? key,
    required this.useTwentyFourHoursFormat,
    required this.element,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget subtitle;
    switch (element.type) {
      default:
        subtitle = NotificationSubtitle(
          createdAt: element.createdAt,
          completesAt: element.completesAt,
          note: element.note,
          useTwentyFourHoursFormat: useTwentyFourHoursFormat,
        );
        break;
    }
    return NotificationListTitle(item: element, subtitle: subtitle);
  }
}

