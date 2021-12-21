import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:morningstar/domain/enums/enums.dart';
import 'package:morningstar/domain/models/models.dart';
import 'package:morningstar/domain/services/morningstar_service.dart';
import 'package:morningstar/domain/services/settings_service.dart';

part 'soldiers_bloc.freezed.dart';
part 'soldiers_event.dart';
part 'soldiers_state.dart';

class SoldiersBloc extends Bloc<SoldiersEvent, SoldiersState> {
  final MorningStarService _morningStarService;
  final SettingsService _settingsService;

  SoldiersBloc(this._morningStarService, this._settingsService) : super(const SoldiersState.loading());

  _LoadedState get currentState => state as _LoadedState;

  @override
  Stream<SoldiersState> mapEventToState(SoldiersEvent event) async* {
    final s = event.map(
      init: (e) => _buildInitialState(excludeKeys: e.excludeKeys, elementTypes: ElementType.values),
      soldierFilterTypeChanged: (e) => currentState.copyWith.call(tempSoldierFilterType: e.soldierFilterType),
      elementTypeChanged: (e) {
        var types = <ElementType>[];
        if (currentState.tempElementTypes.contains(e.elementType)) {
          types = currentState.tempElementTypes.where((t) => t != e.elementType).toList();
        } else {
          types = currentState.tempElementTypes + [e.elementType];
        }
        return currentState.copyWith.call(tempElementTypes: types);
      },
      rarityChanged: (e) => currentState.copyWith.call(tempRarity: e.rarity),
      itemStatusChanged: (e) => currentState.copyWith.call(tempStatusType: e.statusType),
      sortDirectionTypeChanged: (e) => currentState.copyWith.call(tempSortDirectionType: e.sortDirectionType),
      searchChanged: (e) => _buildInitialState(
        search: e.search,
        soldierFilterType: currentState.soldierFilterType,
        elementTypes: currentState.elementTypes,
        rarity: currentState.rarity,
        statusType: currentState.statusType,
        sortDirectionType: currentState.sortDirectionType,
        excludeKeys: currentState.excludeKeys,
      ),
      applyFilterChanges: (_) => _buildInitialState(
        search: currentState.search,
        soldierFilterType: currentState.tempSoldierFilterType,
        elementTypes: currentState.tempElementTypes,
        rarity: currentState.tempRarity,
        statusType: currentState.tempStatusType,
        sortDirectionType: currentState.tempSortDirectionType,
        excludeKeys: currentState.excludeKeys,
      ),
      cancelChanges: (_) => currentState.copyWith.call(
        tempSoldierFilterType: currentState.soldierFilterType,
        tempElementTypes: currentState.elementTypes,
        tempRarity: currentState.rarity,
        tempStatusType: currentState.statusType,
        tempSortDirectionType: currentState.sortDirectionType,
        excludeKeys: currentState.excludeKeys,
      ),
      resetFilters: (_) => _buildInitialState(
        excludeKeys: state.maybeMap(loaded: (state) => state.excludeKeys, orElse: () => []),
        elementTypes: ElementType.values,
      ),
    );
    yield s;
  }

  SoldiersState _buildInitialState({
    String? search,
    List<String> excludeKeys = const [],
    List<ElementType> elementTypes = const [],
    int rarity = 0,
    ItemStatusType? statusType,
    SoldierFilterType soldierFilterType = SoldierFilterType.name,
    SortDirectionType sortDirectionType = SortDirectionType.asc,
  }) {
    final isLoaded = state is _LoadedState;
    var soldiers = _morningStarService.getSoldiersForCard();
    if (excludeKeys.isNotEmpty) {
      soldiers = soldiers.where((el) => !excludeKeys.contains(el.key)).toList();
    }

    if (!isLoaded) {
      final selectedElementTypes = ElementType.values.toList();
      _sortData(soldiers, soldierFilterType, sortDirectionType);
      return SoldiersState.loaded(
        soldiers: soldiers,
        search: search,
        elementTypes: selectedElementTypes,
        tempElementTypes: selectedElementTypes,
        rarity: rarity,
        tempRarity: rarity,
        statusType: statusType,
        tempStatusType: statusType,
        soldierFilterType: soldierFilterType,
        tempSoldierFilterType: soldierFilterType,
        sortDirectionType: sortDirectionType,
        tempSortDirectionType: sortDirectionType,
        excludeKeys: excludeKeys,
        showSoldierDetails: _settingsService.showSoldierDetails,
      );
    }

    if (search != null && search.isNotEmpty) {
      soldiers = soldiers.where((el) => el.name.toLowerCase().contains(search.toLowerCase())).toList();
    }

    if (rarity > 0) {
      soldiers = soldiers.where((el) => el.stars == rarity).toList();
    }

    if (elementTypes.isNotEmpty) {
      soldiers = soldiers.where((el) => elementTypes.contains(el.elementType)).toList();
    }

    switch (statusType) {
      case ItemStatusType.released:
        soldiers = soldiers.where((el) => !el.isComingSoon).toList();
        break;
      case ItemStatusType.comingSoon:
        soldiers = soldiers.where((el) => el.isComingSoon).toList();
        break;
      case ItemStatusType.newItem:
        soldiers = soldiers.where((el) => el.isNew).toList();
        break;
      default:
        break;
    }
    
    _sortData(soldiers, soldierFilterType, sortDirectionType);

    final s = currentState.copyWith.call(
      soldiers: soldiers,
      search: search,
      elementTypes: elementTypes,
      tempElementTypes: elementTypes,
      rarity: rarity,
      tempRarity: rarity,
      statusType: statusType,
      tempStatusType: statusType,
      soldierFilterType: soldierFilterType,
      tempSoldierFilterType: soldierFilterType,
      sortDirectionType: sortDirectionType,
      tempSortDirectionType: sortDirectionType,
      excludeKeys: excludeKeys,
    );
    return s;
  }

  void _sortData(List<SoldierCardModel> data, SoldierFilterType soldierFilterType, SortDirectionType sortDirectionType) {
    switch (soldierFilterType) {
      case SoldierFilterType.name:
        if (sortDirectionType == SortDirectionType.asc) {
          data.sort((x, y) => x.name.compareTo(y.name));
        } else {
          data.sort((x, y) => y.name.compareTo(x.name));
        }
        break;
      case SoldierFilterType.rarity:
        if (sortDirectionType == SortDirectionType.asc) {
          data.sort((x, y) => x.stars.compareTo(y.stars));
        } else {
          data.sort((x, y) => y.stars.compareTo(x.stars));
        }
        break;
      default:
        break;
    }
  }
}