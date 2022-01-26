import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morningstar/application/bloc.dart';
import 'package:morningstar/presentation/shared/loading.dart';
import 'package:morningstar/presentation/shared/mixins/app_fab_mixin.dart';
import 'package:morningstar/presentation/shared/utils/size_utils.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

import 'widgets/comic_card.dart';

class ComicsPage extends StatefulWidget {
  const ComicsPage({Key? key}) : super(key: key);

  @override
  _ComicsPageState createState() => _ComicsPageState();
}

class _ComicsPageState extends State<ComicsPage> with SingleTickerProviderStateMixin, AppFabMixin {
  @override
  bool get isInitiallyVisible => true;

  @override
  bool get hideOnTop => false;

  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Scaffold(
        appBar: AppBar(title: const Text('Comics')),
        body: BlocBuilder<ComicsBloc, ComicsState>(
          builder: (ctx, state) => state.map(
            loading: (_) => const Loading(useScaffold: false),
            loaded: (state) => WaterfallFlow.builder(
              controller: scrollController,
              itemCount: state.comics.length,
              itemBuilder: (context, index) => ComicCard.item(comic: state.comics[index]),
              gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                crossAxisCount: SizeUtils.getCrossAxisCountForGrids(context, isOnMainPage: true),
                crossAxisSpacing: isPortrait ? 10 : 5,
                mainAxisSpacing: 5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
