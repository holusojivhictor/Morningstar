import 'package:flutter/material.dart';
import 'package:morningstar/domain/models/models.dart';
import 'package:morningstar/presentation/shared/utils/size_utils.dart';
import 'package:morningstar/presentation/weapons/widgets/weapon_card.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class Blueprints extends StatefulWidget {
  final List<WeaponBlueprintCardModel> blueprints;
  const Blueprints({
    Key? key,
    required this.blueprints,
  }) : super(key: key);

  @override
  State<Blueprints> createState() => _BlueprintsState();
}

class _BlueprintsState extends State<Blueprints> {
  late ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return WaterfallFlow.builder(
      shrinkWrap: true,
      controller: scrollController,
      itemBuilder: (context, index) => WeaponCard.blueprints(blueprint: widget.blueprints[index]),
      itemCount: widget.blueprints.length,
      gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
        crossAxisCount: SizeUtils.getCrossAxisCountForGrids(context),
        crossAxisSpacing: isPortrait ? 10 : 5,
        mainAxisSpacing: 5,
      ),
    );
  }
}
