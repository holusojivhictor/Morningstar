import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morningstar/application/bloc.dart';
import 'package:morningstar/presentation/main_tab_page.dart';
import 'package:morningstar/presentation/splash/splash_page.dart';
import 'package:morningstar/presentation/shared/extensions/app_theme_type_extensions.dart';

import '../theme.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (ctx, state) => state.map<Widget>(
        loading: (_) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: MorningstarTheme.dark(),
            home: const SplashPage(),
          );
        },
        loaded: (s) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: s.appTitle,
            theme: s.theme.getThemeData(s.theme),
            home: MainTabPage(showChangelog: s.versionChanged),
            scrollBehavior: MyCustomScrollBehaviour(),
          );
        },
      ),
    );
  }
}

class MyCustomScrollBehaviour extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.mouse,
    PointerDeviceKind.touch,
  };
}
