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
import 'package:morningstar/presentation/weapons/widgets/weapon_card.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class WeaponsPage extends StatefulWidget {
  final bool isInSelectionMode;

  static Future<String?> forSelection(BuildContext context, {List<String> excludeKeys = const []}) async {
    final bloc = context.read<WeaponsBloc>();
    bloc.add(WeaponsEvent.init(excludeKeys: excludeKeys));

    final route = MaterialPageRoute<String>(builder: (ctx) => const WeaponsPage(isInSelectionMode: true));
    final keyName = await Navigator.of(context).push(route);
    await route.completed;
    
    bloc.add(const WeaponsEvent.init());

    return keyName;
  }

  const WeaponsPage({Key? key, this.isInSelectionMode = false}) : super(key: key);

  @override
  State<WeaponsPage> createState() => _WeaponsPageState();
}

class _WeaponsPageState extends State<WeaponsPage> with AutomaticKeepAliveClientMixin<WeaponsPage> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<WeaponsBloc, WeaponsState>(
      builder: (context, state) => state.map(
        loading: (_) => const Loading(),
        loaded: (state) => SliverScaffoldWithFab(
          appbar: widget.isInSelectionMode ? AppBar(title: const Text('Select a weapon')) : null,
          slivers: [
            SliverPageFilter(
              search: state.search,
              title: 'Weapons',
              onPressed: () => ModalBottomSheetUtils.showAppModalBottomSheet(context, EndDrawerItemType.weapons),
              searchChanged: (v) => context.read<WeaponsBloc>().add(WeaponsEvent.searchChanged(search: v)),
            ),
            if (state.weapons.isNotEmpty) _buildGrid(context, state.weapons) else const SliverNothingFound(),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid(BuildContext context, List<WeaponCardModel> weapons) {
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
            (context, index) => WeaponCard.item(weapon: weapons[index], isInSelectionMode: widget.isInSelectionMode),
          childCount: weapons.length,
        ),
      ),
    );
  }
}
