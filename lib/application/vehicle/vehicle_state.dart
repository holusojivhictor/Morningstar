part of 'vehicle_bloc.dart';

@freezed
class VehicleState with _$VehicleState {
  const factory VehicleState.loading() = _LoadingState;

  const factory VehicleState.loaded({
    required String key,
    required String name,
    required String imageUrl,
    required bool isComingSoon,
    required List<VehicleCamoCardModel> camos,
  }) = _LoadedState;
}