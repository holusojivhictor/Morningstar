import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morningstar/domain/models/models.dart';
import 'package:morningstar/presentation/shared/images/circle_weapon.dart';
import 'package:morningstar/theme.dart';
import 'package:morningstar/application/bloc.dart';

class TierListFab extends StatelessWidget {
  const TierListFab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TierListBloc, TierListState>(
      builder: (ctx, state) => !state.readyToSave
          ? Container(
              color: Colors.grey.withOpacity(0.8),
              child: SizedBox(
                height: 100,
                child: ListView(
                  padding: EdgeInsets.zero,
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: state.weaponsAvailable.map((e) => _DraggableItem(item: e)).toList(),
                ),
              ),
            )
          : Container(),
    );
  }
}

class _DraggableItem extends StatelessWidget {
  final ItemCommon item;
  const _DraggableItem({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Draggable<ItemCommon>(
      data: item,
      feedback: CircleWeapon.fromItem(item: item, forDrag: true),
      childWhenDragging: CircleAvatar(
        backgroundColor: Colors.black.withOpacity(0.4),
        radius: 40,
      ),
      child: Container(
        margin: Styles.edgeInsetHorizontal16,
        child: CircleWeapon.fromItem(item: item, radius: 40),
      ),
    );
  }
}
