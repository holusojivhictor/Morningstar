import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'main_tab_bloc.freezed.dart';
part 'main_tab_event.dart';
part 'main_tab_state.dart';

class MainTabBloc extends Bloc<MainTabEvent, MainTabState> {
  MainTabBloc() : super(const MainTabState.initial(0));

  @override
  Stream<MainTabState> mapEventToState(MainTabEvent event) async* {
    final s = await event.when(
      goToTab: (index) async {
        if (index < 0) {
          return state;
        }
        return state.copyWith(currentSelectedTab: index);
      },
    );

    yield s;
  }
}