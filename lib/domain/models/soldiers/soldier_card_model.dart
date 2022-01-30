import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:morningstar/domain/enums/enums.dart';

part 'soldier_card_model.freezed.dart';

@freezed
class SoldierCardModel with _$SoldierCardModel {
  String get smallImagePath => imageUrl;

  factory SoldierCardModel({
    required String key,
    required String name,
    required String imageUrl,
    required int stars,
    required ElementType elementType,
    @Default(false) bool isNew,
    @Default(false) bool isComingSoon,
  }) = _SoldierCardModel;

  SoldierCardModel._();
}