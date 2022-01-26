import 'package:morningstar/domain/enums/enums.dart';

import '../../../assets.dart';

class ComicPageCardModel {
  String get imagePath => Assets.getComicPath(image, season);

  final int number;
  final String image;
  final ComicSeasonType season;

  ComicPageCardModel({
    required this.number,
    required this.image,
    required this.season,
  });
}