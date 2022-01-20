import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morningstar/domain/services/data_service.dart';
import 'package:morningstar/domain/services/logging_service.dart';
import 'package:morningstar/domain/services/morningstar_service.dart';
import 'package:morningstar/domain/services/telemetry_service.dart';

import '../../domain/models/models.dart';

part 'tier_list_bloc.freezed.dart';
part 'tier_list_event.dart';
part 'tier_list_state.dart';

const _initialState = TierListState.loaded(rows: [], weaponsAvailable: [], readyToSave: false);

class TierListBloc extends Bloc<TierListEvent, TierListState> {
  final MorningStarService _morningStarService;
  final DataService _dataService;
  final TelemetryService _telemetryService;
  final LoggingService _loggingService;

  static final List<int> defaultColors = [
    0xfff44336,
    0xfff56c62,
    0xffff7d06,
    0xffff9800,
    0xffffc107,
    0xffffeb3b,
    0xff8bc34a,
  ];

  _LoadedState get currentState => state as _LoadedState;

  TierListBloc(this._morningStarService, this._dataService, this._telemetryService, this._loggingService) : super(_initialState);

  @override
  Stream<TierListState> mapEventToState(TierListEvent event) async* {
    final s = await event.map(
      init: (e) async => _init(e.reset),
      rowTextChanged: (e) async => _rowTextChanged(e.index, e.newValue),
      rowPositionChanged: (e) async => _rowPositionChanged(e.index, e.newIndex),
      rowColorChanged: (e) async => _rowColorChanged(e.index, e.newColor),
      addNewRow: (e) async => _addNewRow(e.index, e.above),
      deleteRow: (e) async => _deleteRow(e.index),
      clearRow: (e) async => _clearRow(e.index),
      clearAllRows: (e) async => _clearAllRows(),
      addWeaponToRow: (e) async => _addWeaponToRow(e.index, e.item),
      deleteWeaponFromRow: (e) async => _deleteWeaponFromRow(e.index, e.item),
      readyToSave: (e) async => currentState.copyWith.call(readyToSave: e.ready),
      screenshotTaken: (e) async {
        if (e.succeed) {
          await _telemetryService.trackTierListBuilderScreenshotTaken();
          return _init(false);
        } else {
          _loggingService.error(runtimeType, 'Something went wrong while taking the tier list builder screenshot', e.ex, e.trace);
        }

        return currentState;
      },
    );

    yield s;
  }

  Future<TierListState> _init(bool reset) async {
    await _telemetryService.trackTierListOpened();
    if (reset) {
      await _dataService.deleteTierList();
    }

    final tierList = _dataService.getTierList();
    final defaultTierList = _morningStarService.getDefaultWeaponTierList(defaultColors);
    if (tierList.isEmpty) {
      return TierListState.loaded(rows: defaultTierList, weaponsAvailable: [], readyToSave: false);
    }

    final items = tierList.expand((el) => el.items).toList();
    final availableWeapons = defaultTierList.expand((el) => el.items).where((el) => !items.any((x) => x.key == el.key)).toList();
    return TierListState.loaded(rows: tierList, weaponsAvailable: availableWeapons, readyToSave: false);
  }

  Future<TierListState> _rowTextChanged(int index, String newValue) async {
    final updated = currentState.rows.elementAt(index).copyWith.call(tierText: newValue);
    final rows = _updateRows(updated, index, index);
    await _dataService.saveTierList(rows);
    return currentState.copyWith.call(rows: rows);
  }

  Future<TierListState> _rowPositionChanged(int index, int newIndex) async {
    final updated = currentState.rows.elementAt(index);
    final rows = _updateRows(updated, newIndex, index);
    await _dataService.saveTierList(rows);
    return currentState.copyWith.call(rows: rows);
  }

  Future<TierListState> _rowColorChanged(int index, int newColor) async {
    final updated = currentState.rows.elementAt(index).copyWith.call(tierColor: newColor);
    final rows = _updateRows(updated, index, index);
    await _dataService.saveTierList(rows);
    return currentState.copyWith.call(rows: rows);
  }

