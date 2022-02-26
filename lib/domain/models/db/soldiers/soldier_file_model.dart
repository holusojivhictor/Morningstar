import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:morningstar/domain/assets.dart';
import 'package:morningstar/domain/enums/enums.dart';

part 'soldier_file_model.freezed.dart';
part 'soldier_file_model.g.dart';

@freezed
class SoldierFileModel with _$SoldierFileModel {
  String get fullImagePath => Assets.getSoldierPath(imageUrl);

  String get imagePath => Assets.getImageCloudPath(AssetType.soldier, imageUrl);

  bool get canBeUsedForNotif {
    final value = elementType == ElementType.epic;
    return value;
  }

  factory SoldierFileModel({
    required String key,
    required int rarity,
    required ElementType elementType,
    required String imageUrl,
    String? secondImage,
    required bool isComingSoon,
    required bool isNew,
  }) = _SoldierFileModel;

  SoldierFileModel._();

  factory SoldierFileModel.fromJson(Map<String, dynamic> json) => _$SoldierFileModelFromJson(json);
}