import 'package:flutter/material.dart';
import 'package:morningstar/application/bloc.dart';
import 'package:morningstar/presentation/mobile_scaffold.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainTabPage extends StatefulWidget {
  const MainTabPage({Key? key}) : super(key: key);

  @override
  State<MainTabPage> createState() => _MainTabPageState();
}

class _MainTabPageState extends State<MainTabPage> with SingleTickerProviderStateMixin {
  bool _didChangeDependencies = false;
  late TabController _tabController;
  final _defaultIndex = 0;

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
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final child = MobileScaffold(defaultIndex: _defaultIndex, tabController: _tabController,);
    return child;
  }
}
