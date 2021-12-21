import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morningstar/application/bloc.dart';
import 'package:morningstar/presentation/shared/loading.dart';
import 'package:morningstar/presentation/today_top_picks/sliver_top_picks_soldiers.dart';

class TodayTopPicksPage extends StatelessWidget {
  const TodayTopPicksPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<TodayTopPicksBloc, TodayTopPicksState>(
      builder: (context, state) {
        return state.when(
          loading: () => const Loading(),
          loaded: (soldierPicks) => Scaffold(
            appBar: AppBar(title: const Text('Top Picks')),
            body: SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.only(left: 10, top: 10),
                    sliver: SliverToBoxAdapter(
                      child: Text(
                        'For soldiers',
                        style: theme.textTheme.bodyText1!.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SliverTopPicksSoldiers(topPicksSoldiers: soldierPicks, useListView: false),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
