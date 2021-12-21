import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:bloc/bloc.dart';
import 'package:morningstar/domain/models/home/today_top_pick_soldier_model.dart';
import 'package:morningstar/domain/services/morningstar_service.dart';
import 'package:morningstar/domain/services/telemetry_service.dart';

part 'today_top_picks_bloc.freezed.dart';
part 'today_top_picks_event.dart';
part 'today_top_picks_state.dart';

class TodayTopPicksBloc extends Bloc<TodayTopPicksEvent, TodayTopPicksState> {
  final MorningStarService _morningStarService;
  final TelemetryService _telemetryService;

  static final days = [
    DateTime.monday,
    DateTime.tuesday,
    DateTime.wednesday,
    DateTime.thursday,
    DateTime.friday,
    DateTime.saturday,
    DateTime.sunday,
  ];

  TodayTopPicksBloc(this._morningStarService, this._telemetryService) : super(const TodayTopPicksState.loading());

  @override
  Stream<TodayTopPicksState> mapEventToState(TodayTopPicksEvent event) async* {
    await _telemetryService.trackTopPicksOpened();
    final s = event.when(
      init: () {
        final soldierPicks = <TodayTopPickSoldierModel>[];

        for (final day in days) {
          final soldierPicksForDay = _morningStarService.getTopPickSoldiers(day);

          for (final soldierPick in soldierPicksForDay) {
            if (soldierPicks.any((s) => s.name == soldierPick.name)) {
              continue;
            }
            soldierPicks.add(soldierPick);
          }
        }

        return TodayTopPicksState.loaded(topPicksSoldiers: soldierPicks);
      },
    );

    yield s;
  }
}