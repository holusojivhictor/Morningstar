import 'package:flutter/material.dart';
import 'package:morningstar/application/bloc.dart';
import 'package:morningstar/domain/models/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morningstar/presentation/shared/images/circle_item.dart';
import 'package:morningstar/presentation/weapon/weapon_page.dart';

class CircleWeapon extends StatelessWidget {
  final String itemKey;
  final String image;
  final double radius;
  final bool forDrag;
  final Function(String)? onTap;

  const CircleWeapon({
    Key? key,
    required this.itemKey,
    required this.image,
    this.radius = 35,
    this.forDrag = false,
    this.onTap,
  }) : super(key: key);

  CircleWeapon.fromItem({
    Key? key,
    required ItemCommon item,
    this.radius = 35,
    this.forDrag = false,
    this.onTap,
  })  : itemKey = item.key,
        image = item.image,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleItem(
      isTierItem: true,
      image: image,
      forDrag: forDrag,
      onTap: (img) => onTap != null ? onTap!(img) : _goToWeaponPage(context),
      radius: radius,
    );
  }

  Future<void> _goToWeaponPage(BuildContext context) async {
    final bloc = context.read<WeaponBloc>();
    bloc.add(WeaponEvent.loadFromKey(key: itemKey));
    final route = MaterialPageRoute(builder: (c) => const WeaponPage());
    await Navigator.push(context, route);
    await route.completed;
    bloc.pop();
  }
}
