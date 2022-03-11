import 'package:morningstar/domain/assets.dart';
import 'package:morningstar/domain/enums/enums.dart';

class TodayTopPickSoldierModel {
  String get imagePath => Assets.getImageCloudPath(AssetType.soldier, imageUrl);

  final String key;
  final String name;
  final String imageUrl;
  final int stars;
  final ElementType elementType;
  String? secondImage;
  final bool isNew;
  final bool isComingSoon;
  final List<int> days;

  bool get onlyShowsInDays => days.isNotEmpty;

  TodayTopPickSoldierModel.fromDays({
    required this.key,
    required this.name,
    required this.imageUrl,
    required this.stars,
    required this.elementType,
    required this.isNew,
    required this.isComingSoon,
  }) : days = [];
}