import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:morningstar/domain/enums/enums.dart';

part 'vehicle_file_model.freezed.dart';
part 'vehicle_file_model.g.dart';

@freezed
class VehicleFileModel with _$VehicleFileModel {
  factory VehicleFileModel({
    required String key,
    required String name,
    required String imageUrl,
    required bool isComingSoon,
    required List<VehicleFileCamoModel> camos,
  }) = _VehicleFileModel;

  VehicleFileModel._();

  factory VehicleFileModel.fromJson(Map<String, dynamic> json) => _$VehicleFileModelFromJson(json);
}

@freezed
class VehicleFileCamoModel with _$VehicleFileCamoModel {
  factory VehicleFileCamoModel({
    required String name,
    required ElementType elementType,
    required String imageUrl,
    required int rarity,
    required bool isComingSoon,
  }) = _VehicleFileCamoModel;

  VehicleFileCamoModel._();

  factory VehicleFileCamoModel.fromJson(Map<String, dynamic> json) => _$VehicleFileCamoModelFromJson(json);
}