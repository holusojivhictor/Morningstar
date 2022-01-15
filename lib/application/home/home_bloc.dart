import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:morningstar/domain/models/models.dart';
import 'package:morningstar/domain/services/locale_service.dart';
import 'package:morningstar/domain/services/morningstar_service.dart';
import 'package:morningstar/domain/services/settings_service.dart';

part 'home_bloc.freezed.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final MorningStarService _morningStarService;
  final SettingsService _settingsService;
  final LocaleService _localeService;

  HomeBloc(this._morningStarService, this._settingsService, this._localeService) : super(const HomeState.loading());

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    final s = event.when(
      init: () {
        final date = _morningStarService.getServerDate(_settingsService.serverResetTime);
        final day = date.weekday;
        return _buildInitialState(day);
      },
      dayChanged: (newDay) => _buildInitialState(newDay),
    );

    yield s;
  }

  HomeState _buildInitialState(int day) {
    final soldierTopPicks = _morningStarService.getTopPickSoldiers(day);
    final weaponTopPicks = _morningStarService.getTopPickWeapons(day);
    final dayName = _localeService.getDayNameFromDay(day);

    return HomeState.loaded(
      soldierTopPicks: soldierTopPicks,
      weaponTopPicks: weaponTopPicks,
      day: day,
      dayName: dayName,
    );
  }
}
