import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morningstar/application/bloc.dart';
import 'package:morningstar/domain/enums/end_drawer_item_type.dart';
import 'package:morningstar/domain/models/models.dart';
import 'package:morningstar/presentation/shared/loading.dart';
import 'package:morningstar/presentation/shared/sliver_nothing_found.dart';
import 'package:morningstar/presentation/shared/sliver_page_filter.dart';
import 'package:morningstar/presentation/shared/sliver_scaffold_with_fab.dart';
import 'package:morningstar/presentation/shared/utils/modal_bottom_sheet_utils.dart';
import 'package:morningstar/presentation/shared/utils/size_utils.dart';
import 'package:morningstar/presentation/soldiers/widgets/soldier_card.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class SoldiersPage extends StatefulWidget {
  final bool isInSelectionMode;
  const SoldiersPage({Key? key, this.isInSelectionMode = false}) : super(key: key);

  static Future<String?> forSelection(BuildContext context, {List<String> excludeKeys = const []}) async {
    final bloc = context.read<SoldiersBloc>();
    bloc.add(SoldiersEvent.init(excludeKeys: excludeKeys));

    final route = MaterialPageRoute<String>(builder: (ctx) => const SoldiersPage(isInSelectionMode: true));
    final keyName = await Navigator.of(context).push(route);
    await route.completed;

    bloc.add(const SoldiersEvent.init());

    return keyName;
  }

  @override
  State<SoldiersPage> createState() => _SoldiersPageState();
}

class _SoldiersPageState extends State<SoldiersPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<SoldiersBloc, SoldiersState>(
      builder: (context, state) => state.map(
        loading: (_) => const Loading(),
        loaded: (state) => SliverScaffoldWithFab(
          appbar: widget.isInSelectionMode ? AppBar(title: const Text('Select a character')) : null,
          slivers: [
            SliverPageFilter(
              search: state.search,
              title: 'Soldiers',
              onPressed: () => ModalBottomSheetUtils.showAppModalBottomSheet(context, EndDrawerItemType.soldiers),
              searchChanged: (v) => context.read<SoldiersBloc>().add(SoldiersEvent.searchChanged(search: v)),
            ),
            if (state.soldiers.isNotEmpty) _buildGrid(state.soldiers, context) else const SliverNothingFound(),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid(List<SoldierCardModel> soldiers, BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      sliver: SliverWaterfallFlow(
        gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
          crossAxisCount: SizeUtils.getCrossAxisCountForGrids(context, isOnMainPage: !widget.isInSelectionMode),
          crossAxisSpacing: isPortrait ? 10 : 5,
          mainAxisSpacing: 5,
        ),
        delegate: SliverChildBuilderDelegate(
              (context, index) => SoldierCard.item(soldierModel: soldiers[index], isInSelectionMode: widget.isInSelectionMode, useSolidBackground: false),
          childCount: soldiers.length,
        ),
      ),
    );
  }
}
