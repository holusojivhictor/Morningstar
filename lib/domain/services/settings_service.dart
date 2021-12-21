import 'package:morningstar/domain/enums/enums.dart';

abstract class SettingsService {
  AppLanguageType get language;
  set language(AppLanguageType lang);

  bool get showSoldierDetails;
  set showSoldierDetails(bool show);

  AppServerResetTimeType get serverResetTime;
  set serverResetTime(AppServerResetTimeType time);

  bool get useTwentyFourHoursFormat;
  set useTwentyFourHoursFormat(bool value);

  Future<void> init();
}