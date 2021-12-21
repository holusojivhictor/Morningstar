import 'package:flutter/material.dart';

import 'common_button_bar.dart';

class CommonBottomSheetButtons extends StatelessWidget {
  final bool showOkButton;
  final bool showCancelButton;
  final Function? onOk;
  final Function? onCancel;

  final String? cancelText;
  final String? okText;
  const CommonBottomSheetButtons({
    Key? key,
    this.showOkButton = true,
    this.showCancelButton = true,
    this.onOk,
    this.onCancel,
    this.cancelText,
    this.okText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final cancel = cancelText ?? 'Cancel';
    final ok = okText ?? 'Ok';

    return CommonButtonBar(
      children: <Widget>[
        if (showCancelButton)
          OutlinedButton(
            onPressed: () => onCancel != null ? onCancel!() : Navigator.pop(context),
            child: Text(cancel, style: TextStyle(color: theme.primaryColor)),
          ),
        if (showOkButton)
          ElevatedButton(
            onPressed: onOk != null ? () => onOk!() : null,
            child: Text(ok),
          ),
      ],
    );
  }
}
