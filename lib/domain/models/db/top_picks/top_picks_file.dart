import 'package:freezed_annotation/freezed_annotation.dart';

import 'top_pick_file_model.dart';

part 'top_picks_file.freezed.dart';
part 'top_picks_file.g.dart';

@freezed
class TopPicksFile with _$TopPicksFile {
  List<TopPickFileModel> get topPicks => topPicksSoldiers;

  factory TopPicksFile({
    required List<TopPickFileModel> topPicksSoldiers,
  }) = _TopPicksFile;

  TopPicksFile._();

  factory TopPicksFile.fromJson(Map<String, dynamic> json) => _$TopPicksFileFromJson(json);
}