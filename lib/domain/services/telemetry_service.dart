import 'package:morningstar/domain/enums/enums.dart';

abstract class TelemetryService {
  Future<void> initTelemetry();

  Future<void> trackEventAsync(String name, [Map<String, String>? properties]);

  Future<void> trackTopPicksOpened();

  Future<void> trackInit();

  Future<void> trackSoldierLoaded(String value);

  Future<void> trackItemAddedToInventory(String key, int quantity);

  Future<void> trackItemUpdatedInInventory(String key, int quantity);

  Future<void> trackItemDeletedFromInventory(String key);

  Future<void> trackItemsDeletedFromInventory(ItemType type);

  Future<void> trackNotificationCreated(AppNotificationType type);

  Future<void> trackNotificationUpdated(AppNotificationType type);

  Future<void> trackNotificationDeleted(AppNotificationType type);

  Future<void> trackNotificationRestarted(AppNotificationType type);

  Future<void> trackNotificationStopped(AppNotificationType type);
}