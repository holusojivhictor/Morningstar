import 'package:flutter/material.dart';
import 'package:morningstar/domain/assets.dart';
import 'package:morningstar/domain/enums/enums.dart';
import 'package:morningstar/domain/extensions/weapon_type_extensions.dart';

class WeaponsButtonBar extends StatelessWidget {
  final List<WeaponType> selectedValues;
  final Function(WeaponType) onClick;
  final double iconSize;

  const WeaponsButtonBar({
    Key? key,
    required this.onClick,
    this.selectedValues = const [],
    this.iconSize = 32,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttons = WeaponType.values.map((e) => _buildIconButton(e, Assets.translateWeaponType(e))).toList();

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.spaceBetween,
      children: buttons,
    );
  }

  Widget _buildIconButton(WeaponType value, String tooltip) {
    final isSelected = selectedValues.isEmpty || !selectedValues.contains(value);
    return IconButton(
      iconSize: iconSize,
      icon: Opacity(
        opacity: !isSelected ? 1 : 0.2,
        child: Image.asset(value.getWeaponAssetPath()),
      ),
      onPressed: () => onClick(value),
      tooltip: tooltip,
    );
  }
}
