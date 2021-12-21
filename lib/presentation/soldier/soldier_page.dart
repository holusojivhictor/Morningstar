import 'package:flutter/material.dart';
import 'package:morningstar/presentation/shared/scaffold_with_fab.dart';
import 'package:morningstar/presentation/soldier/widgets/soldier_detail.dart';
import 'package:morningstar/presentation/soldier/widgets/soldier_detail_top.dart';

class SoldierPage extends StatelessWidget {
  const SoldierPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return isPortrait ? const _PortraitLayout() : const _LandscapeLayout();
  }
}

class _PortraitLayout extends StatelessWidget {
  const _PortraitLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithFab(
      child: Stack(
        fit: StackFit.passthrough,
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: const [
          SoldierDetailTop(),
          SoldierDetailBottom(),
        ],
      ),
    );
  }
}

class _LandscapeLayout extends StatelessWidget {
  const _LandscapeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: const [
            Expanded(child: SoldierDetailTop()),
            Expanded(child: SoldierDetailBottom()),
          ],
        ),
      ),
    );
  }
}

