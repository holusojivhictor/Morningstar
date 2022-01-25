import 'package:freezed_annotation/freezed_annotation.dart';

part 'vehicle_card_model.freezed.dart';

@freezed
class VehicleCardModel with _$VehicleCardModel {
  const factory VehicleCardModel({
    required String key,
    required String name,
    required String imageUrl,
    required bool isComingSoon,
  }) = _VehicleCardModel;
}