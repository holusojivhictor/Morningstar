part of 'weapons_bloc.dart';

@freezed
class WeaponsEvent with _$WeaponsEvent {
  const factory WeaponsEvent.init({
    @Default(<String>[]) List<String> excludeKeys,
  }) = _Init;

  const factory WeaponsEvent.searchChanged({
    required String search,
  }) = _SearchChanged;

  const factory WeaponsEvent.weaponTypeChanged(WeaponType weaponType) = _WeaponTypesChanged;

  /// Implement weapon models if interested in filtering with models (Assault, SMG...)
  // const factory WeaponsEvent.weaponModelChanged(WeaponModel weaponModel) = _WeaponModelsChanged;

  /// All the weapons are basic from inception
  // const factory WeaponsEvent.rarityChanged(int rarity) = _RarityChanged;

  const factory WeaponsEvent.weaponFilterTypeChanged(WeaponFilterType filterType) = _WeaponFilterChanged;

  const factory WeaponsEvent.applyFilterChanges() = _ApplyFilterChanges;

  const factory WeaponsEvent.sortDirectionChanged(SortDirectionType sortDirectionType) = _SortDirectionTypeChanged;

  const factory WeaponsEvent.cancelChanges() = _CancelChanges;

  const factory WeaponsEvent.resetFilters() = _ResetFilters;
}