  Future<TierListState> _addNewRow(int index, bool above) async {
    final colorsCopy = [...defaultColors];
    final color = (colorsCopy..shuffle()).first;
    final newIndex = above ? index : index + 1;

    final newRow = TierListRowModel.row(tierText: (currentState.rows.length + 1).toString(), tierColor: color, items: []);
    final rows = [...currentState.rows];
    rows.insert(newIndex, newRow);
    await _dataService.saveTierList(rows);
    return currentState.copyWith.call(rows: rows);
  }

  Future<TierListState> _deleteRow(int index) async {
    if (currentState.rows.length == 1) {
      return currentState;
    }
    final rows = [...currentState.rows];
    final row = rows.elementAt(index);
    final weapons = _updateAvailableWeapons([...currentState.weaponsAvailable, ...row.items], []);
    rows.removeAt(index);
    await _dataService.saveTierList(rows);
    return currentState.copyWith.call(rows: rows, weaponsAvailable: weapons);
  }

  Future<TierListState> _clearRow(int index) async {
    final row = currentState.rows.elementAt(index);
    final updated = row.copyWith.call(items: []);
    final rows = _updateRows(updated, index, index);
    final weapons = _updateAvailableWeapons([...currentState.weaponsAvailable, ...row.items], []);
    await _dataService.saveTierList(rows);
    return currentState.copyWith.call(rows: rows, weaponsAvailable: weapons);
  }

  Future<TierListState> _clearAllRows() async {
    final weapons = _updateAvailableWeapons(_morningStarService.getDefaultWeaponTierList(defaultColors).expand((row) => row.items).toList(), []);
    final updatedRows = currentState.rows.map((row) => row.copyWith.call(items: [])).toList();
    await _dataService.saveTierList(updatedRows);
    return currentState.copyWith.call(rows: updatedRows, weaponsAvailable: weapons, readyToSave: false);
  }

  Future<TierListState> _addWeaponToRow(int index, ItemCommon item) async {
    if (!currentState.weaponsAvailable.any((el) => el.key == item.key)) {
      return currentState;
    }
    final row = currentState.rows.elementAt(index);
    final updated = row.copyWith.call(items: [...row.items, item]);
    final updatedWeapons = _updateAvailableWeapons(currentState.weaponsAvailable, [item]);
    final updatedRows = _updateRows(updated, index, index);
    await _dataService.saveTierList(updatedRows);
    return currentState.copyWith.call(rows: updatedRows, weaponsAvailable: updatedWeapons);
  }

  Future<TierListState> _deleteWeaponFromRow(int index, ItemCommon item) async {
    final row = currentState.rows.elementAt(index);
    final updated = row.copyWith.call(items: row.items.where((el) => el.key != item.key).toList());
    final updatedWeapons = _updateAvailableWeapons([...currentState.weaponsAvailable, item], []);
    final updatedRows = _updateRows(updated, index, index);
    await _dataService.saveTierList(updatedRows);
    return currentState.copyWith.call(rows: updatedRows, weaponsAvailable: updatedWeapons, readyToSave: false);
  }

  List<TierListRowModel> _updateRows(TierListRowModel updated, int newIndex, int excludeIndex) {
    final rows = <TierListRowModel>[];

    if (newIndex < 0 || newIndex == currentState.rows.length) {
      return currentState.rows;
    }

    for (int i = 0; i < currentState.rows.length; i++) {
      if (i == excludeIndex) {
        continue;
      }
      final row = currentState.rows[i];
      rows.add(row);
    }
    
    rows.insert(newIndex, updated);
    return rows;
  }

  List<ItemCommon> _updateAvailableWeapons(List<ItemCommon> from, List<ItemCommon> exclude) {
    var weapons = from;
    if (exclude.isNotEmpty) {
      weapons = weapons.where((item) => !exclude.any((el) => el.key == item.key)).toList();
    }
    return weapons..sort((x, y) => x.key.compareTo(y.key));
  }
}
