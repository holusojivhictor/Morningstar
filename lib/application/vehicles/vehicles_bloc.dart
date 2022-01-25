import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bloc/bloc.dart';
import 'package:morningstar/domain/models/models.dart';
import 'package:morningstar/domain/services/morningstar_service.dart';

part 'vehicles_bloc.freezed.dart';
part 'vehicles_event.dart';
part 'vehicles_state.dart';

class VehiclesBloc extends Bloc<VehiclesEvent, VehiclesState> {
  final MorningStarService _morningStarService;

  VehiclesBloc(this._morningStarService) : super(const VehiclesState.loading());

  _LoadedState get currentState => state as _LoadedState;

  @override
  Stream<VehiclesState> mapEventToState(VehiclesEvent event) async* {
    final s = event.map(
      init: (e) => _buildInitialState(excludeKeys: e.excludeKeys),
      searchChanged: (e) => _buildInitialState(
        search: e.search,
        excludeKeys: currentState.excludeKeys,
      ),
    );

    yield s;
  }

  VehiclesState _buildInitialState({
    String? search,
    List<String> excludeKeys = const [],
  }) {
    final isLoaded = state is _LoadedState;
    var data = _morningStarService.getVehiclesForCard();
    if (excludeKeys.isNotEmpty) {
      data = data.where((el) => !excludeKeys.contains(el.key)).toList();
    }

    if (!isLoaded) {
      return VehiclesState.loaded(
        search: search,
        vehicles: data,
        excludeKeys: excludeKeys,
      );
    }

    if (search != null && search.isNotEmpty) {
      data = data.where((el) => el.name.toLowerCase().contains(search.toLowerCase())).toList();
    }

    final s = currentState.copyWith.call(
      vehicles: data,
      search: search,
      excludeKeys: excludeKeys,
    );
    return s;
  }
}
