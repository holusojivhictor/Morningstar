import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morningstar/application/bloc.dart';
import 'package:morningstar/presentation/home/home_page.dart';
import 'package:morningstar/presentation/settings/settings_page.dart';
import 'package:morningstar/presentation/shared/extensions/focus_scope_node_extensions.dart';
import 'package:morningstar/presentation/shared/morningstar_font_icons.dart';
import 'package:morningstar/presentation/soldiers/soldiers_page.dart';
import 'package:morningstar/presentation/weapons/weapons_page.dart';

class MobileScaffold extends StatefulWidget {
  final int defaultIndex;
  final TabController tabController;
  const MobileScaffold({
    Key? key,
    required this.defaultIndex,
    required this.tabController,
  }) : super(key: key);

  @override
  _MobileScaffoldState createState() => _MobileScaffoldState();
}

class _MobileScaffoldState extends State<MobileScaffold> {
  late int _index;

  @override
  void initState() {
    _index = widget.defaultIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<MainTabBloc, MainTabState>(
          listener: (ctx, state) async {
            state.maybeMap(
              initial: (s) => _changeCurrentTab(s.currentSelectedTab),
              orElse: () => {},
            );
          },
          child: TabBarView(
            controller: widget.tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              HomePage(),
              SoldiersPage(),
              WeaponsPage(),
              SettingsPage(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).dividerColor,
        currentIndex: _index,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(label: 'Home',icon: Icon(Icons.home)),
          BottomNavigationBarItem(label: 'Soldiers',icon: Icon(Icons.people)),
          BottomNavigationBarItem(label: 'Weapons',icon: Icon(MorningstarFont.spinning_sword, size: 23)),
          BottomNavigationBarItem(label: 'Settings',icon: Icon(Icons.settings)),
        ],
        type: BottomNavigationBarType.fixed,
        onTap: (index) => _goToTab(index),
      ),
    );
  }

  void _changeCurrentTab(int index) {
    FocusScope.of(context).removeFocus();
    widget.tabController.index = index;
    setState(() {
      _index = index;
    });
  }

  void _goToTab(int newIndex) => context.read<MainTabBloc>().add(MainTabEvent.goToTab(index: newIndex));
}
