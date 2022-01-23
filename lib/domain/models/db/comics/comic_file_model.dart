import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:morningstar/domain/assets.dart';
import 'package:morningstar/domain/enums/enums.dart';

part 'comic_file_model.freezed.dart';
part 'comic_file_model.g.dart';

@freezed
class ComicFileModel with _$ComicFileModel {
  String get imagePath => Assets.getComicPath(cover, season);

  factory ComicFileModel({
    required String name,
    required ComicSeasonType season,
    required String cover,
    required List<ComicPageModel> pages,
  }) = _ComicFileModel;

  ComicFileModel._();

  factory ComicFileModel.fromJson(Map<String, dynamic> json) => _$ComicFileModelFromJson(json);
}

@freezed
class ComicPageModel with _$ComicPageModel {
  String get imagePath => Assets.getComicPath(image, season);

  factory ComicPageModel({
    required int number,
    required String image,
    required ComicSeasonType season,
  }) = _ComicPageModel;

  ComicPageModel._();

  factory ComicPageModel.fromJson(Map<String, dynamic> json) => _$ComicPageModelFromJson(json);
}