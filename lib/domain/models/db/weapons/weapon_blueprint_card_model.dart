import 'package:morningstar/domain/enums/enums.dart';

import '../../../assets.dart';

class WeaponBlueprintCardModel {
  String get imageCloudPath => Assets.getWeaponCloudAll(imageUrl);

  String get imagePath => Assets.getImageCloudPath(AssetType.weapon, imageUrl);

  final String name;
  final ElementType elementType;
  final String? imageUrl;
  final int rarity;
  final String weaponKey;
  final bool isComingSoon;

  WeaponBlueprintCardModel({
    required this.name,
    required this.elementType,
    required this.imageUrl,
    required this.rarity,
    required this.weaponKey,
    required this.isComingSoon,
  });
}