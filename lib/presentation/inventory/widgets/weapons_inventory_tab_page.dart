import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morningstar/application/bloc.dart';
import 'package:morningstar/presentation/shared/app_fab.dart';
import 'package:morningstar/presentation/shared/loading.dart';
import 'package:morningstar/presentation/shared/mixins/app_fab_mixin.dart';
import 'package:morningstar/presentation/shared/utils/size_utils.dart';
import 'package:morningstar/presentation/weapons/weapons_page.dart';
import 'package:morningstar/presentation/weapons/widgets/weapon_card.dart';
import 'package:waterfall_flow/waterfall_flow.dart';
import 'package:morningstar/domain/extensions/string_extensions.dart';

class WeaponsInventoryTabPage extends StatefulWidget {
  const WeaponsInventoryTabPage({Key? key}) : super(key: key);

  @override
  _WeaponsInventoryTabPageState createState() => _WeaponsInventoryTabPageState();
}

class _WeaponsInventoryTabPageState extends State<WeaponsInventoryTabPage> with SingleTickerProviderStateMixin, AppFabMixin {
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
          onPressed: () => _openWeaponsPage(context),
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
              itemCount: state.weapons.length,
              itemBuilder: (context, index) => WeaponCard.item(weapon: state.weapons[index]),
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

  Future<void> _openWeaponsPage(BuildContext context) async {
    final inventoryBloc = context.read<InventoryBloc>();
    final weaponsBloc = context.read<WeaponsBloc>();
    weaponsBloc.add(WeaponsEvent.init(excludeKeys: inventoryBloc.getItemKeysToExclude()));
    final route = MaterialPageRoute<String>(builder: (_) => const WeaponsPage(isInSelectionMode: true));
    final keyName = await Navigator.push(context, route);

    weaponsBloc.add(const WeaponsEvent.init());
    if (keyName.isNullEmptyOrWhitespace) {
      return;
    }

    inventoryBloc.add(InventoryEvent.addWeapon(key: keyName!));
  }
}
