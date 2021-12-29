part of 'settings_bloc.dart';

@freezed
class SettingsState with _$SettingsState {
  const factory SettingsState.loading() = _LoadingState;

  const factory SettingsState.loaded({
    required AppThemeType currentTheme,
    required AppLanguageType currentLanguage,
    required String appVersion,
    required bool showSoldierDetails,
    required bool showWeaponDetails,
    required AppServerResetTimeType serverResetTime,
    required bool doubleBackToClose,
    required bool useTwentyFourHoursFormat,
  }) = _LoadedState;
}