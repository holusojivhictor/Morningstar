import 'package:freezed_annotation/freezed_annotation.dart';

part 'item_common.freezed.dart';

abstract class ItemCommonBase {
  String get key;

  String get image;
}

@freezed
class ItemCommon with _$ItemCommon {
  @Implements<ItemCommonBase>()
  const factory ItemCommon(String key, String image) = _ItemCommon;
}