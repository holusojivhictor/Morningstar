import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:morningstar/domain/enums/enums.dart';

part 'top_pick_file_model.freezed.dart';
part 'top_pick_file_model.g.dart';

@freezed
class TopPickFileModel with _$TopPickFileModel {
  factory TopPickFileModel({
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
  }) = _TopPickFileModel;

  TopPickFileModel._();

  factory TopPickFileModel.fromJson(Map<String, dynamic> json) => _$TopPickFileModelFromJson(json);
}