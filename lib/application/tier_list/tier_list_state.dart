part of 'tier_list_bloc.dart';

@freezed
class TierListState with _$TierListState {
  const factory TierListState.loaded({
    required List<TierListRowModel> rows,
    required List<ItemCommon> weaponsAvailable,
    required bool readyToSave,
  }) = _LoadedState;
}
