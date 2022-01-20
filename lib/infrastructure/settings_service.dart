import 'package:collection/collection.dart' show IterableExtension;
import 'package:devicelocale/devicelocale.dart';
import 'package:morningstar/domain/app_constants.dart';
import 'package:morningstar/domain/enums/enums.dart';
import 'package:morningstar/domain/models/settings/app_settings.dart';
import 'package:morningstar/domain/services/logging_service.dart';
import 'package:morningstar/domain/services/settings_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsServiceImpl extends SettingsService {
  final _appThemeKey = 'AppTheme';
  final _appLanguageKey = 'AppLanguage';
  final _isFirstInstallKey = 'FirstInstall';
  final _serverResetTimeKey = 'ServerResetTimeKey';
  final _showSoldierDetailsKey = 'ShowSoldierDetailsKey';
  final _showWeaponDetailsKey = 'ShowWeaponDetailsKey';
  final _doubleBackToCloseKey = 'DoubleBackToCloseKey';
  final _useTwentyFourHoursFormatKey = 'UseTwentyFourHoursFormat';

  bool _initialized = false;

  late SharedPreferences _prefs;
  final LoggingService _logger;

  SettingsServiceImpl(this._logger);

  @override
  AppThemeType get appTheme => AppThemeType.values[_prefs.getInt(_appThemeKey)!];

  @override
  set appTheme(AppThemeType theme) => _prefs.setInt(_appThemeKey, theme.index);

  @override
  AppLanguageType get language => AppLanguageType.values[_prefs.getInt(_appLanguageKey)!];

  @override
  set language(AppLanguageType lang) => _prefs.setInt(_appLanguageKey, lang.index);

  @override
  bool get isFirstInstall => _prefs.getBool(_isFirstInstallKey)!;

  @override
  set isFirstInstall(bool itIs) => _prefs.setBool(_isFirstInstallKey, itIs);

  @override
  bool get showSoldierDetails => _prefs.getBool(_showSoldierDetailsKey)!;

  @override
  set showSoldierDetails(bool show) =>_prefs.setBool(_showSoldierDetailsKey, show);

  @override
  bool get showWeaponDetails => _prefs.getBool(_showWeaponDetailsKey)!;

  @override
  set showWeaponDetails(bool show) => _prefs.setBool(_showWeaponDetailsKey, show);

  @override
  AppServerResetTimeType get serverResetTime => AppServerResetTimeType.values[_prefs.getInt(_serverResetTimeKey)!];

  @override
  set serverResetTime(AppServerResetTimeType time) => _prefs.setInt(_serverResetTimeKey, time.index);

  @override
  bool get doubleBackToClose => _prefs.getBool(_doubleBackToCloseKey)!;

  @override
  set doubleBackToClose(bool value) => _prefs.setBool(_doubleBackToCloseKey, value);

  @override
  bool get useTwentyFourHoursFormat => _prefs.getBool(_useTwentyFourHoursFormatKey)!;

  @override
  set useTwentyFourHoursFormat(bool value) => _prefs.setBool(_useTwentyFourHoursFormatKey, value);

  @override
  AppSettings get appSettings => AppSettings(
    appTheme: appTheme,
    useDarkAmoled: false,
    appLanguage: language,
    showSoldierDetails: showSoldierDetails,
    showWeaponDetails: showWeaponDetails,
    isFirstInstall: isFirstInstall,
    serverResetTime: serverResetTime,
    doubleBackToClose: doubleBackToClose,
    useTwentyFourHoursFormat: useTwentyFourHoursFormat,
  );


  @override
  Future<void> init() async {
    if (_initialized) {
      _logger.info(runtimeType, 'Settings are already initialized!');
      return;
    }

    _logger.info(runtimeType, 'Initializing settings...Getting shared preferences instance...');

    _prefs = await SharedPreferences.getInstance();

    if (_prefs.get(_isFirstInstallKey) == null) {
      _logger.info(runtimeType, 'This is the first install of the app');
      isFirstInstall = true;
    }
    
    if (_prefs.get(_appThemeKey) == null) {
      _logger.info(runtimeType, 'Setting dark as the default theme');
      appTheme = AppThemeType.dark;
    }

    if (_prefs.get(_appLanguageKey) == null) {
      language = await _getDefaultLangToUse();
    }
    
    if (_prefs.get(_showSoldierDetailsKey) == null) {
      _logger.info(runtimeType, 'Character details are shown by default');
      showSoldierDetails = true;
    }
    
    if (_prefs.get(_showWeaponDetailsKey) == null) {
      _logger.info(runtimeType, 'Weapon details are shown by default');
      showWeaponDetails = true;
    }

    if (_prefs.get(_serverResetTimeKey) == null) {
      _logger.info(runtimeType, 'The server reset time will be ${AppServerResetTimeType.europe} by default');
      serverResetTime = AppServerResetTimeType.europe;
    }

    if (_prefs.get(_doubleBackToCloseKey) == null) {
      _logger.info(runtimeType, 'Double back to close will be set to its default (true)');
      doubleBackToClose = true;
    }

    if (_prefs.getBool(_useTwentyFourHoursFormatKey) == null) {
      _logger.info(runtimeType, 'Use Twenty four hours date format will be set to its default (false)');
      useTwentyFourHoursFormat = false;
    }

    _initialized = true;
    _logger.info(runtimeType, 'Settings were initialized successfully');
  }

  Future<AppLanguageType> _getDefaultLangToUse() async {
    try {
      _logger.info(runtimeType, '_getDefaultLangToUse: Trying to retrieve device lang...');
      final deviceLocale = await Devicelocale.currentAsLocale;
      if (deviceLocale == null) {
        _logger.warning(
          runtimeType,
          "_getDefaultLangToUse: Couldn't retrieve the device locale, defaulting to english",
        );
        return AppLanguageType.english;
      }

      final appLang = languagesMap.entries.firstWhereOrNull((val) => val.value.code == deviceLocale.languageCode);
      if (appLang == null) {
        _logger.info(
          runtimeType,
          "_getDefaultLangToUse: Couldn't find an appropriate app language for = ${deviceLocale.languageCode}_${deviceLocale.countryCode}, defaulting to english",
        );
        return AppLanguageType.english;
      }

      _logger.info(
        runtimeType,
        '_getDefaultLangToUse: Found an appropriate language to use for = ${deviceLocale.languageCode}_${deviceLocale.countryCode}, that is = ${appLang.key}',
      );
      return appLang.key;
    } catch (e, s) {
      _logger.error(runtimeType, '_getDefaultLangToUse: Unknown error occurred', e, s);
      return AppLanguageType.english;
    }
  }
}