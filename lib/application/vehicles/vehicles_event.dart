part of 'vehicles_bloc.dart';

@freezed
class VehiclesEvent with _$VehiclesEvent {
  const factory VehiclesEvent.init({
    @Default(<String>[]) List<String> excludeKeys,
  }) = _Init;

  const factory VehiclesEvent.searchChanged({
    required String search,
  }) = _SearchChanged;
}