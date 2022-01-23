import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:morningstar/domain/models/models.dart';

part 'vehicles_file.freezed.dart';
part 'vehicles_file.g.dart';

@freezed
class VehiclesFile with _$VehiclesFile {
  List<VehicleFileModel> get allVehicles => vehicles;

  factory VehiclesFile({
    required List<VehicleFileModel> vehicles,
  }) = _VehiclesFile;

  VehiclesFile._();

  factory VehiclesFile.fromJson(Map<String, dynamic> json) => _$VehiclesFileFromJson(json);
}