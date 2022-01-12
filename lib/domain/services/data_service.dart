import 'package:morningstar/domain/enums/enums.dart';
import 'package:morningstar/domain/models/models.dart';

abstract class DataService {
  Future<void> init({String dir = 'morningstar_data'});

  Future<void> deleteThemAll();

  Future<void> closeThemAll();

  List<SoldierCardModel> getAllSoldiersInInventory();

  List<WeaponCardModel> getAllWeaponsInInventory();

  Future<void> addItemToInventory(String key, ItemType type, int quantity);

  Future<void> updateItemInInventory(String key, ItemType type, int quantity);

  Future<void> deleteItemFromInventory(String key, ItemType type);

  Future<void> deleteItemsFromInventory(ItemType type);

  bool isItemInInventory(String key, ItemType type);

  List<NotificationItem> getAllNotifications();

  NotificationItem getNotification(int key, AppNotificationType type);

  Future<NotificationItem> saveCustomNotification(
    String itemKey,
    String title,
    String body,
    DateTime completesAt,
    AppNotificationItemType notificationItemType, {
    String? note,
    bool showNotification = true,
  });

  Future<NotificationItem> saveDailyCheckInNotification(
    String itemKey,
    String title,
    String body, {
    String? note,
    bool showNotification = true,
  });

  Future<void> deleteNotification(int key, AppNotificationType type);

  Future<NotificationItem> resetNotification(int key, AppNotificationType type, AppServerResetTimeType serverResetTimeType);

  Future<NotificationItem> stopNotification(int key, AppNotificationType type);

  Future<NotificationItem> updateCustomNotification(
    int key,
    String itemKey,
    String title,
    String body,
    DateTime completesAt,
    bool showNotification,
    AppNotificationItemType notificationItemType, {
    String? note,
  });

  Future<NotificationItem> updateDailyCheckInNotification(
    int key,
    String itemKey,
    String title,
    String body,
    bool showNotification, {
    String? note,
  });

  Future<NotificationItem> reduceNotificationHours(int key, AppNotificationType type, int hours);
}
