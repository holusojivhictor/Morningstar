import 'package:morningstar/domain/enums/enums.dart';

import '../../../assets.dart';

class WeaponCamoCardModel {
  String get imagePath => Assets.getWeaponCloudAll(imageUrl);

  final String name;
  final ElementType elementType;
  final String source;
  final String? imageUrl;
  final int rarity;

  WeaponCamoCardModel({
    required this.name,
    required this.elementType,
    required this.source,
    required this.imageUrl,
    required this.rarity,
  });
}