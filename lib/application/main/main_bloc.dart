import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:morningstar/application/bloc.dart';
import 'package:morningstar/domain/enums/enums.dart';
import 'package:morningstar/domain/models/models.dart';
import 'package:morningstar/domain/services/device_info_service.dart';
import 'package:morningstar/domain/services/locale_service.dart';
import 'package:morningstar/domain/services/logging_service.dart';
import 'package:morningstar/domain/services/morningstar_service.dart';
import 'package:morningstar/domain/services/settings_service.dart';
import 'package:morningstar/domain/services/telemetry_service.dart';

part 'main_bloc.freezed.dart';
part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  final LoggingService _logger;
  final MorningStarService _morningStarService;
  final SettingsService _settingsService;
  final LocaleService _localeService;
  final TelemetryService _telemetryService;
  final DeviceInfoService _deviceInfoService;

  final SoldiersBloc _soldiersBloc;
  final WeaponsBloc _weaponsBloc;
  final VehiclesBloc _vehiclesBloc;
  final HomeBloc _homeBloc;
  final PreloadBloc _preloadBloc;

  MainBloc(
    this._logger,
    this._morningStarService,
    this._settingsService,
    this._localeService,
    this._telemetryService,
    this._deviceInfoService,
    this._soldiersBloc,
    this._weaponsBloc,
    this._vehiclesBloc,
    this._homeBloc,
    this._preloadBloc,
  ) : super(const MainState.loading());

  _MainLoadedState get currentState => state as _MainLoadedState;

  @override
  Stream<MainState> mapEventToState(MainEvent event) async* {
    final s = await event.when(
      init: () async => _init(init: true),
      themeChanged: (theme) async => _loadThemeData(theme),
      languageChanged: (language) async => _init(languageChanged: true),
    );
    yield s;
  }

  Future<MainState> _init({bool languageChanged = false, bool init = false}) async {
    _logger.info(runtimeType, '_init: Initializing all..');
    await _morningStarService.init(_settingsService.language);

    if (languageChanged) {
      _logger.info(runtimeType, '_init: Language changed, reloading all the required blocs...');
      _soldiersBloc.add(const SoldiersEvent.init());
      _weaponsBloc.add(const WeaponsEvent.init());
      _vehiclesBloc.add(const VehiclesEvent.init());
      _homeBloc.add(const HomeEvent.init());
    }

    final settings = _settingsService.appSettings;
    await _telemetryService.trackInit(settings);

    final state = _loadThemeData(settings.appTheme);

    if (init) {
      await Future.delayed(const Duration(milliseconds: 600));
      _preloadBloc.add(const PreloadEvent.initialize());
    }
    return state;
  }

  Future<MainState> _loadThemeData(
    AppThemeType theme, {
    bool isInitialized = true,
  }) async {
    _logger.info(
      runtimeType,
      '_init: Is first install = ${_settingsService.isFirstInstall} ' '-- versionChanged = ${_deviceInfoService.versionChanged}',
    );

    return MainState.loaded(
      appTitle: _deviceInfoService.appName,
      language: _localeService.getLocaleWithoutLang(),
      initialized: isInitialized,
      theme: theme,
      firstInstall: _settingsService.isFirstInstall,
      versionChanged: _deviceInfoService.versionChanged,
    );
  }
}
