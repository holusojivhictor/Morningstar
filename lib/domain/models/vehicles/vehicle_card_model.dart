import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:morningstar/domain/assets.dart';
import 'package:morningstar/domain/enums/enums.dart';

part 'vehicle_card_model.freezed.dart';

@freezed
class VehicleCardModel with _$VehicleCardModel {
  String get imagePath => Assets.getImageCloudPath(AssetType.vehicle, imageUrl);

  factory VehicleCardModel({
    required String key,
    required String name,
    required String imageUrl,
    required bool isComingSoon,
  }) = _VehicleCardModel;

  VehicleCardModel._();
}