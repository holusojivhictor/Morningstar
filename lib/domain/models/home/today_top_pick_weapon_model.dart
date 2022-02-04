import 'package:morningstar/domain/enums/enums.dart';

import '../../assets.dart';

class TodayTopPickWeaponModel {
  String get imagePath => Assets.getImageCloudPath(AssetType.weapon, imageUrl);

  final String key;
  final String imageUrl;
  final String name;
  final double damage;
  final double accuracy;
  final double range;
  final double fireRate;
  final double mobility;
  final double control;
  final WeaponType type;
  final WeaponModel model;
  final bool isComingSoon;
  final List<int> days;

  bool get onlyShowsInDays => days.isNotEmpty;

  TodayTopPickWeaponModel.fromDays({
    required this.key,
    required this.imageUrl,
    required this.name,
    required this.damage,
    required this.accuracy,
    required this.range,
    required this.fireRate,
    required this.mobility,
    required this.control,
    required this.type,
    required this.model,
    required this.isComingSoon,
  }) : days = [];
}