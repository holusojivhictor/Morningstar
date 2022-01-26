import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morningstar/application/bloc.dart';
import 'package:morningstar/presentation/comic/widgets/page_strip.dart';
import 'package:morningstar/presentation/shared/loading.dart';
import 'package:morningstar/presentation/shared/sliver_scaffold_with_fab.dart';

class ComicPage extends StatelessWidget {
  const ComicPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ComicBloc, ComicState>(
      builder: (context, state) {
        return state.map(
          loading: (_) => const Loading(),
          loaded: (state) => SliverScaffoldWithFab(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                sliver: PageStrip(
                  pages: state.pages,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
