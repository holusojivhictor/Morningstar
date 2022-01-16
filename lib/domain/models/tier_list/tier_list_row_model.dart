import 'package:freezed_annotation/freezed_annotation.dart';

import '../models.dart';

part 'tier_list_row_model.freezed.dart';

@freezed
class TierListRowModel with _$TierListRowModel {
  factory TierListRowModel.row({
    required String tierText,
    required int tierColor,
    required List<ItemCommon> items,
  }) = _Row;
}