part of 'soldier_bloc.dart';

@freezed
class SoldierEvent with _$SoldierEvent {
  const factory SoldierEvent.loadFromKey({
    required String key,
    @Default(true) bool addToQueue,
  }) = _LoadSoldierFromName;

  const factory SoldierEvent.addedToInventory({
    required String key,
    required bool wasAdded,
  }) = _AddedToInventory;
}