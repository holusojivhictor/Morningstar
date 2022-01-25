import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morningstar/application/bloc.dart';
import 'package:morningstar/presentation/shared/loading.dart';
import 'package:morningstar/presentation/shared/mixins/app_fab_mixin.dart';
import 'package:morningstar/presentation/shared/utils/size_utils.dart';
import 'package:morningstar/presentation/vehicles/widgets/vehicle_card.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class VehiclesPage extends StatefulWidget {
  const VehiclesPage({Key? key}) : super(key: key);

  @override
  _VehiclesPageState createState() => _VehiclesPageState();
}

class _VehiclesPageState extends State<VehiclesPage> with SingleTickerProviderStateMixin, AppFabMixin {
  @override
  bool get isInitiallyVisible => true;

  @override
  bool get hideOnTop => false;

  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Scaffold(
        appBar: AppBar(title: const Text('Vehicles')),
        body: BlocBuilder<VehiclesBloc, VehiclesState>(
          builder: (ctx, state) => state.map(
            loading: (_) => const Loading(useScaffold: false),
            loaded: (state) => WaterfallFlow.builder(
              controller: scrollController,
              itemCount: state.vehicles.length,
              itemBuilder: (context, index) => VehicleCard.item(vehicle: state.vehicles[index]),
              gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                crossAxisCount: SizeUtils.getCrossAxisCountForGrids(context),
                crossAxisSpacing: isPortrait ? 10 : 5,
                mainAxisSpacing: 5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
