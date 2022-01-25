import 'package:morningstar/domain/enums/enums.dart';

class VehicleCamoCardModel {
  final String name;
  final ElementType elementType;
  final String imageUrl;
  final int rarity;
  final bool isComingSoon;

  VehicleCamoCardModel({
    required this.name,
    required this.elementType,
    required this.imageUrl,
    required this.rarity,
    required this.isComingSoon,
  });
}