part of 'vehicle_bloc.dart';

@freezed
class VehicleEvent with _$VehicleEvent {
  const factory VehicleEvent.loadFromKey({
    required String key,
    @Default(true) bool addToQueue,
  }) = _LoadVehicleFromName;
}