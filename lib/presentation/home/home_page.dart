import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morningstar/application/bloc.dart';
import 'package:morningstar/domain/enums/enums.dart';
import 'package:morningstar/presentation/home/widgets/comics_page_card.dart';
import 'package:morningstar/presentation/home/widgets/my_inventory_card.dart';
import 'package:morningstar/presentation/home/widgets/notifications_card.dart';
import 'package:morningstar/presentation/home/widgets/sliver_main_title.dart';
import 'package:morningstar/presentation/home/widgets/sliver_today_main_title.dart';
import 'package:morningstar/presentation/home/widgets/sliver_today_top_picks_soldiers.dart';
import 'package:morningstar/presentation/home/widgets/sliver_today_top_picks_weapons.dart';
import 'package:morningstar/presentation/home/widgets/tier_list_card.dart';
import 'package:morningstar/presentation/home/widgets/vehicles_page_card.dart';
import 'package:morningstar/presentation/shared/loading.dart';
import 'package:morningstar/presentation/today_top_picks/today_top_picks_page.dart';
import 'package:morningstar/theme.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'widgets/gif_image_box.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin<HomePage> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return ResponsiveBuilder(
      builder: (ctx, size) => CustomScrollView(
        slivers: [
          const SliverTodayMainTitle(),
          if (isPortrait)
            BlocBuilder<SettingsBloc, SettingsState>(
              builder: (ct, state) => state.map(
                loading: (_) => const SliverToBoxAdapter(child: Loading(useScaffold: false)),
                loaded: (settingsState) {
                  if (settingsState.currentTheme == AppThemeType.grey) {
                    return const SliverToBoxAdapter(child: SizedBox());
                  }
                  return const GifImage();
                },
              ),
            ),
          _buildClickableTitle('Soldiers Top Picks', 'See all', context, onClick: () => _goToTopPicksPage(context)),
          const SliverTodayTopPicksSoldiers(),
          _buildClickableTitle('Weapons Top Picks', 'See all', context, onClick: () => _goToTopPicksPage(context)),
          const SliverTodayTopPicksWeapons(),
          const SliverMainTitle(title: 'Tools'),
          SliverToBoxAdapter(
            child: SizedBox(
              height: Styles.homeCardHeight,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: 2,
                itemBuilder: (context, index) => _buildToolsSectionMenu(index),
              ),
            ),
          ),
          const SliverMainTitle(title: 'More'),
          SliverToBoxAdapter(
            child: SizedBox(
              height: Styles.homeCardHeight,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: 2,
                itemBuilder: (context, index) => _buildMoreSectionMenu(index),
              ),
            ),
          ),
          const SliverMainTitle(title: 'Exciting'),
          SliverToBoxAdapter(
            child: SizedBox(
              height: Styles.homeCardHeight,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: 1,
                itemBuilder: (context, index) => _buildExcitingSectionMenu(index),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolsSectionMenu(int index) {
    switch (index) {
      case 0:
        return const MyInventoryCard(iconToTheLeft: true);
      case 1:
        return const NotificationsCard(iconToTheLeft: true);
      default:
        throw Exception('Invalid tool section');
    }
  }

  Widget _buildMoreSectionMenu(int index) {
    switch (index) {
      case 0:
        return const TierListCard(iconToTheLeft: true);
      case 1:
        return const VehiclePageCard(iconToTheLeft: true);
      default:
        throw Exception('Invalid tool section');
    }
  }

  Widget _buildExcitingSectionMenu(int index) {
    switch (index) {
      case 0:
        return const ComicsPageCard(iconToTheLeft: true);
      default:
        throw Exception('Invalid tool section');
    }
  }

  Widget _buildClickableTitle(String title, String? buttonText, BuildContext context, {Function? onClick}) {
    final theme = Theme.of(context);
    final row = buttonText != null
        ? Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [const Icon(Icons.chevron_right), Text(buttonText),],
          )
        : null;
    return SliverPadding(
      padding: const EdgeInsets.only(top: 5),
      sliver: SliverToBoxAdapter(
        child: ListTile(
          dense: true,
          onTap: () => onClick?.call(),
          visualDensity: const VisualDensity(vertical: -4, horizontal: -2),
          trailing: row,
          title: Text(
            title,
            textAlign: TextAlign.start,
            style: theme.textTheme.headline2!.copyWith(fontWeight: FontWeight.bold, letterSpacing: 0.15),
          ),
        ),
      ),
    );
  }

  Future<void> _goToTopPicksPage(BuildContext context) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => const TodayTopPicksPage()));
  }
}
