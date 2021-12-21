import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morningstar/application/bloc.dart';
import 'package:morningstar/application/inventory/inventory_bloc.dart';
import 'package:morningstar/presentation/shared/details/detail_top_layout.dart';
import 'package:morningstar/presentation/shared/extensions/element_type_extensions.dart';
import 'package:morningstar/presentation/shared/loading.dart';
import 'package:morningstar/theme.dart';

import 'soldier_detail_general_card.dart';

class SoldierDetailTop extends StatelessWidget {
  const SoldierDetailTop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SoldierBloc, SoldierState>(
      builder: (ctx, state) => state.map(
        loading: (_) => const Loading(useScaffold: false),
        loaded: (state) => DetailTopLayout(
          color: state.elementType.getElementColorFromContext(context),
          borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
          image: state.imageUrl,
          name: state.name,
          secondImage: state.secondImage,
          soldierDescriptionHeight: 180,
          generalCard: SoldierDetailGeneralCard(
            elementType: state.elementType,
            name: state.name,
            rarity: state.rarity,
          ),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            actions: [
              BlocBuilder<SoldierBloc, SoldierState>(
                builder: (ctx, state) => state.map(
                  loading: (_) => const Loading(useScaffold: false),
                  loaded: (state) => IconButton(
                    icon: Icon(state.isInInventory ? Icons.favorite : Icons.favorite_border),
                    color: const Color(0xFFFFE600),
                    splashRadius: Styles.mediumButtonSplashRadius,
                    onPressed: () => _favoriteSoldier(state.key, state.isInInventory, context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _favoriteSoldier(String key, bool isInInventory, BuildContext context) {
    final event = !isInInventory ? InventoryEvent.addSoldier(key: key) : InventoryEvent.deleteSoldier(key: key);
    context.read<InventoryBloc>().add(event);
  }
}
