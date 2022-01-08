import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morningstar/application/bloc.dart';
import 'package:morningstar/domain/app_constants.dart';
import 'package:morningstar/presentation/shared/details/detail_top_layout.dart';
import 'package:morningstar/presentation/shared/extensions/rarity_extensions.dart';
import 'package:morningstar/presentation/shared/loading.dart';
import 'package:morningstar/theme.dart';

class WeaponDetailTop extends StatelessWidget {
  final String name;
  final String image;

  const WeaponDetailTop({
    Key? key,
    required this.name,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const rarity = 4;
    final mediaQuery = MediaQuery.of(context);
    final isPortrait = mediaQuery.orientation == Orientation.portrait;
    return DetailTopLayout(
      image: image,
      secondImage: image,
      name: name,
      webUrl: weaponsImageUrl,
      gradient: rarity.getRarityGradient(),
      borderRadius: const BorderRadius.only(
        bottomRight: Radius.circular(20),
        bottomLeft: Radius.circular(20),
      ),
      showShadowImage: false,
      isASmallImage: isPortrait,
      generalCard: Container(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          BlocBuilder<WeaponBloc, WeaponState>(
            builder: (ctx, state) => state.map(
              loading: (_) => const Loading(useScaffold: false),
              loaded: (state) => IconButton(
                icon: Icon(state.isInInventory ? Icons.favorite : Icons.favorite_border),
                color: const Color(0xFFFFE600),
                splashRadius: Styles.mediumButtonSplashRadius,
                onPressed: () => _favoriteWeapon(state.key, state.isInInventory, context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _favoriteWeapon(String key, bool isInInventory, BuildContext context) {
    final event = !isInInventory ? InventoryEvent.addWeapon(key: key) : InventoryEvent.deleteWeapon(key: key);
    context.read<InventoryBloc>().add(event);
  }
}
