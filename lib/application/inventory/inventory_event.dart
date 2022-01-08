part of 'inventory_bloc.dart';

@freezed
class InventoryEvent with _$InventoryEvent {
  const factory InventoryEvent.init() = _Init;

  const factory InventoryEvent.addSoldier({
    required String key,
  }) = _AddSoldier;

  const factory InventoryEvent.addWeapon({
    required String key,
  }) = _AddWeapon;

  const factory InventoryEvent.deleteSoldier({
    required String key,
  }) = _DeleteSoldier;

  const factory InventoryEvent.deleteWeapon({
    required String key,
  }) = _DeleteWeapon;

  const factory InventoryEvent.close() = _Close;

  const factory InventoryEvent.clearAllSoldiers() = _ClearAllSoldiers;

  const factory InventoryEvent.clearAllWeapons() = _ClearAllWeapons;
}