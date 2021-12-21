part of 'soldiers_bloc.dart';

@freezed
class SoldiersEvent with _$SoldiersEvent {
  const factory SoldiersEvent.init({
    @Default(<String>[]) List<String> excludeKeys,
}) = _Init;

  const factory SoldiersEvent.searchChanged({
  required String search,
  }) = _SearchChanged;

  const factory SoldiersEvent.elementTypeChanged(ElementType elementType) = _ElementTypesChanged;

  const factory SoldiersEvent.rarityChanged(int rarity) = _RarityChanged;

  const factory SoldiersEvent.itemStatusChanged(ItemStatusType? statusType) = _ReleasedUnreleasedTypeChanged;

  const factory SoldiersEvent.soldierFilterTypeChanged(SoldierFilterType soldierFilterType) = _SoldierFilterChanged;

  const factory SoldiersEvent.sortDirectionTypeChanged(SortDirectionType sortDirectionType) = _SortDirectionTypeChanged;

  const factory SoldiersEvent.applyFilterChanges() = _ApplyFilterChanges;

  const factory SoldiersEvent.cancelChanges() = _CancelChanges;

  const factory SoldiersEvent.resetFilters() = _ResetFilters;
}