import 'package:collection/collection.dart' show IterableExtension;
import 'package:devicelocale/devicelocale.dart';
import 'package:morningstar/domain/app_constants.dart';
import 'package:morningstar/domain/enums/app_server_reset_time_type.dart';
import 'package:morningstar/domain/enums/enums.dart';
import 'package:morningstar/domain/models/settings/app_settings.dart';
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

  SettingsServiceImpl();

  @override
  Future<void> init() async {
    if (_initialized) {
      return;
    }
    _prefs = await SharedPreferences.getInstance();

    if (_prefs.get(_isFirstInstallKey) == null) {
      isFirstInstall = true;
    }
    
    if (_prefs.get(_appThemeKey) == null) {
      appTheme = AppThemeType.dark;
    }

    if (_prefs.get(_appLanguageKey) == null) {
      language = await _getDefaultLangToUse();
    }
    
    if (_prefs.get(_showSoldierDetailsKey) == null) {
      showSoldierDetails = true;
    }
    
    if (_prefs.get(_showWeaponDetailsKey) == null) {
      showWeaponDetails = true;
    }

    if (_prefs.get(_serverResetTimeKey) == null) {
      serverResetTime = AppServerResetTimeType.europe;
    }

    if (_prefs.get(_doubleBackToCloseKey) == null) {
      doubleBackToClose = true;
    }

    if (_prefs.getBool(_useTwentyFourHoursFormatKey) == null) {
      useTwentyFourHoursFormat = false;
    }

    _initialized = true;
  }

  Future<AppLanguageType> _getDefaultLangToUse() async {
    try {
      final deviceLocale = await Devicelocale.currentAsLocale;
      if (deviceLocale == null) {
        return AppLanguageType.english;
      }

      final appLang = languagesMap.entries.firstWhereOrNull((val) => val.value.code == deviceLocale.languageCode);
      if (appLang == null) {
        return AppLanguageType.english;
      }
      return appLang.key;
    } catch (e) {
      return AppLanguageType.english;
    }
  }
}