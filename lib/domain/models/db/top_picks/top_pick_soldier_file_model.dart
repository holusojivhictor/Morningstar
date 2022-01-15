import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:morningstar/domain/enums/enums.dart';

part 'top_pick_soldier_file_model.freezed.dart';
part 'top_pick_soldier_file_model.g.dart';

@freezed
class TopPickSoldierFileModel with _$TopPickSoldierFileModel {
  factory TopPickSoldierFileModel({
    required String key,
    required int rarity,
    required String imageUrl,
    required ElementType elementType,
    String? secondImage,
    required TopPickItemType type,
    required bool isComingSoon,
    required bool isNew,
    required List<int> days,
    required bool hasSiblings,
  }) = _TopPickSoldierFileModel;

  TopPickSoldierFileModel._();

  factory TopPickSoldierFileModel.fromJson(Map<String, dynamic> json) => _$TopPickSoldierFileModelFromJson(json);
}