part of 'main_bloc.dart';

@freezed
class MainState with _$MainState {
  const factory MainState.loading() = _MainLoadingState;
  const factory MainState.loaded({
    required String appTitle,
    required LanguageModel language,
    required bool initialized,
  }) = _MainLoadedState;
  const MainState._();
}