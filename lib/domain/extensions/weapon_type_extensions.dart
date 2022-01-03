import '../assets.dart';
import '../enums/weapon_type.dart';

extension WeaponTypeExtensions on WeaponType {
  String getWeaponAssetPath() {
    switch (this) {
      case WeaponType.primary:
        return Assets.getWeaponPath('weapon_5947.png', this);
      case WeaponType.secondary:
        return Assets.getWeaponPath('weapon_6083.png', this);
      case WeaponType.throwable:
        return Assets.getWeaponPath('weapon_14175.png', this);
      default:
        throw Exception('Invalid weapon type = $this');
    }
  }
}