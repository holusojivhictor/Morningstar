import 'package:flutter/material.dart';
import 'package:morningstar/domain/models/models.dart';
import 'package:morningstar/presentation/shared/utils/size_utils.dart';
import 'package:morningstar/presentation/vehicles/widgets/vehicle_card.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class VehicleDetailCamoBuild extends StatelessWidget {
  final List<VehicleCamoCardModel> camos;
  const VehicleDetailCamoBuild({
    Key? key,
    required this.camos,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return SliverWaterfallFlow(
      delegate: SliverChildBuilderDelegate(
            (context, index) => VehicleCard.camo(camo: camos[index]),
        childCount: camos.length,
      ),
      gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
        crossAxisCount: SizeUtils.getCrossAxisCountForGrids(context),
        crossAxisSpacing: isPortrait ? 10 : 5,
        mainAxisSpacing: 5,
      ),
    );
  }
}
