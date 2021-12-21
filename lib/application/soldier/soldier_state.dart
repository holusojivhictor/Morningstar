part of 'soldier_bloc.dart';

@freezed
class SoldierState with _$SoldierState {
  const factory SoldierState.loading() = _LoadingState;

  const factory SoldierState.loaded({
    required String key,
    required String name,
    required String imageUrl,
    String? secondImage,
    required int rarity,
    required ElementType elementType,
    required bool isInInventory,
  }) = _LoadedState;
}