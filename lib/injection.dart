import 'package:get_it/get_it.dart';
import 'package:morningstar/domain/services/data_service.dart';
import 'package:morningstar/domain/services/device_info_service.dart';
import 'package:morningstar/domain/services/locale_service.dart';
import 'package:morningstar/domain/services/morningstar_service.dart';
import 'package:morningstar/domain/services/notification_service.dart';
import 'package:morningstar/domain/services/settings_service.dart';
import 'package:morningstar/domain/services/telemetry_service.dart';
import 'package:morningstar/infrastructure/data_service.dart';
import 'package:morningstar/infrastructure/device_info_service.dart';
import 'package:morningstar/infrastructure/locale_service.dart';
import 'package:morningstar/infrastructure/morningstar_service.dart';
import 'package:morningstar/infrastructure/notification_service.dart';
import 'package:morningstar/infrastructure/settings_service.dart';
import 'package:morningstar/infrastructure/telemetry/telemetry_service.dart';

import 'application/bloc.dart';

final GetIt getIt = GetIt.instance;

class Injection {
  static NotificationTimerBloc get notificationTimerBloc {
    return NotificationTimerBloc();
  }

  static NotificationsBloc get notificationsBloc {
    final dataService = getIt<DataService>();
    final notificationService = getIt<NotificationService>();
    final settingsService = getIt<SettingsService>();
    final telemetryService = getIt<TelemetryService>();
    return NotificationsBloc(dataService, notificationService, settingsService, telemetryService);
  }

  static NotificationBloc getNotificationBloc(NotificationsBloc bloc) {
    final dataService = getIt<DataService>();
    final notificationService = getIt<NotificationService>();
    final morningStarService = getIt<MorningStarService>();
    final localeService = getIt<LocaleService>();
    final telemetryService = getIt<TelemetryService>();
    final settingsService = getIt<SettingsService>();
    return NotificationBloc(dataService, notificationService, morningStarService, localeService, telemetryService, settingsService, bloc);
  }

  static Future<void> init() async {
    final deviceInfoService = DeviceInfoServiceImpl();
    getIt.registerSingleton<DeviceInfoService>(deviceInfoService);
    await deviceInfoService.init();

    final telemetryService = TelemetryServiceImpl(deviceInfoService);
    getIt.registerSingleton<TelemetryService>(telemetryService);
    await telemetryService.initTelemetry();

    final settingsService = SettingsServiceImpl();
    await settingsService.init();
    getIt.registerSingleton<SettingsService>(settingsService);
    getIt.registerSingleton<LocaleService>(LocaleServiceImpl(getIt<SettingsService>()));
    getIt.registerSingleton<MorningStarService>(MorningStarServiceImpl());

    final dataService = DataServiceImpl(getIt<MorningStarService>());
    await dataService.init();
    getIt.registerSingleton<DataService>(dataService);

    final notificationService = NotificationServiceImpl();
    await notificationService.init();
    getIt.registerSingleton<NotificationService>(notificationService);
  }
}