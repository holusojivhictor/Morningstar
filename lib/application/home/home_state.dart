part of 'home_bloc.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState.loading() = _LoadingState;
  const factory HomeState.loaded({
    required List<TodayTopPickSoldierModel> soldierTopPicks,
    required int day,
    required String dayName,
  }) = _LoadedState;
}
