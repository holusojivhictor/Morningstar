part of 'today_top_picks_bloc.dart';

@freezed
class TodayTopPicksState with _$TodayTopPicksState {
  const factory TodayTopPicksState.loading() =_LoadingState;
  const factory TodayTopPicksState.loaded({
    required List<TodayTopPickSoldierModel> topPicksSoldiers,
    required List<TodayTopPickWeaponModel> topPicksWeapons,
  }) = _LoadedState;
}