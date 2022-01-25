part of 'vehicles_bloc.dart';

@freezed
class VehiclesState with _$VehiclesState {
  const factory VehiclesState.loading() = _LoadingState;

  const factory VehiclesState.loaded({
    required List<VehicleCardModel> vehicles,
    String? search,
    @Default(<String>[]) List<String> excludeKeys,
  }) = _LoadedState;
}