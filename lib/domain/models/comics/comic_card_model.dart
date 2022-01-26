import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:morningstar/domain/enums/enums.dart';

import '../../assets.dart';

part 'comic_card_model.freezed.dart';

@freezed
class ComicCardModel with _$ComicCardModel {
  String get image => Assets.getComicPath(cover, season);

  factory ComicCardModel({
    required String name,
    required ComicSeasonType season,
    required String cover,
  }) = _ComicCardModel;

  ComicCardModel._();
}