import 'package:get_it/get_it.dart';
import 'package:morningstar/domain/services/changelog_provider.dart';
import 'package:morningstar/domain/services/data_service.dart';
import 'package:morningstar/domain/services/device_info_service.dart';
import 'package:morningstar/domain/services/locale_service.dart';
import 'package:morningstar/domain/services/logging_service.dart';
import 'package:morningstar/domain/services/morningstar_service.dart';
import 'package:morningstar/domain/services/network_service.dart';
import 'package:morningstar/domain/services/notification_service.dart';
import 'package:morningstar/domain/services/settings_service.dart';
import 'package:morningstar/domain/services/telemetry_service.dart';
import 'package:morningstar/infrastructure/infrastructure.dart';

import 'application/bloc.dart';

final GetIt getIt = GetIt.instance;

class Injection {
  static ChangelogBloc get changelogBloc {
    final changelogProvider = getIt<ChangelogProvider>();
    return ChangelogBloc(changelogProvider);
  }

  static PreloadBloc get preloadBloc {
    return PreloadBloc();
  }

  static TierListBloc get tierListBloc {
    final morningStarService = getIt<MorningStarService>();
    final dataService = getIt<DataService>();
    final telemetryService = getIt<TelemetryService>();
    final loggingService = getIt<LoggingService>();
    return TierListBloc(morningStarService, dataService, telemetryService, loggingService);
  }

  static TierListFormBloc get tierListFormBloc {
    return TierListFormBloc();
  }

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
    final loggingService = getIt<LoggingService>();
    return NotificationBloc(dataService, notificationService, morningStarService, localeService, telemetryService, settingsService, loggingService, bloc);
  }

  static Future<void> init() async {
    final networkService = NetworkServiceImpl();
    networkService.init();
    getIt.registerSingleton<NetworkService>(networkService);

    final deviceInfoService = DeviceInfoServiceImpl();
    getIt.registerSingleton<DeviceInfoService>(deviceInfoService);
    await deviceInfoService.init();

    final telemetryService = TelemetryServiceImpl(deviceInfoService);
    getIt.registerSingleton<TelemetryService>(telemetryService);
    await telemetryService.initTelemetry();

    final loggingService = LoggingServiceImpl(getIt<TelemetryService>(), deviceInfoService);
    getIt.registerSingleton<LoggingService>(loggingService);

    final settingsService = SettingsServiceImpl(loggingService);
    await settingsService.init();
    getIt.registerSingleton<SettingsService>(settingsService);
    getIt.registerSingleton<LocaleService>(LocaleServiceImpl(getIt<SettingsService>()));
    getIt.registerSingleton<MorningStarService>(MorningStarServiceImpl());

    final dataService = DataServiceImpl(getIt<MorningStarService>());
    await dataService.init();
    getIt.registerSingleton<DataService>(dataService);

    final notificationService = NotificationServiceImpl(loggingService);
    await notificationService.init();
    getIt.registerSingleton<NotificationService>(notificationService);

    final changelogProvider = ChangelogProviderImpl(loggingService, networkService);
    getIt.registerSingleton<ChangelogProvider>(changelogProvider);
  }
}