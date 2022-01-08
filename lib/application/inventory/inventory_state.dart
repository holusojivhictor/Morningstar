part of 'inventory_bloc.dart';

@freezed
class InventoryState with _$InventoryState {
  const factory InventoryState.loading() = _LoadingState;

  const factory InventoryState.loaded({
    required List<SoldierCardModel> soldiers,
    required List<WeaponCardModel> weapons,
  }) = _LoadedState;
}