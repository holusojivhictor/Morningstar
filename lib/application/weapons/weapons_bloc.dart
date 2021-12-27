import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:morningstar/domain/enums/enums.dart';
import 'package:morningstar/domain/models/models.dart';
import 'package:morningstar/domain/services/morningstar_service.dart';
import 'package:morningstar/domain/services/settings_service.dart';

part 'weapons_bloc.freezed.dart';
part 'weapons_event.dart';
part 'weapons_state.dart';

class WeaponsBloc extends Bloc<WeaponsEvent, WeaponsState> {
  final MorningStarService _morningStarService;
  final SettingsService _settingsService;

  WeaponsBloc(this._morningStarService, this._settingsService) : super(const WeaponsState.loading());

  _LoadedState get currentState => state as _LoadedState;

  @override
  Stream<WeaponsState> mapEventToState(WeaponsEvent event) async* {
    final s = event.map(
      init: (e) => _buildInitialState(excludeKeys: e.excludeKeys, weaponTypes: WeaponType.values),
      weaponFilterTypeChanged: (e) => currentState.copyWith.call(tempWeaponFilterType: e.filterType),
      sortDirectionChanged: (e) => currentState.copyWith.call(tempSortDirectionType: e.sortDirectionType),
      weaponTypeChanged: (e) {
        var types = <WeaponType>[];
        if (currentState.tempWeaponTypes.contains(e.weaponType)) {
          types = currentState.tempWeaponTypes.where((t) => t != e.weaponType).toList();
        } else {
          types = currentState.tempWeaponTypes + [e.weaponType];
        }
        return currentState.copyWith.call(tempWeaponTypes: types);
      },
      searchChanged: (e) => _buildInitialState(
        search: e.search,
        weaponFilterType: currentState.weaponFilterType,
        sortDirectionType: currentState.sortDirectionType,
        weaponTypes: currentState.weaponTypes,
        excludeKeys: currentState.excludeKeys,
      ),
      applyFilterChanges: (_) => _buildInitialState(
        search: currentState.search,
        weaponFilterType: currentState.tempWeaponFilterType,
        sortDirectionType: currentState.tempSortDirectionType,
        weaponTypes: currentState.tempWeaponTypes,
        excludeKeys: currentState.excludeKeys,
      ),
      cancelChanges: (_) => currentState.copyWith.call(
        tempWeaponTypes: currentState.tempWeaponTypes,
        tempWeaponFilterType: currentState.weaponFilterType,
        tempSortDirectionType: currentState.sortDirectionType,
        excludeKeys: currentState.excludeKeys,
      ),
      resetFilters: (_) => _buildInitialState(
        excludeKeys: state.maybeMap(loaded: (state) => state.excludeKeys, orElse: () => []),
        weaponTypes: WeaponType.values,
      ),
    );

    yield s;
  }

  WeaponsState _buildInitialState({
    String? search,
    List<String> excludeKeys = const [],
    List<WeaponType> weaponTypes = const [],
    WeaponFilterType weaponFilterType = WeaponFilterType.name,
    SortDirectionType sortDirectionType = SortDirectionType.asc,
  }) {
    final isLoaded = state is _LoadedState;
    var data = _morningStarService.getWeaponsForCard();
    if (excludeKeys.isNotEmpty) {
      data = data.where((el) => !excludeKeys.contains(el.key)).toList();
    }

    if (!isLoaded) {
      final selectedWeaponTypes = WeaponType.values.toList();
      _sortData(data, weaponFilterType, sortDirectionType);
      return WeaponsState.loaded(
        weapons: data,
        search: search,
        weaponTypes: selectedWeaponTypes,
        tempWeaponTypes: selectedWeaponTypes,
        weaponFilterType: weaponFilterType,
        tempWeaponFilterType: weaponFilterType,
        sortDirectionType: sortDirectionType,
        tempSortDirectionType: sortDirectionType,
        showWeaponDetails: _settingsService.showWeaponDetails,
        excludeKeys: excludeKeys,
      );
    }

    if (search != null && search.isNotEmpty) {
      data = data.where((el) => el.name.toLowerCase().contains(search.toLowerCase())).toList();
    }

    if (weaponTypes.isNotEmpty) {
      data = data.where((el) => weaponTypes.contains(el.type)).toList();
    }
    
    _sortData(data, weaponFilterType, sortDirectionType);

    final s = currentState.copyWith.call(
      weapons: data,
      search: search,
      weaponTypes: weaponTypes,
      tempWeaponTypes: weaponTypes,
      weaponFilterType: weaponFilterType,
      tempWeaponFilterType: weaponFilterType,
      sortDirectionType: sortDirectionType,
      tempSortDirectionType: sortDirectionType,
      excludeKeys: excludeKeys,
    );
    return s;
  }

  void _sortData(List<WeaponCardModel> data, WeaponFilterType weaponFilterType, SortDirectionType sortDirectionType) {
    switch (weaponFilterType) {
      case WeaponFilterType.damage:
        if (sortDirectionType == SortDirectionType.asc) {
          data.sort((x, y) => x.damage.compareTo(y.damage));
        } else {
          data.sort((x, y) => y.damage.compareTo(x.damage));
        }
        break;
      case WeaponFilterType.name:
        if (sortDirectionType == SortDirectionType.asc) {
          data.sort((x, y) => x.name.compareTo(y.name));
        } else {
          data.sort((x, y) => y.name.compareTo(x.name));
        }
        break;
      default:
        break;
    }
  }
}