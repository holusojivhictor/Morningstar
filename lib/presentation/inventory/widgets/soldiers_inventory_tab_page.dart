import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morningstar/application/bloc.dart';
import 'package:morningstar/presentation/shared/app_fab.dart';
import 'package:morningstar/presentation/shared/loading.dart';
import 'package:morningstar/presentation/shared/mixins/app_fab_mixin.dart';
import 'package:morningstar/presentation/shared/utils/size_utils.dart';
import 'package:morningstar/presentation/soldiers/soldiers_page.dart';
import 'package:morningstar/presentation/soldiers/widgets/soldier_card.dart';
import 'package:waterfall_flow/waterfall_flow.dart';
import 'package:morningstar/domain/extensions/string_extensions.dart';

class SoldiersInventoryTabPage extends StatefulWidget {
  const SoldiersInventoryTabPage({Key? key}) : super(key: key);

  @override
  _SoldiersInventoryTabPageState createState() => _SoldiersInventoryTabPageState();
}

class _SoldiersInventoryTabPageState extends State<SoldiersInventoryTabPage> with SingleTickerProviderStateMixin, AppFabMixin {
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
        floatingActionButton: AppFab(
          onPressed: () => _openSoldiersPage(context),
          icon: const Icon(Icons.add),
          hideFabAnimController: hideFabAnimController,
          scrollController: scrollController,
          mini: false,
        ),
        body: BlocBuilder<InventoryBloc, InventoryState>(
          builder: (ctx, state) => state.map(
            loading: (_) => const Loading(useScaffold: false),
            loaded: (state) => WaterfallFlow.builder(
              controller: scrollController,
              itemBuilder: (context, index) => SoldierCard.item(soldierModel: state.soldiers[index]),
              itemCount: state.soldiers.length,
              gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                crossAxisCount: SizeUtils.getCrossAxisCountForGrids(context),
                crossAxisSpacing: isPortrait ? 10 : 5,
                mainAxisSpacing: 5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openSoldiersPage(BuildContext context) async {
    final inventoryBloc = context.read<InventoryBloc>();
    final soldiersBloc = context.read<SoldiersBloc>();
    soldiersBloc.add(SoldiersEvent.init(excludeKeys: inventoryBloc.getItemKeysToExclude()));
    final route = MaterialPageRoute<String>(builder: (_) => const SoldiersPage(isInSelectionMode: true));
    final keyName = await Navigator.push(context, route);
    
    soldiersBloc.add(const SoldiersEvent.init());
    if (keyName.isNullEmptyOrWhitespace) {
      return;
    }
    
    inventoryBloc.add(InventoryEvent.addSoldier(key: keyName!));
  }
}
