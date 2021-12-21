import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:morningstar/application/common/pop_bloc.dart';
import 'package:morningstar/domain/enums/enums.dart';
import 'package:morningstar/domain/models/models.dart';
import 'package:morningstar/domain/services/data_service.dart';
import 'package:morningstar/domain/services/morningstar_service.dart';
import 'package:morningstar/domain/services/telemetry_service.dart';

part 'soldier_bloc.freezed.dart';
part 'soldier_event.dart';
part 'soldier_state.dart';

class SoldierBloc extends PopBloc<SoldierEvent, SoldierState> {
  final MorningStarService _morningStarService;
  final TelemetryService _telemetryService;
  final DataService _dataService;

  SoldierBloc(
    this._morningStarService,
    this._telemetryService,
    this._dataService,
  ) : super(const SoldierState.loading());

  @override
  SoldierEvent getEventForPop(String? key) =>
      SoldierEvent.loadFromKey(key: key!, addToQueue: false);

  @override
  Stream<SoldierState> mapEventToState(SoldierEvent event) async* {
    if (event is! _AddedToInventory) {
      yield const SoldierState.loading();
    }

    final s = await event.when(
      loadFromKey: (key, addToQueue) async {
        final soldierModel = _morningStarService.getSoldier(key);
        final translation = _morningStarService.getSoldierTranslation(key);

        if (addToQueue) {
          await _telemetryService.trackSoldierLoaded(key);
          currentItemsInStack.add(soldierModel.key);
        }
        return _buildInitialState(soldierModel, translation);
      },
      addedToInventory: (key, wasAdded) async {
        if (state is! _LoadedState) {
          return state;
        }

        final currentState = state as _LoadedState;
        if (currentState.key != key) {
          return state;
        }

        return currentState.copyWith.call(isInInventory: wasAdded);
      },
    );

    yield s;
  }

  SoldierState _buildInitialState(SoldierFileModel soldierModel, TranslationSoldierFile translation) {
    final isInInventory = _dataService.isItemInInventory(soldierModel.key, ItemType.soldier);

    return SoldierState.loaded(
      key: soldierModel.key,
      name: translation.name,
      imageUrl: soldierModel.imageUrl,
      secondImage: soldierModel.secondImage != null ? soldierModel.secondImage! : null,
      rarity: soldierModel.rarity,
      elementType: soldierModel.elementType,
      isInInventory: isInInventory,
    );
  }
}
