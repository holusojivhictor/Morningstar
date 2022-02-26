import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:morningstar/application/common/pop_bloc.dart';
import 'package:morningstar/domain/models/models.dart';
import 'package:morningstar/domain/services/morningstar_service.dart';
import 'package:morningstar/domain/services/telemetry_service.dart';

part 'vehicle_bloc.freezed.dart';
part 'vehicle_event.dart';
part 'vehicle_state.dart';

class VehicleBloc extends PopBloc<VehicleEvent, VehicleState> {
  final MorningStarService _morningStarService;
  final TelemetryService _telemetryService;

  VehicleBloc(this._morningStarService, this._telemetryService) : super(const VehicleState.loading());

  @override
  VehicleEvent getEventForPop(String? key) => VehicleEvent.loadFromKey(key: key!, addToQueue: false);

  @override
  Stream<VehicleState> mapEventToState(VehicleEvent event) async* {
    final s = await event.when(
      loadFromKey: (key, addToQueue) async {
        final vehicle = _morningStarService.getVehicle(key);

        if (addToQueue) {
          await _telemetryService.trackVehicleLoaded(key);
          currentItemsInStack.add(vehicle.key);
        }
        return _buildInitialState(vehicle);
      },
    );

    yield s;
  }

  VehicleState _buildInitialState(VehicleFileModel vehicle) {
    return VehicleState.loaded(
      key: vehicle.key,
      name: vehicle.name,
      imageUrl: vehicle.imagePath,
      isComingSoon: vehicle.isComingSoon,
      camos: vehicle.camos.map((camo) {
        return VehicleCamoCardModel(
          name: camo.name,
          elementType: camo.elementType,
          imageUrl: camo.imageUrl,
          rarity: camo.rarity,
          isComingSoon: camo.isComingSoon,
        );
      }).toList(),
    );
  }
}