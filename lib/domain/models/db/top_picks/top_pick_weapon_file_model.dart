import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:morningstar/domain/enums/enums.dart';
import 'package:morningstar/domain/models/models.dart';

import '../../../assets.dart';

part 'top_pick_weapon_file_model.freezed.dart';
part 'top_pick_weapon_file_model.g.dart';

@freezed
class TopPickWeaponFileModel with _$TopPickWeaponFileModel {
  String get fullImagePath => Assets.getWeaponCloudAll(imageUrl);

  factory TopPickWeaponFileModel({
    required String key,
    String? imageUrl,
    required WeaponType type,
    required WeaponModel model,
    required double damage,
    required double accuracy,
    required double range,
    required double fireRate,
    required double mobility,
    required double control,
    required bool isComingSoon,
    required List<WeaponFileBlueprintModel> blueprints,
    required List<WeaponFileCamoModel> camos,
    required List<WeaponFileAttachmentModel> attachments,
    required List<int> days,
    required bool hasSiblings,
  }) = _TopPickWeaponFileModel;

  TopPickWeaponFileModel._();

  factory TopPickWeaponFileModel.fromJson(Map<String, dynamic> json) => _$TopPickWeaponFileModelFromJson(json);
}