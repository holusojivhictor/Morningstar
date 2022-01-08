import 'package:collection/collection.dart' show IterableExtension;
import 'package:darq/darq.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:morningstar/domain/app_constants.dart';
import 'package:morningstar/domain/enums/enums.dart';
import 'package:morningstar/domain/models/entities/inventory/inventory_item.dart';
import 'package:morningstar/domain/models/entities/inventory/inventory_used_item.dart';
import 'package:morningstar/domain/models/entities/notifications/notification_base.dart';
import 'package:morningstar/domain/models/entities/notifications/notification_custom.dart';
import 'package:morningstar/domain/models/models.dart';
import 'package:morningstar/domain/models/notifications/notification_item.dart';
import 'package:morningstar/domain/models/soldiers/soldier_card_model.dart';
import 'package:morningstar/domain/services/data_service.dart';
import 'package:morningstar/domain/services/morningstar_service.dart';
import 'package:synchronized/synchronized.dart';

class DataServiceImpl implements DataService {
  final MorningStarService _morningStarService;

  late Box<InventoryItem> _inventoryBox;
  late Box<InventoryUsedItem> _inventoryUsedItemsBox;

  late Box<NotificationCustom> _notificationsCustomBox;

  final _initLock = Lock();
  final _deleteAllLock = Lock();

  DataServiceImpl(this._morningStarService);

  @override
  Future<void> init({String dir = 'morningstar_data'}) async {
    await _initLock.synchronized(() async {
      await Hive.initFlutter(dir);
      _registerAdapters();
      _inventoryBox = await Hive.openBox<InventoryItem>('inventory');
      _inventoryUsedItemsBox =
          await Hive.openBox<InventoryUsedItem>('inventoryUsedItems');

      _notificationsCustomBox = await Hive.openBox('notificationsCustom');
    });
  }

  @override
  Future<void> deleteThemAll() async {
    await _deleteAllLock.synchronized(() async {
      await _inventoryBox.clear();
      await _inventoryUsedItemsBox.clear();

      await _notificationsCustomBox.clear();
    });
  }

  @override
  Future<void> closeThemAll() async {
    await _deleteAllLock.synchronized(() async {
      await Hive.close();
    });
  }

  @override
  Future<void> addItemToInventory(String key, ItemType type, int quantity) {
    if (isItemInInventory(key, type)) {
      return Future.value();
    }
    return _inventoryBox.add(InventoryItem(key, quantity, type.index));
  }

  @override
  Future<void> deleteItemFromInventory(String key, ItemType type) async {
    final item = _getItemFromInventory(key, type);

    if (item != null) {
      await _inventoryBox.delete(item.key);
    }
  }

  @override
  Future<void> deleteItemsFromInventory(ItemType type) async {
    switch (type) {
      case ItemType.soldier:
      case ItemType.weapon:
        await deleteAllItemsInInventoryExceptMaterials(type);
        break;
      case ItemType.material:
        break;
    }
  }

  Future<void> deleteAllItemsInInventoryExceptMaterials(ItemType? type) async {
    if (type == ItemType.material) {
      throw Exception('Material type is not valid here');
    }
    final toDeleteKeys = type == null
        ? _inventoryBox.values
            .where((el) => el.type != ItemType.material.index)
            .map((e) => e.key)
            .toList()
        : _inventoryBox.values
            .where((el) => el.type == type.index)
            .map((e) => e.key)
            .toList();
    if (toDeleteKeys.isNotEmpty) {
      await _inventoryBox.deleteAll(toDeleteKeys);
    }
  }

  Future<void> deleteAllUsedInventoryItems() async {
    final usedItemKeys =
        _inventoryUsedItemsBox.values.map((e) => e.key).toList();
    if (usedItemKeys.isNotEmpty) {
      await _inventoryUsedItemsBox.deleteAll(usedItemKeys);
    }
  }

