import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:morningstar/domain/models/models.dart';

part 'comics_file.freezed.dart';
part 'comics_file.g.dart';

@freezed
class ComicsFile with _$ComicsFile {
  List<ComicFileModel> get allComics => comics;

  factory ComicsFile({
    required List<ComicFileModel> comics,
  }) = _ComicsFile;

  ComicsFile._();

  factory ComicsFile.fromJson(Map<String, dynamic> json) => _$ComicsFileFromJson(json);
}