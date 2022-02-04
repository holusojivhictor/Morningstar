import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:morningstar/domain/assets.dart';
import 'package:morningstar/domain/enums/enums.dart';

part 'weapon_card_model.freezed.dart';

@freezed
class WeaponCardModel with _$WeaponCardModel {
  String get imagePath => Assets.getImageCloudPath(AssetType.weapon, imageUrl);

  factory WeaponCardModel({
    required String key,
    required String imageUrl,
    required String name,
    required double damage,
    required double accuracy,
    required double range,
    required double fireRate,
    required double mobility,
    required double control,
    required WeaponType type,
    required WeaponModel model,
    required bool isComingSoon,
  }) = _WeaponCardModel;

  WeaponCardModel._();
}