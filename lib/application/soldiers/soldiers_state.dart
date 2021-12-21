part of 'soldiers_bloc.dart';

@freezed
class SoldiersState with _$SoldiersState {
  const factory SoldiersState.loading() = _LoadingState;

  const factory SoldiersState.loaded({
    required List<SoldierCardModel> soldiers,
    String? search,
    required bool showSoldierDetails,
    required List<ElementType> elementTypes,
    required List<ElementType> tempElementTypes,
    required int rarity,
    required int tempRarity,
    ItemStatusType? statusType,
    ItemStatusType? tempStatusType,
    required SoldierFilterType soldierFilterType,
    required SoldierFilterType tempSoldierFilterType,
    required SortDirectionType sortDirectionType,
    required SortDirectionType tempSortDirectionType,
    @Default(<String>[]) List<String> excludeKeys,
  }) = _LoadedState;
}