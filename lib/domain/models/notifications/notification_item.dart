import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:morningstar/domain/enums/enums.dart';

part 'notification_item.freezed.dart';

@freezed
class NotificationItem with _$NotificationItem {
  Duration get duration => scheduledDate.difference(createdAt);

  Duration get remaining => completesAt.difference(DateTime.now());

  factory NotificationItem({
    required int key,
    required String itemKey,
    required String title,
    required String body,
    required String image,
    required DateTime createdAt,
    required DateTime scheduledDate,
    required DateTime completesAt,
    required AppNotificationType type,
    String? note,
    @Default(true) bool showNotification,
    AppNotificationItemType? notificationItemType,
  }) = _NotificationItem;

  NotificationItem._();
}