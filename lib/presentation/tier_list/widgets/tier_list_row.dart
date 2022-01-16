import 'package:flutter/material.dart';
import 'package:morningstar/domain/models/models.dart';
import 'package:morningstar/presentation/shared/images/circle_weapon.dart';
import 'package:morningstar/presentation/shared/utils/size_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:morningstar/application/bloc.dart';

import 'rename_tier_list_dialog.dart';
import 'tier_list_row_color_picker.dart';

enum TierListRowOptionsType {
  addRowAbove,
  addRowBelow,
  rename,
  delete,
  clear,
  changeColor,
}

class TierListRow extends StatelessWidget {
  final int index;
  final String title;
  final Color color;
  final List<ItemCommon> items;
  final bool showButtons;
  final bool isUpButtonEnabled;
  final bool isDownButtonEnabled;
  final int numberOfRows;
  final bool isTheLastRow;

  const TierListRow({
    Key? key,
    required this.index,
    required this.title,
    required this.color,
    required this.items,
    required this.numberOfRows,
    required this.isTheLastRow,
    this.showButtons = true,
    this.isUpButtonEnabled = true,
    this.isDownButtonEnabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DragTarget<ItemCommon>(
      builder: (BuildContext context, List<ItemCommon?> incoming, List<dynamic> rejected) => Column(
        children: [
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  flex: 15,
                  child: Container(
                    constraints: const BoxConstraints(minHeight: 120),
                    color: color,
                    child: Center(
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  flex: showButtons ? 75 : 85,
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.center,
                    children: items
                        .map((e) => CircleWeapon(
                              itemKey: e.key,
                              image: e.image,
                              radius: SizeUtils.getSizeForCircleImages(context),
                              onTap: (img) => context.read<TierListBloc>().add(TierListEvent.deleteWeaponFromRow(index: index, item: e)),
                            )).toList(),
                  ),
                ),
                if (showButtons)
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 10,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.keyboard_arrow_up),
                          onPressed: isUpButtonEnabled
                              ? () => context.read<TierListBloc>().add(TierListEvent.rowPositionChanged(index: index, newIndex: index - 1))
                              : null,
                        ),
                        PopupMenuButton<TierListRowOptionsType>(
                          onSelected: (result) => _onRowOptionSelected(context, result),
                          icon: const Icon(Icons.settings),
                          tooltip: 'Row settings',
                          itemBuilder: (BuildContext context) => <PopupMenuEntry<TierListRowOptionsType>>[
                            PopupMenuItem<TierListRowOptionsType>(
                              value: TierListRowOptionsType.addRowAbove,
                              child: _buildOption(Icons.add, 'Add row above'),
                            ),
                            PopupMenuItem<TierListRowOptionsType>(
                              value: TierListRowOptionsType.addRowBelow,
                              child: _buildOption(Icons.add, 'Add row below'),
                            ),
                            PopupMenuItem<TierListRowOptionsType>(
                              value: TierListRowOptionsType.rename,
                              child: _buildOption(Icons.edit, 'Rename'),
                            ),
                            if (!isTheLastRow)
                              PopupMenuItem<TierListRowOptionsType>(
                                value: TierListRowOptionsType.delete,
                                child: _buildOption(Icons.delete, 'Delete row'),
                              ),
                            if (items.isNotEmpty)
                              PopupMenuItem<TierListRowOptionsType>(
                                value: TierListRowOptionsType.clear,
                                child: _buildOption(Icons.clear_all, 'Clear row'),
                              ),
                            PopupMenuItem<TierListRowOptionsType>(
                              value: TierListRowOptionsType.changeColor,
                              child: _buildOption(Icons.color_lens_outlined, 'Change color'),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.keyboard_arrow_down),
                          onPressed: isDownButtonEnabled
                              ? () => context.read<TierListBloc>().add(TierListEvent.rowPositionChanged(index: index, newIndex: index + 1))
                              : null,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const Divider(color: Colors.grey, height: 3),
        ],
      ),
      onAccept: (item) => context.read<TierListBloc>().add(TierListEvent.addWeaponToRow(index: index, item: item)),
    );
  }

  Widget _buildOption(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon),
        Container(margin: const EdgeInsets.only(left: 10), child: Text(text)),
      ],
    );
  }

  Future<void> _onRowOptionSelected(BuildContext context, TierListRowOptionsType optionType) async {
    switch (optionType) {
      case TierListRowOptionsType.addRowAbove:
        context.read<TierListBloc>().add(TierListEvent.addNewRow(index: index, above: true));
        break;
      case TierListRowOptionsType.addRowBelow:
        context.read<TierListBloc>().add(TierListEvent.addNewRow(index: index, above: false));
        break;
      case TierListRowOptionsType.rename:
        _showRenameDialog(context);
        break;
      case TierListRowOptionsType.delete:
        context.read<TierListBloc>().add(TierListEvent.deleteRow(index: index));
        break;
      case TierListRowOptionsType.clear:
        context.read<TierListBloc>().add(TierListEvent.clearRow(index: index));
        break;
      case TierListRowOptionsType.changeColor:
        await _showColorPicker(context);
        break;
    }
  }

  Future<void> _showRenameDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => BlocProvider.value(
        value: context.read<TierListBloc>(),
        child: RenameTierListDialog(
          title: title,
          index: index,
        ),
      ),
    );
  }

  Future<void> _showColorPicker(BuildContext context) async {
    final bloc = context.read<TierListBloc>();
    final newColor = await showDialog<Color>(
      context: context,
      builder: (_) => TierListRowColorPicker(currentColor: color),
    );

    if (newColor != null && newColor != color) {
      bloc.add(TierListEvent.rowColorChanged(index: index, newColor: newColor.value));
    }
  }
}
