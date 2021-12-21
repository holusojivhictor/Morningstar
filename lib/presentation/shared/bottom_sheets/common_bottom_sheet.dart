import 'package:flutter/material.dart';
import 'package:morningstar/presentation/shared/bottom_sheets/bottom_sheet_title.dart';
import 'package:morningstar/presentation/shared/bottom_sheets/common_bottom_sheet_buttons.dart';
import 'package:morningstar/theme.dart';

import 'modal_sheet_separator.dart';

class CommonBottomSheet extends StatelessWidget {
  final String title;
  final IconData titleIcon;
  final Widget child;
  final Function? onOk;
  final Function? onCancel;
  final double iconSize;
  final bool showOkButton;
  final bool showCancelButton;
  const CommonBottomSheet({
    Key? key,
    required this.title,
    required this.titleIcon,
    this.onOk,
    this.onCancel,
    required this.child,
    this.iconSize = 25,
    this.showOkButton = true,
    this.showCancelButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        margin: Styles.modalBottomSheetContainerMargin,
        padding: Styles.modalBottomSheetContainerPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const ModalSheetSeparator(),
            BottomSheetTitle(title: title, icon: titleIcon, iconSize: iconSize),
            child,
            if (showOkButton || showCancelButton)
              CommonBottomSheetButtons(
                showOkButton: showOkButton,
                showCancelButton: showCancelButton,
                onOk: onOk,
                onCancel: onCancel,
              ),
          ],
        ),
      ),
    );
  }
}