  @override
  Future<void> updateItemInInventory(
      String key, ItemType type, int quantity) async {
    var item = _getItemFromInventory(key, type);
    if (item == null) {
      item = InventoryItem(key, quantity, type.index);
      await _inventoryBox.add(item);
    } else {
      if (quantity == item.quantity) {
        return;
      }
      // TODO: If the quantity is 0 should the item be deleted?
      item.quantity = quantity;
      await item.save();
    }
  }

  @override
  List<SoldierCardModel> getAllSoldiersInInventory() {
    final soldiers = _inventoryBox.values
        .where((el) => el.type == ItemType.soldier.index)
        .map((e) => _morningStarService.getSoldierForCard(e.itemKey))
        .toList();

    return soldiers..sort((x, y) => x.name.compareTo(y.name));
  }

  @override
  List<WeaponCardModel> getAllWeaponsInInventory() {
    final weapons = _inventoryBox.values
        .where((el) => el.type == ItemType.weapon.index)
        .map((e) => _morningStarService.getWeaponForCard(e.itemKey))
        .toList();

    return weapons..sort((x, y) => x.name.compareTo(y.name));
  }

  @override
  bool isItemInInventory(String key, ItemType type) {
    return _inventoryBox.values.any((el) => el.itemKey == key && el.type == type.index && el.quantity > 0);
  }

  InventoryItem? _getItemFromInventory(String key, ItemType type) {
    return _inventoryBox.values.firstWhereOrNull((el) => el.itemKey == key && el.type == type.index);
  }

  @override
  List<NotificationItem> getAllNotifications() {
    final notifications = _notificationsCustomBox.values.map((e) => _mapToNotificationItem(e)).toList();
    return notifications.orderBy((el) => el.createdAt).toList();
  }

  @override
  NotificationItem getNotification(int key, AppNotificationType type) {
    final item = _getNotification(key, type);
    return _mapToNotificationItem(item);
  }

  @override
  Future<NotificationItem> saveCustomNotification(
    String itemKey,
    String title,
    String body,
    DateTime completesAt,
    AppNotificationItemType notificationItemType, {
    String? note,
    bool showNotification = true,
  }) async {
    final now = DateTime.now();
    final notification = NotificationCustom.custom(
      itemKey: itemKey,
      createdAt: now,
      completesAt: completesAt,
      showNotification: showNotification,
      notificationItemType: notificationItemType.index,
      note: note?.trim(),
      title: title.trim(),
      body: body.trim(),
    );
    final key = await _notificationsCustomBox.add(notification);
    return getNotification(key, AppNotificationType.custom);
  }

  @override
  Future<NotificationItem> saveDailyCheckInNotification(
    String itemKey,
    String title,
    String body, {
    String? note,
    bool showNotification = true,
  }) async {
    final now = DateTime.now();
    final notification = NotificationCustom.forDailyCheckIn(
      itemKey: itemKey,
      createdAt: now,
      completesAt: now.add(dailyCheckInResetDuration),
      showNotification: showNotification,
      note: note?.trim(),
      title: title.trim(),
      body: body.trim(),
    );
    final key = await _notificationsCustomBox.add(notification);
    return getNotification(key, AppNotificationType.dailyCheckIn);
  }

  @override
  Future<void> deleteNotification(int key, AppNotificationType type) {
    switch (type) {
      case AppNotificationType.custom:
      case AppNotificationType.dailyCheckIn:
        return _notificationsCustomBox.delete(key);
      default:
        throw Exception('Invalid notification type =$type');
    }
  }

  @override
  Future<NotificationItem> resetNotification(int key, AppNotificationType type, AppServerResetTimeType serverResetTimeType) async {
    switch (type) {
      case AppNotificationType.custom:
        break;
      case AppNotificationType.dailyCheckIn:
        final item = _getNotification<NotificationCustom>(key, type);
        item.completesAt = DateTime.now().add(const Duration(hours: 24));
        await item.save();
        return _mapToNotificationItem(item);
    }

    throw Exception(
        'The provided app notification type = $type is not valid for a reset');
  }

  @override
  Future<NotificationItem> stopNotification(int key, AppNotificationType type) async {
    final item = _getNotification(key, type);
    item.completesAt = DateTime.now();

    await (item as HiveObject).save();
    return _mapToNotificationItem(item);
  }

