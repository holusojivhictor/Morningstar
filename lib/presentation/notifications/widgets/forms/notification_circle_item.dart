import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morningstar/application/bloc.dart';
import 'package:morningstar/domain/enums/enums.dart';
import 'package:morningstar/domain/models/models.dart';
import 'package:morningstar/presentation/shared/images/circle_item.dart';
import 'package:morningstar/domain/extensions/string_extensions.dart';
import 'package:morningstar/presentation/soldiers/soldiers_page.dart';

class NotificationCircleItem extends StatelessWidget {
  final AppNotificationType type;
  final AppNotificationItemType? itemType;
  final bool showOtherImages;
  final List<NotificationItemImage> images;

  NotificationItemImage get selected => images.firstWhere((el) => el.isSelected);

  const NotificationCircleItem({
    Key? key,
    required this.type,
    required this.images,
    this.showOtherImages = false,
  })  : itemType = null,
        super(key: key);

  const NotificationCircleItem.custom({
    Key? key,
    required this.itemType,
    required this.images,
    this.showOtherImages = false,
  })  : type = AppNotificationType.custom,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final ignored = [AppNotificationType.custom];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (images.isNotEmpty)
          Center(
            child: CircleItem(
              radius: 40,
              image: selected.image,
              onTap: (_) => _onMainIconTap(context),
            ),
          ),
        if (showOtherImages && !ignored.contains(type))
          SizedBox(
            height: 70,
            child: ListView.builder(
              itemCount: images.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (ctx, index) => _buildCircleAvatar(context, images[index]),
            ),
          ),
      ],
    );
  }

  Widget _buildCircleAvatar(BuildContext context, NotificationItemImage item) {
    final isSelected = selected == item;
    return _buildSelectableImage(context, item.image, isSelected: isSelected);
  }

  Widget _buildSelectableImage(BuildContext context, String theImage, {bool isSelected = false}) {
    final circleItem = CircleItem(image: theImage, onTap: (_) => _changeSelectedImg(theImage, context));
    if (!isSelected) {
      return Center(child: circleItem);
    }
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Positioned(top: 0, right: 0, child: Icon(Icons.check, color: Colors.green)),
          CircleItem(image: theImage, onTap: (_) => _changeSelectedImg(theImage, context)),
        ],
      ),
    );
  }

  Future<void> _onMainIconTap(BuildContext context) async {
    switch (type) {
      case AppNotificationType.custom:
        switch (itemType) {
          case AppNotificationItemType.soldier:
            await _openSoldiersPage(context);
            break;
          // TODO: Add weapons case
          default:
            throw Exception('Invalid app notification type = $type');
        }
        break;
      case AppNotificationType.dailyCheckIn:
        break;
    }
  }

  Future<void> _openSoldiersPage(BuildContext context) async {
    final keyName = await SoldiersPage.forSelection(context, excludeKeys: [selected.itemKey]);
    _onItemSelected(keyName, context);
  }

  void _onItemSelected(String? keyName, BuildContext context) {
    if (keyName.isNullEmptyOrWhitespace) {
      return;
    }

    context.read<NotificationBloc>().add(NotificationEvent.keySelected(keyName: keyName!));
  }

  void _changeSelectedImg(String newValue, BuildContext context) => context.read<NotificationBloc>().add(NotificationEvent.imageChanged(newValue: newValue));

  // void _toggleShowOtherImages(BuildContext context) => context.read<NotificationBloc>().add(NotificationEvent.showOtherImages(show: !showOtherImages));
}
