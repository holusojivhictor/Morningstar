import 'package:flutter/material.dart';
import 'package:morningstar/domain/assets.dart';
import 'package:morningstar/domain/enums/enums.dart';
import 'package:morningstar/presentation/shared/details/detail_general_card.dart';
import 'package:morningstar/presentation/shared/extensions/element_type_extensions.dart';
import 'package:morningstar/presentation/shared/item_description.dart';

class WeaponDetailGeneralCard extends StatelessWidget {
  final String name;
  final WeaponType type;
  final double damage;
  final double accuracy;
  final double range;
  final double fireRate;
  final double mobility;
  final double control;
  final int rarity;
  final ElementType elementType;
  const WeaponDetailGeneralCard({
    Key? key,
    required this.name,
    required this.type,
    required this.damage,
    required this.accuracy,
    required this.range,
    required this.fireRate,
    required this.mobility,
    required this.control,
    required this.rarity,
    required this.elementType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white, fontSize: 14);
    return DetailGeneralCard(
      itemName: name,
      color: elementType.getElementColorFromContext(context),
      rarity: rarity,
      children: [
        ItemDescription(
          title: 'Type',
          widget: Text(
            Assets.translateWeaponType(type),
            style: textTheme,
            overflow: TextOverflow.ellipsis,
          ),
          useColumn: false,
        ),
        ItemDescription(
          title: 'Damage',
          widget: Text(
            '${damage.toInt()}',
            style: textTheme,
            overflow: TextOverflow.ellipsis,
          ),
          useColumn: false,
        ),
        ItemDescription(
          title: 'Accuracy',
          widget: Text(
            '${accuracy.toInt()}',
            style: textTheme,
            overflow: TextOverflow.ellipsis,
          ),
          useColumn: false,
        ),
        ItemDescription(
          title: 'Range',
          widget: Text(
            '${range.toInt()}',
            style: textTheme,
            overflow: TextOverflow.ellipsis,
          ),
          useColumn: false,
        ),
        ItemDescription(
          title: 'Fire rate',
          widget: Text(
            '${fireRate.toInt()}',
            style: textTheme,
            overflow: TextOverflow.ellipsis,
          ),
          useColumn: false,
        ),
        ItemDescription(
          title: 'Mobility',
          widget: Text(
            '${mobility.toInt()}',
            style: textTheme,
            overflow: TextOverflow.ellipsis,
          ),
          useColumn: false,
        ),
        ItemDescription(
          title: 'Control',
          widget: Text(
            '${control.toInt()}',
            style: textTheme,
            overflow: TextOverflow.ellipsis,
          ),
          useColumn: false,
        ),
      ],
    );
  }
}
