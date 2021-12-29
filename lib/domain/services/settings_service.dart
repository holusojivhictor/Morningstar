import 'package:morningstar/domain/enums/enums.dart';
import 'package:morningstar/domain/models/settings/app_settings.dart';

abstract class SettingsService {
  AppSettings get appSettings;

  AppThemeType get appTheme;
  set appTheme(AppThemeType theme);

  bool get isFirstInstall;
  set isFirstInstall(bool itIs);

  AppLanguageType get language;
  set language(AppLanguageType lang);

  bool get showSoldierDetails;
  set showSoldierDetails(bool show);

  bool get showWeaponDetails;
  set showWeaponDetails(bool show);

  AppServerResetTimeType get serverResetTime;
  set serverResetTime(AppServerResetTimeType time);

  bool get doubleBackToClose;
  set doubleBackToClose(bool value);

  bool get useTwentyFourHoursFormat;
  set useTwentyFourHoursFormat(bool value);

  Future<void> init();
}