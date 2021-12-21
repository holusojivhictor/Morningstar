import 'package:flutter/material.dart';
import 'package:morningstar/domain/assets.dart';
import 'package:morningstar/domain/enums/enums.dart';

import 'extensions/element_type_extensions.dart';

class ElementsButtonBar extends StatelessWidget {
  final List<ElementType> selectedValues;
  final Function(ElementType) onClick;
  final double iconSize;
  const ElementsButtonBar({
    Key? key,
    required this.onClick,
    this.selectedValues = const [],
    this.iconSize = 24,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttons = ElementType.values.map((e) => _buildIconButton(e, Assets.translateElementType(e))).toList();

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.spaceBetween,
      children: buttons,
    );
  }

  Widget _buildIconButton(ElementType value, String toolTip) {
    final isSelected = selectedValues.isEmpty || !selectedValues.contains(value);
    return IconButton(
      iconSize: iconSize,
      icon: Opacity(
        opacity: !isSelected ? 1 : 0.4,
        child: Image.asset(value.getElementAssetPath()),
      ),
      onPressed: () => onClick(value),
      tooltip: toolTip,
    );
  }
}
