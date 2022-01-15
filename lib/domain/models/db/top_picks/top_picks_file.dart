import 'package:freezed_annotation/freezed_annotation.dart';

import '../../models.dart';

part 'top_picks_file.freezed.dart';
part 'top_picks_file.g.dart';

@freezed
class TopPicksFile with _$TopPicksFile {
  List<TopPickSoldierFileModel> get soldiers => topPicksSoldiers;
  List<TopPickWeaponFileModel> get weapons => topPicksWeapons;

  factory TopPicksFile({
    required List<TopPickSoldierFileModel> topPicksSoldiers,
    required List<TopPickWeaponFileModel> topPicksWeapons,
  }) = _TopPicksFile;

  TopPicksFile._();

  factory TopPicksFile.fromJson(Map<String, dynamic> json) => _$TopPicksFileFromJson(json);
}