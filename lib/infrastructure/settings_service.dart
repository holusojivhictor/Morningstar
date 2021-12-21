import 'package:collection/collection.dart' show IterableExtension;
import 'package:devicelocale/devicelocale.dart';
import 'package:morningstar/domain/app_constants.dart';
import 'package:morningstar/domain/enums/app_server_reset_time_type.dart';
import 'package:morningstar/domain/enums/enums.dart';
import 'package:morningstar/domain/services/settings_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsServiceImpl extends SettingsService {
  final _appLanguageKey = 'AppLanguage';
  final _serverResetTimeKey = 'ServerResetTimeKey';
  final _showSoldierDetailsKey = 'ShowSoldierDetailsKey';
  final _useTwentyFourHoursFormatKey = 'UseTwentyFourHoursFormat';

  bool _initialized = false;

  late SharedPreferences _prefs;

  @override
  AppLanguageType get language => AppLanguageType.values[_prefs.getInt(_appLanguageKey)!];

  @override
  set language(AppLanguageType lang) => _prefs.setInt(_appLanguageKey, lang.index);

  @override
  bool get showSoldierDetails => _prefs.getBool(_showSoldierDetailsKey)!;

  @override
  set showSoldierDetails(bool show) =>_prefs.setBool(_showSoldierDetailsKey, show);

  @override
  AppServerResetTimeType get serverResetTime => AppServerResetTimeType.values[_prefs.getInt(_serverResetTimeKey)!];

  @override
  set serverResetTime(AppServerResetTimeType time) => _prefs.setInt(_serverResetTimeKey, time.index);

  @override
  bool get useTwentyFourHoursFormat => _prefs.getBool(_useTwentyFourHoursFormatKey)!;

  @override
  set useTwentyFourHoursFormat(bool value) => _prefs.setBool(_useTwentyFourHoursFormatKey, value);

  @override
  Future<void> init() async {
    if (_initialized) {
      return;
    }
    _prefs = await SharedPreferences.getInstance();

    if (_prefs.get(_appLanguageKey) == null) {
      language = await _getDefaultLangToUse();
    }
    
    if (_prefs.get(_showSoldierDetailsKey) == null) {
      showSoldierDetails = true;
    }

    if (_prefs.get(_serverResetTimeKey) == null) {
      serverResetTime = AppServerResetTimeType.europe;
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