  @override
  Future<NotificationItem> updateCustomNotification(
    int key,
    String itemKey,
    String title,
    String body,
    DateTime completesAt,
    bool showNotification,
    AppNotificationItemType notificationItemType, {
    String? note,
  }) async {
    final item =
        _notificationsCustomBox.values.firstWhere((el) => el.key == key);
    item
      ..itemKey = itemKey
      ..notificationItemType = notificationItemType.index;

    if (item.completesAt != completesAt) {
      item.completesAt = completesAt;
    }

    return _updateNotification(item, title, body, note, showNotification);
  }

  @override
  Future<NotificationItem> updateDailyCheckInNotification(
    int key,
    String itemKey,
    String title,
    String body,
    bool showNotification, {
    String? note,
  }) async {
    final item = _notificationsCustomBox.values.firstWhere((el) => el.key == key);
    final isCompleted = item.completesAt.isBefore(DateTime.now());
    item.itemKey = itemKey;

    if (isCompleted) {
      item.completesAt = DateTime.now().add(dailyCheckInResetDuration);
    }
    
    return _updateNotification(item, title, body, note, showNotification);
  }

  @override
  Future<NotificationItem> reduceNotificationHours(int key, AppNotificationType type, int hours) {
    final item = _getNotification(key, type);
    final now = DateTime.now();
    var completesAt = item.completesAt.subtract(Duration(hours: hours));

    if (completesAt.isBefore(now)) {
      completesAt = now;
    }

    item.completesAt = completesAt;
    return _updateNotification(item, item.title, item.body, item.note, item.showNotification);
  }

  T _getNotification<T extends NotificationBase>(int key, AppNotificationType type) {
    switch (type) {
      case AppNotificationType.custom:
      case AppNotificationType.dailyCheckIn:
        return _notificationsCustomBox.values.firstWhere((el) => el.key == key)
            as T;
      default:
        throw Exception('Invalid notification type = $type');
    }
  }

  NotificationItem _mapToNotificationItem(NotificationBase e) {
    final type = AppNotificationType.values[e.type];
    switch (type) {
      case AppNotificationType.custom:
      case AppNotificationType.dailyCheckIn:
        return _mapToNotificationItemFromCustom(e as NotificationCustom);
      default:
        throw Exception('Invalid notification type = $type');
    }
  }

  NotificationItem _mapToNotificationItemFromCustom(NotificationCustom e) {
    final itemType = AppNotificationItemType.values[e.notificationItemType];
    return _mapToNotificationItemFromBase(e, notificationItemType: itemType)
        .copyWith
        .call(notificationItemType: itemType);
  }

  NotificationItem _mapToNotificationItemFromBase(NotificationBase e,
      {AppNotificationItemType? notificationItemType}) {
    final type = AppNotificationType.values[e.type];
    final hiveObject = e as HiveObject;
    return NotificationItem(
      key: hiveObject.key as int,
      itemKey: e.itemKey,
      image: _morningStarService.getItemImageFromNotificationType(
          e.itemKey, type,
          notificationItemType: notificationItemType),
      createdAt: e.createdAt,
      completesAt: e.completesAt,
      type: type,
      showNotification: e.showNotification,
      note: e.note,
      title: e.title,
      body: e.body,
      scheduledDate: e.originalScheduledDate,
    );
  }

  Future<NotificationItem> _updateNotification(NotificationBase notification,
      String title, String body, String? note, bool showNotification) async {
    notification.title = title.trim();
    notification.note = note?.trim();
    notification.body = body.trim();
    notification.showNotification = showNotification;

    final hiveObject = notification as HiveObject;
    await hiveObject.save();
    return getNotification(
        hiveObject.key as int, AppNotificationType.values[notification.type]);
  }

  void _registerAdapters() {
    Hive.registerAdapter(InventoryItemAdapter());
    Hive.registerAdapter(InventoryUsedItemAdapter());
    Hive.registerAdapter(NotificationCustomAdapter());
  }
}
