part of 'main_bloc.dart';

@freezed
class MainEvent with _$MainEvent {
  const factory MainEvent.init() = _Init;

  const factory MainEvent.languageChanged({
    required AppLanguageType newValue,
  }) = _LanguageChanged;

  const MainEvent._();
}