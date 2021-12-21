import 'package:flutter/material.dart';
import 'package:morningstar/presentation/inventory/widgets/soldiers_inventory_tab_page.dart';
import 'package:morningstar/presentation/inventory/widgets/weapons_inventory_tab_page.dart';

import 'widgets/clear_all_dialog.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({Key? key}) : super(key: key);

  final tabs = const [
    Tab(icon: Icon(Icons.people, color: Colors.yellowAccent)),
    Tab(icon: Icon(Icons.local_fire_department, color: Colors.yellowAccent)),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Inventory'),
          bottom: TabBar(tabs: tabs, indicatorColor: Theme.of(context).colorScheme.secondary),
          actions: [
            IconButton(
              icon: const Icon(Icons.clear_all),
              onPressed: () => _showClearInventoryDialog(context),
            ),
          ],
        ),
        body: const SafeArea(
          child: TabBarView(
            children: [
              SoldiersInventoryTabPage(),
              WeaponsInventoryTabPage(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showClearInventoryDialog(BuildContext context) async {
    await showDialog(context: context, builder: (_) => const ClearAllDialog());
  }
}
