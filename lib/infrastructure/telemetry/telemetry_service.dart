import 'package:enum_to_string/enum_to_string.dart';
import 'package:morningstar/domain/enums/enums.dart';
import 'package:morningstar/domain/services/device_info_service.dart';
import 'package:morningstar/domain/services/telemetry_service.dart';
import 'package:morningstar/infrastructure/telemetry/flutter_appcenter_bundle.dart';

class TelemetryServiceImpl implements TelemetryService {
  final DeviceInfoService _deviceInfoService;

  TelemetryServiceImpl(this._deviceInfoService);

  // Only call this function from main.dart
  @override
  Future<void> initTelemetry() async {
    // await AppCenter.startAsync(appSecretAndroid: Secrets.appCenterKey, appSecretIOS: '');
  }

  @override
  Future<void> trackEventAsync(String name, [Map<String, String>? properties]) {
    properties ??= {};
    properties.addAll(_deviceInfoService.deviceInfo);
    return AppCenter.trackEventAsync(name, properties);
  }

  @override
  Future<void> trackTopPicksOpened() async {
    await trackEventAsync('Top-Picks-Opened');
  }

  @override
  Future<void> trackInit() async {
    await trackEventAsync('Init');
  }

  @override
  Future<void> trackSoldierLoaded(String value) async {
    await trackEventAsync('Soldier-FromKey', {'Key': value});
  }

  @override
  Future<void> trackItemAddedToInventory(String key, int quantity) => trackEventAsync('MyInventory-Added', {'Key_Qty': '${key}_$quantity'});

  @override
  Future<void> trackItemDeletedFromInventory(String key) => trackEventAsync('MyInventory-Deleted', {'Key': key});

  @override
  Future<void> trackItemUpdatedInInventory(String key, int quantity) => trackEventAsync('MyInventory-Updated', {'Key_Qty': '${key}_$quantity'});

  @override
  Future<void> trackItemsDeletedFromInventory(ItemType type) => trackEventAsync('MyInventory-Clear-All', {'Type': EnumToString.convertToString(type)});

  @override
  Future<void> trackNotificationCreated(AppNotificationType type) => trackEventAsync('Notification-Created', {'Type': EnumToString.convertToString(type)});

  @override
  Future<void> trackNotificationDeleted(AppNotificationType type) => trackEventAsync('Notification-Deleted', {'Type': EnumToString.convertToString(type)});

  @override
  Future<void> trackNotificationRestarted(AppNotificationType type) => trackEventAsync('Notification-Restarted', {'Type': EnumToString.convertToString(type)});

  @override
  Future<void> trackNotificationStopped(AppNotificationType type) => trackEventAsync('Notification-Stopped', {'Type': EnumToString.convertToString(type)});

  @override
  Future<void> trackNotificationUpdated(AppNotificationType type) => trackEventAsync('Notification-Updated', {'Type': EnumToString.convertToString(type)});
}