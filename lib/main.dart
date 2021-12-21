import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morningstar/application/bloc.dart';
import 'package:morningstar/application/inventory/inventory_bloc.dart';
import 'package:morningstar/application/today_top_picks/today_top_picks_bloc.dart';
import 'package:morningstar/domain/services/data_service.dart';
import 'package:morningstar/domain/services/locale_service.dart';
import 'package:morningstar/domain/services/morningstar_service.dart';
import 'package:morningstar/domain/services/notification_service.dart';
import 'package:morningstar/domain/services/settings_service.dart';
import 'package:morningstar/domain/services/telemetry_service.dart';
import 'package:morningstar/injection.dart';
import 'package:morningstar/presentation/app_widget.dart';
import 'package:morningstar/presentation/shared/utils/size_utils.dart';
import 'package:window_size/window_size.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Injection.init();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowMinSize(SizeUtils.minSizeOnDesktop);
    setWindowMaxSize(Size.infinite);
  }
  final notificationService = getIt<NotificationService>();
  await notificationService.registerCallBacks(
    onSelectNotification: _onSelectNotification,
    onIosReceiveLocalNotification: _onDidReceiveLocalNotification,
  );
  runApp(const MorningStar());
}

Future<dynamic> _onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) async {}

Future<void> _onSelectNotification(String? json) async {}

class MorningStar extends StatelessWidget {
  const MorningStar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (ctx) => MainTabBloc()),
        BlocProvider(
          create: (ctx) {
            final morningStarService = getIt<MorningStarService>();
            final settingsService = getIt<SettingsService>();
            final localeService = getIt<LocaleService>();
            return HomeBloc(morningStarService, settingsService, localeService);
          },
        ),
        BlocProvider(
          create: (ctx) {
            final morningStarService = getIt<MorningStarService>();
            final settingsService = getIt<SettingsService>();
            return SoldiersBloc(morningStarService, settingsService);
          },
        ),
        BlocProvider(
          create: (ctx) {
            final morningStarService = getIt<MorningStarService>();
            final telemetryService = getIt<TelemetryService>();
            final dataService = getIt<DataService>();
            return SoldierBloc(morningStarService, telemetryService, dataService);
          },
        ),
        BlocProvider(
          create: (ctx) {
            final morningStarService = getIt<MorningStarService>();
            final telemetryService = getIt<TelemetryService>();
            return TodayTopPicksBloc(morningStarService, telemetryService);
          },
        ),
        BlocProvider(
          create: (ctx) {
            final morningStarService = getIt<MorningStarService>();
            final settingsService = getIt<SettingsService>();
            final localeService = getIt<LocaleService>();
            final telemetryService = getIt<TelemetryService>();
            return MainBloc(
              morningStarService,
              settingsService,
              localeService,
              telemetryService,
              ctx.read<SoldiersBloc>(),
              ctx.read<HomeBloc>(),
            )..add(const MainEvent.init());
          },
        ),
        BlocProvider(
          create: (ctx) {
            final morningStarService = getIt<MorningStarService>();
            final telemetryService = getIt<TelemetryService>();
            final dataService = getIt<DataService>();
            return InventoryBloc(morningStarService, dataService, telemetryService, ctx.read<SoldierBloc>());
          },
        ),
      ],
      child: BlocBuilder<MainBloc, MainState>(
        builder: (ctx, state) => const AppWidget(),
      ),
    );
  }
}
