import 'package:flutter/material.dart';
import 'package:morningstar/presentation/shared/common_dropdown_button.dart';
import 'package:morningstar/presentation/shared/utils/enum_utils.dart';

class DropdownButtonWithTitle<T> extends StatelessWidget {
  final String title;
  final T currentValue;
  final bool isExpanded;
  final List<TranslatedEnum<T>> items;
  final void Function(T)? onChanged;
  final EdgeInsets margin;

  const DropdownButtonWithTitle({
    Key? key,
    required this.title,
    required this.currentValue,
    required this.items,
    this.onChanged,
    this.isExpanded = true,
    this.margin = const EdgeInsets.only(bottom: 15, top: 10),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: margin,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            transform: Matrix4.translationValues(0.0, 5.0, 0.0),
            child: Text(title, style: theme.textTheme.bodyText2),
          ),
          CommonDropdownButton<T>(
            hint: title,
            currentValue: currentValue,
            isExpanded: isExpanded,
            withoutUnderline: false,
            values: items,
            onChanged: onChanged != null ? (v, _) => onChanged!(v!) : null,
          ),
        ],
      ),
    );
  }
}
