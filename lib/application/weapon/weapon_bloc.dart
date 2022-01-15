import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:morningstar/application/common/pop_bloc.dart';
import 'package:morningstar/domain/enums/enums.dart';
import 'package:morningstar/domain/models/models.dart';
import 'package:morningstar/domain/services/data_service.dart';
import 'package:morningstar/domain/services/morningstar_service.dart';
import 'package:morningstar/domain/services/telemetry_service.dart';

part 'weapon_bloc.freezed.dart';
part 'weapon_event.dart';
part 'weapon_state.dart';

class WeaponBloc extends PopBloc<WeaponEvent, WeaponState> {
  final MorningStarService _morningStarService;
  final TelemetryService _telemetryService;
  final DataService _dataService;

  WeaponBloc(this._morningStarService, this._telemetryService, this._dataService) : super(const WeaponState.loading());

  @override
  WeaponEvent getEventForPop(String? key) => WeaponEvent.loadFromKey(key: key!, addToQueue: false);

  @override
  Stream<WeaponState> mapEventToState(WeaponEvent event) async* {
    if (event is! _AddedToInventory) {
      yield const WeaponState.loading();
    }

    final s = await event.when(
      loadFromKey: (key, addToQueue) async {
        final weapon = _morningStarService.getWeapon(key);
        final translation = _morningStarService.getWeaponTranslation(weapon.key);

        if (addToQueue) {
          await _telemetryService.trackWeaponLoaded(key);
          currentItemsInStack.add(weapon.key);
        }
        return _buildInitialState(weapon, translation);
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

  WeaponState _buildInitialState(WeaponFileModel weapon, TranslationWeaponFile translation) {
    final isInInventory = _dataService.isItemInInventory(weapon.key, ItemType.weapon);

    return WeaponState.loaded(
      key: weapon.key,
      name: translation.name,
      weaponType: weapon.type,
      weaponModel: weapon.model,
      fullImage: weapon.fullImagePath,
      damage: weapon.damage,
      accuracy: weapon.accuracy,
      range: weapon.range,
      fireRate: weapon.fireRate,
      mobility: weapon.mobility,
      control: weapon.control,
      description: translation.description,
      isInInventory: isInInventory,
      blueprints: weapon.blueprints.map((blueprint) {
        return WeaponBlueprintCardModel(
          name: blueprint.name,
          elementType: blueprint.elementType,
          imageUrl: blueprint.imageUrl,
          rarity: blueprint.rarity,
          weaponKey: blueprint.weaponKey,
          isComingSoon: blueprint.isComingSoon,
        );
      }).toList(),
      camos: weapon.camos.map((camo) {
        return WeaponCamoCardModel(
          name: camo.name,
          elementType: camo.elementType,
          source: camo.source,
          imageUrl: camo.imageUrl,
          rarity: camo.rarity,
          weaponKey: camo.weaponKey,
          isComingSoon: camo.isComingSoon,
        );
      }).toList(),
      attachments: weapon.attachments.map((attachment) {
        return WeaponAttachmentCardModel(
          name: attachment.name,
          type: attachment.type,
          unlockLevel: attachment.unlockLevel,
        );
      }).toList(),
    );
  }
}