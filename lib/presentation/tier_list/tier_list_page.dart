import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:morningstar/injection.dart';
import 'package:morningstar/presentation/shared/utils/toast_utils.dart';
import 'package:morningstar/presentation/tier_list/widgets/tier_list_fab.dart';
import 'package:screenshot/screenshot.dart';
import 'package:morningstar/domain/models/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morningstar/application/bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:morningstar/presentation/shared/extensions/iterable_extensions.dart';

import 'widgets/tier_list_row.dart';

class TierListPage extends StatefulWidget {
  const TierListPage({Key? key}) : super(key: key);

  @override
  _TierListPageState createState() => _TierListPageState();
}

class _TierListPageState extends State<TierListPage> {
  final screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TierListBloc>(
      create: (ctx) => Injection.tierListBloc..add(const TierListEvent.init()),
      child: Scaffold(
        appBar: _AppBar(screenshotController: screenshotController),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: const TierListFab(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: Screenshot(
                controller: screenshotController,
                child: BlocBuilder<TierListBloc, TierListState>(
                  builder: (ctx, state) => Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: state.rows.mapIndex((e, index) => _buildTierRow(index, state.rows.length, state.readyToSave, e)).toList(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTierRow(int index, int totalNumberOfItems, bool readyToSave, TierListRowModel item) {
    return TierListRow(
      index: index,
      title: item.tierText,
      color: Color(item.tierColor),
      items: item.items,
      isUpButtonEnabled: index != 0,
      isDownButtonEnabled: index != totalNumberOfItems - 1,
      numberOfRows: totalNumberOfItems,
      showButtons: !readyToSave,
      isTheLastRow: totalNumberOfItems == 1,
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  final ScreenshotController screenshotController;
  const _AppBar({Key? key, required this.screenshotController}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TierListBloc, TierListState>(
      builder: (ctx, state) => AppBar(
        title: const Text('Tier List Builder'),
        actions: [
          if (!state.readyToSave)
            Tooltip(
              message: 'Confirm',
              child: IconButton(
                icon: const Icon(Icons.check),
                onPressed: () => ctx.read<TierListBloc>().add(const TierListEvent.readyToSave(ready: true)),
              ),
            ),
          if (!state.readyToSave)
            Tooltip(
              message: 'Clear all',
              child: IconButton(
                icon: const Icon(Icons.clear_all),
                onPressed: () => context.read<TierListBloc>().add(const TierListEvent.clearAllRows()),
              ),
            ),
          if (!state.readyToSave)
            Tooltip(
              message: 'Restore',
              child: IconButton(
                icon: const Icon(Icons.settings_backup_restore_sharp),
                onPressed: () => context.read<TierListBloc>().add(const TierListEvent.init(reset: true)),
              ),
            ),
          if (state.readyToSave)
            Tooltip(
              message: 'Save',
              child: IconButton(
                icon: const Icon(Icons.save),
                onPressed: () => _takeScreenshot(context),
              ),
            ),
          if (state.readyToSave)
            Tooltip(
              message: 'Cancel',
              child: IconButton(
                icon: const Icon(Icons.undo),
                onPressed: () => context.read<TierListBloc>().add(const TierListEvent.readyToSave(ready: false)),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _takeScreenshot(BuildContext context) async {
    final fToast = ToastUtils.of(context);
    final bloc = context.read<TierListBloc>();
    try {
      if (!await Permission.storage.request().isGranted) {
        ToastUtils.showInfoToast(fToast, 'You need to accept the requested permission to be able to save');
        return;
      }

      final bytes = await screenshotController.capture(pixelRatio: 1.5);
      await ImageGallerySaver.saveImage(bytes!, quality: 100);
      ToastUtils.showSucceedToast(fToast, 'Image was successfully saved to the gallery');
      bloc.add(const TierListEvent.screenshotTaken(succeed: true));
    } catch (e, trace) {
      ToastUtils.showErrorToast(fToast, 'Unknown error occurred');
      bloc.add(TierListEvent.screenshotTaken(succeed: false, ex: e, trace: trace));
    }
  }
}

