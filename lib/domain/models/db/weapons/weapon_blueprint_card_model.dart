import 'package:morningstar/domain/enums/enums.dart';

import '../../../assets.dart';

class WeaponBlueprintCardModel {
  String get imagePath => Assets.getWeaponCloudAll(imageUrl);

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