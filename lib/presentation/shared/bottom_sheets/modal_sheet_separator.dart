import 'package:flutter/material.dart';

class ModalSheetSeparator extends StatelessWidget {
  const ModalSheetSeparator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Container(
        margin: const EdgeInsets.only(bottom: 5),
        child: SizedBox(
          width: 100,
          height: 6,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: theme.primaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }
}
