import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:morningstar/domain/assets.dart';
import 'package:morningstar/domain/enums/enums.dart';

part 'weapon_file_model.freezed.dart';
part 'weapon_file_model.g.dart';

@freezed
class WeaponFileModel with _$WeaponFileModel {
  String get fullImagePath => Assets.getWeaponPathAll(imageUrl);

  factory WeaponFileModel({
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
  }) = _WeaponFileModel;

  WeaponFileModel._();

  factory WeaponFileModel.fromJson(Map<String, dynamic> json) => _$WeaponFileModelFromJson(json);
}

@freezed
class WeaponFileBlueprintModel with _$WeaponFileBlueprintModel {
  String get fullImagePath => Assets.getWeaponPathAll(imageUrl);

  factory WeaponFileBlueprintModel({
    required String name,
    required ElementType elementType,
    String? imageUrl,
    required int rarity,
  }) = _WeaponFileBlueprintModel;

  WeaponFileBlueprintModel._();

  factory WeaponFileBlueprintModel.fromJson(Map<String, dynamic> json) => _$WeaponFileBlueprintModelFromJson(json);
}

@freezed
class WeaponFileCamoModel with _$WeaponFileCamoModel {
  String get fullImagePath => Assets.getWeaponPathAll(imageUrl);

  factory WeaponFileCamoModel({
    required String name,
    required ElementType elementType,
    required String source,
    String? imageUrl,
    required int rarity,
  }) = _WeaponFileCamoModel;

  WeaponFileCamoModel._();

  factory WeaponFileCamoModel.fromJson(Map<String, dynamic> json) => _$WeaponFileCamoModelFromJson(json);
}

@freezed
class WeaponFileAttachmentModel with _$WeaponFileAttachmentModel {
  factory WeaponFileAttachmentModel({
    required String name,
    required AttachmentType type,
    required double unlockLevel,
  }) = _WeaponFileAttachmentModel;

  WeaponFileAttachmentModel._();

  factory WeaponFileAttachmentModel.fromJson(Map<String, dynamic> json) => _$WeaponFileAttachmentModelFromJson(json);
}