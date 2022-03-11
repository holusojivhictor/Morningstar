import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:morningstar/domain/models/models.dart';

part 'weapons_file.freezed.dart';
part 'weapons_file.g.dart';

@freezed
class WeaponsFile with _$WeaponsFile {
  List<WeaponFileModel> get weapons => primaries + secondaries;

  factory WeaponsFile({
    required List<WeaponFileModel> primaries,
    required List<WeaponFileModel> secondaries,
  }) = _WeaponsFile;

  WeaponsFile._();

  factory WeaponsFile.fromJson(Map<String, dynamic> json) => _$WeaponsFileFromJson(json);
}