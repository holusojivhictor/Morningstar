import 'package:hive/hive.dart';

part 'tier_list_item.g.dart';

@HiveType(typeId: 7)
class TierListItem extends HiveObject {
  @HiveField(0)
  final String text;

  @HiveField(1)
  final int color;

  @HiveField(2)
  final int position;

  @HiveField(3)
  final List<String> weaponKeys;

  TierListItem(this.text, this.color, this.position, this.weaponKeys);
}