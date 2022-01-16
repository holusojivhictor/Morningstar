import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class TierListRowColorPicker extends StatefulWidget {
  final Color currentColor;

  const TierListRowColorPicker({Key? key, required this.currentColor}) : super(key: key);

  @override
  _TierListRowColorPickerState createState() => _TierListRowColorPickerState();
}

class _TierListRowColorPickerState extends State<TierListRowColorPicker> {
  Color? selectedColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: const Text('Pick a color'),
      content: BlockPicker(
        pickerColor: widget.currentColor,
        onColorChanged: (color) {
          setState(() {
            selectedColor = color;
          });
        },
      ),
      actions: <Widget>[
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(widget.currentColor),
          child: Text(
            'Cancel',
            style: TextStyle(color: theme.primaryColor),
          ),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(selectedColor ?? widget.currentColor),
          child: const Text('Ok'),
        ),
      ],
    );
  }
}
