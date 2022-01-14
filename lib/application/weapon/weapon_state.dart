part of 'weapon_bloc.dart';

@freezed
class WeaponState with _$WeaponState {
  const factory WeaponState.loading() = _LoadingState;

  const factory WeaponState.loaded({
    required String key,
    required String name,
    required WeaponType weaponType,
    required WeaponModel weaponModel,
    required String fullImage,
    required double damage,
    required double accuracy,
    required double range,
    required double fireRate,
    required double mobility,
    required double control,
    required String description,
    required bool isInInventory,
    required List<WeaponBlueprintCardModel> blueprints,
    required List<WeaponCamoCardModel> camos,
    required List<WeaponAttachmentCardModel> attachments,
  }) = _LoadedState;
}