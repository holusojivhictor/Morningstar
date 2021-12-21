import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morningstar/application/bloc.dart';
import 'package:morningstar/presentation/shared/sliver_loading.dart';
import 'package:morningstar/presentation/today_top_picks/sliver_top_picks_soldiers.dart';

class SliverTodayTopPicksSoldiers extends StatelessWidget {
  const SliverTodayTopPicksSoldiers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return state.map(
          loading: (_) => const SliverLoading(),
          loaded: (state) => SliverTopPicksSoldiers(topPicksSoldiers: state.soldierTopPicks),
        );
      },
    );
  }
}
