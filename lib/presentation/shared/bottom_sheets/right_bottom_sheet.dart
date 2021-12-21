import 'package:flutter/material.dart';
import 'package:morningstar/presentation/shared/bottom_sheets/bottom_sheet_title.dart';

class RightBottomSheet extends StatelessWidget {
  final List<Widget> children;
  final Widget bottom;
  final IconData icon;
  final String? title;
  const RightBottomSheet({
    Key? key,
    required this.children,
    required this.bottom,
    this.icon = Icons.sort,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filterTitle = title ?? 'Filters';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BottomSheetTitle(
                  title: filterTitle,
                  icon: icon,
                ),
                ...children,
              ],
            ),
          ),
        ),
        Divider(color: Theme.of(context).primaryColor),
        bottom,
      ],
    );
  }
}
