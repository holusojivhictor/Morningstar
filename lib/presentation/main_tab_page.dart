import 'dart:io';

import 'package:flutter/material.dart';
import 'package:morningstar/application/bloc.dart';
import 'package:morningstar/presentation/mobile_scaffold.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morningstar/presentation/shared/dialogs/changelog_dialog.dart';
import 'package:morningstar/presentation/shared/utils/toast_utils.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:responsive_builder/responsive_builder.dart';

class MainTabPage extends StatefulWidget {
  final bool showChangelog;

  const MainTabPage({Key? key, required this.showChangelog}) : super(key: key);

  @override
  State<MainTabPage> createState() => _MainTabPageState();
}

class _MainTabPageState extends State<MainTabPage> with SingleTickerProviderStateMixin {
  bool _didChangeDependencies = false;
  late TabController _tabController;
  final _defaultIndex = 0;
  DateTime? backButtonPressTime;

  @override
  void initState() {
    _tabController = TabController(
      initialIndex: _defaultIndex,
      length: 5,
      vsync: this,
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didChangeDependencies) return;
    _didChangeDependencies = true;
    context.read<HomeBloc>().add(const HomeEvent.init());
    context.read<SoldiersBloc>().add(const SoldiersEvent.init());
    context.read<WeaponsBloc>().add(const WeaponsEvent.init());
    context.read<SettingsBloc>().add(const SettingsEvent.init());

    if (widget.showChangelog) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        showDialog(context: context, builder: (ctx) => const ChangelogDialog());
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final child = WillPopScope(
      onWillPop: () => handleWillPop(),
      child: ResponsiveBuilder(
        builder: (ctx, size) => size.isDesktop || size.isTablet
            ? MobileScaffold(defaultIndex: _defaultIndex, tabController: _tabController)
            : MobileScaffold(defaultIndex: _defaultIndex, tabController: _tabController),
      ),
    );

    // TODO: Rate the app on windows
    if (Platform.isWindows) {
      return child;
    }

    return RateMyAppBuilder(
      rateMyApp: RateMyApp(minDays: 7, minLaunches: 10, remindDays: 7, remindLaunches: 10),
      onInitialized: (ctx, rateMyApp) {
        if (!rateMyApp.shouldOpenDialog) {
          return;
        }
        rateMyApp.showRateDialog(
          ctx,
          title: 'Rate this app',
          message: 'If you like this app, please take a little bit of your time to review it!\nIt really helps and it shouldn\'t take you more than one minute.',
          rateButton: 'Rate',
          laterButton: 'Maybe later',
          noButton: 'No thanks',
        );
      },
      builder: (ctx) => child,
    );
  }

  void _goToTab(int newIndex) => context.read<MainTabBloc>().add(MainTabEvent.goToTab(index: newIndex));

  Future<bool> handleWillPop() async {
    if (_tabController.index != _defaultIndex) {
      _goToTab(_defaultIndex);
      return false;
    }
    final settings = context.read<SettingsBloc>();
    if (!settings.doubleBackToClose()) {
      return true;
    }

    final now = DateTime.now();
    final mustWait = backButtonPressTime == null || now.difference(backButtonPressTime!) > ToastUtils.toastDuration;

    if (mustWait) {
      backButtonPressTime = now;
      final fToast = ToastUtils.of(context);
      ToastUtils.showInfoToast(fToast, 'Press once again to exit');
      return false;
    }

    return true;
  }
}
