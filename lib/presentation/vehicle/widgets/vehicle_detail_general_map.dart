import 'package:flutter/material.dart';
import 'package:morningstar/domain/enums/enums.dart';
import 'package:morningstar/presentation/shared/details/detail_general_card.dart';
import 'package:morningstar/presentation/shared/extensions/element_type_extensions.dart';
import 'package:morningstar/presentation/shared/images/element_image.dart';
import 'package:morningstar/presentation/shared/item_description.dart';

class VehicleDetailGeneralCard extends StatelessWidget {
  final String name;
  final int rarity;
  final ElementType elementType;
  const VehicleDetailGeneralCard({
    Key? key,
    required this.name,
    required this.rarity,
    required this.elementType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DetailGeneralCard(
      itemName: name,
      rarity: rarity,
      color: elementType.getElementColorFromContext(context),
      children: [
        ItemDescription(
          title: 'Element',
          widget: ElementImage.fromType(type: elementType, radius: 12, useDarkForBackgroundColor: true),
          useColumn: false,
        ),
      ],
    );
  }
}
