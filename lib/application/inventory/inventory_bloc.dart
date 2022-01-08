import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:morningstar/application/bloc.dart';
import 'package:morningstar/domain/enums/enums.dart';
import 'package:morningstar/domain/models/models.dart';
import 'package:morningstar/domain/services/data_service.dart';
import 'package:morningstar/domain/services/morningstar_service.dart';
import 'package:morningstar/domain/services/telemetry_service.dart';

part 'inventory_bloc.freezed.dart';
part 'inventory_event.dart';
part 'inventory_state.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final MorningStarService _morningStarService;
  final DataService _dataService;
  final TelemetryService _telemetryService;
  final SoldierBloc _soldierBloc;
  final WeaponBloc _weaponBloc;

  InventoryBloc(
    this._morningStarService,
    this._dataService,
    this._telemetryService,
    this._soldierBloc,
      this._weaponBloc,
  ) : super(const InventoryState.loading());

  @override
  Stream<InventoryState> mapEventToState(InventoryEvent event) async* {
    final s = await event.map(
      init: (_) async {
        final soldiers = _dataService.getAllSoldiersInInventory();
        final weapons = _dataService.getAllWeaponsInInventory();

        return InventoryState.loaded(soldiers: soldiers, weapons: weapons);
      },
      addSoldier: (e) async {
        await _telemetryService.trackItemAddedToInventory(e.key, 1);
        await _dataService.addItemToInventory(e.key, ItemType.soldier, 1);
        _soldierBloc.add(SoldierEvent.addedToInventory(key: e.key, wasAdded: true));

        return state.map(
          loading: (state) => state,
          loaded: (state) => state.copyWith.call(soldiers: _dataService.getAllSoldiersInInventory()),
        );
      },
      addWeapon: (e) async {
        await _telemetryService.trackItemAddedToInventory(e.key, 1);
        await _dataService.addItemToInventory(e.key, ItemType.weapon, 1);
        _weaponBloc.add(WeaponEvent.addedToInventory(key: e.key, wasAdded: true));

        return state.map(
          loading: (state) => state,
          loaded: (state) => state.copyWith.call(weapons: _dataService.getAllWeaponsInInventory()),
        );
      },
      deleteSoldier: (e) async {
        await _telemetryService.trackItemDeletedFromInventory(e.key);
        await _dataService.deleteItemFromInventory(e.key, ItemType.soldier);
        _soldierBloc.add(SoldierEvent.addedToInventory(key: e.key, wasAdded: false));

        return state.map(
          loading: (state) => state,
          loaded: (state) => state.copyWith.call(soldiers: _dataService.getAllSoldiersInInventory()),
        );
      },
      deleteWeapon: (e) async {
        await _telemetryService.trackItemDeletedFromInventory(e.key);
        await _dataService.deleteItemFromInventory(e.key, ItemType.weapon);
        _weaponBloc.add(WeaponEvent.addedToInventory(key: e.key, wasAdded: false));

        return state.map(
          loading: (state) => state,
          loaded: (state) => state.copyWith.call(weapons: _dataService.getAllWeaponsInInventory()),
        );
      },
      close: (_) async => const InventoryState.loaded(soldiers: [], weapons: []),
      clearAllSoldiers: (_) async {
        await _telemetryService.trackItemsDeletedFromInventory(ItemType.soldier);
        await _dataService.deleteItemsFromInventory(ItemType.soldier);

        return state.map(
          loading: (state) => state,
          loaded: (state) => state.copyWith.call(soldiers: []),
        );
      },
      clearAllWeapons: (_) async {
        await _telemetryService.trackItemsDeletedFromInventory(ItemType.weapon);
        await _dataService.deleteItemsFromInventory(ItemType.weapon);

        return state.map(
          loading: (state) => state,
          loaded: (state) => state.copyWith.call(weapons: []),
        );
      },
    );

    yield s;
  }

  List<String> getItemKeysToExclude() {
    final upcoming = _morningStarService.getUpComingKeys();
    return state.maybeMap(
      loaded: (state) => state.soldiers.map((e) => e.key).toList() + state.weapons.map((e) => e.key).toList() + upcoming,
      orElse: () => upcoming,
    );
  }
}
