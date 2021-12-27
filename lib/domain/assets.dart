import 'package:morningstar/domain/enums/enums.dart';
import 'extensions/string_extensions.dart';

class Assets {
  static String dbPath = 'assets/db';
  static String soldiersDbPath = '$dbPath/soldiers.json';
  static String weaponsDbPath = '$dbPath/weapons.json';
  static String topPicksDbPath = '$dbPath/top_picks.json';
  static String translationsBasePath = 'assets/i18n';
  static String elementsBasePath = 'assets/elements';

  // General
  static String soldiersBasePath = 'assets/cosmetics';
  static String noImageAvailableName = 'na.png';

  // Weapons
  static String weaponsBasePath = 'assets/weapons';
  static String primaryBasePath = '$weaponsBasePath/primary';
  static String secondaryBasePath = '$weaponsBasePath/secondary';
  static String throwableBasePath = '$weaponsBasePath/throwable';

  // Items
  static String itemsBasePath = 'assets/items';
  static String logosBasePath = '$itemsBasePath/logos';
  static String othersBasePath = '$itemsBasePath/others';

  // Others
  static String noImageAvailablePath = '$othersBasePath/$noImageAvailableName';

  // Videos
  static String videosBasePath = 'assets/videos';

  static String getVideoPath(String name) => '$videosBasePath/$name';

  static String getCODMLogoPath(String name) => '$logosBasePath/$name';

  static String getSoldierPath(String name) => '$soldiersBasePath/$name';

  static String getPrimaryPath(String name) => '$primaryBasePath/$name';

  static String getSecondaryPath(String name) => '$secondaryBasePath/$name';

  static String getThrowable(String name) => '$throwableBasePath/$name';

  static String getWeaponPath(String name, WeaponType type) {
    switch (type) {
      case WeaponType.primary:
        return getPrimaryPath(name);
      case WeaponType.secondary:
        return getSecondaryPath(name);
      case WeaponType.throwable:
        return getThrowable(name);
      default:
        throw Exception('Invalid weapon type = $type');
    }
  }

  static String getWeaponPathAll(String? name) {
    if (name.isNullEmptyOrWhitespace) {
      return '$othersBasePath/$noImageAvailableName';
    }
    return '$weaponsBasePath/$name';
  }

  static String getTranslationPath(AppLanguageType languageType) {
    switch (languageType) {
      case AppLanguageType.english:
        return '$translationsBasePath/en.json';
      default:
        throw Exception('Invalid language = $languageType');
    }
  }

  static String getElementPath(String name) => '$elementsBasePath/$name';

  static String getElementPathFromType(ElementType type) {
    switch(type) {
      case ElementType.common:
        return getElementPath('common.png');
      case ElementType.uncommon:
        return getElementPath('uncommon.png');
      case ElementType.rare:
        return getElementPath('rare.png');
      case ElementType.epic:
        return getElementPath('epic.png');
      case ElementType.legendary:
        return getElementPath('legendary.png');
      case ElementType.mythic:
        return getElementPath('mythic.png');
      default:
        throw Exception('Invalid element type = $type');
    }
  }

  static ElementType getElementTypeFromPath(String path) {
    return ElementType.values.firstWhere((type) => getElementPathFromType(type) == path);
  }

  static String translateElementType(ElementType type) {
    switch(type) {
      case ElementType.common:
        return 'Common';
      case ElementType.uncommon:
        return 'Uncommon';
      case ElementType.rare:
        return 'Rare';
      case ElementType.epic:
        return 'Epic';
      case ElementType.legendary:
        return 'Legendary';
      case ElementType.mythic:
        return 'Mythic';
      default:
        throw Exception('Invalid element type = $type');
    }
  }

  static String translateReleasedUnreleasedType(ItemStatusType type) {
    switch (type) {
      case ItemStatusType.released:
        return 'Released';
      case ItemStatusType.comingSoon:
        return 'Coming soon';
      case ItemStatusType.newItem:
        return 'New';
      default:
        throw Exception('Invalid released-unreleased type = $type');
    }
  }

  static String translateSoldierFilterType(SoldierFilterType type) {
    switch (type) {
      case SoldierFilterType.name:
        return 'Name';
      case SoldierFilterType.rarity:
        return 'Rarity';
      default:
        throw Exception('Invalid soldier filter type = $type');
    }
  }

  static String translateSortDirectionType(SortDirectionType type) {
    switch (type) {
      case SortDirectionType.asc:
        return 'Ascending';
      case SortDirectionType.desc:
        return 'Descending';
      default:
        throw Exception('Invalid sort direction type = $type');
    }
  }

  static String translateAppNotificationType(AppNotificationType type) {
    switch (type) {
      case AppNotificationType.custom:
        return 'Custom';
      case AppNotificationType.dailyCheckIn:
        return 'Daily Check-In';
      default:
        throw Exception('Invalid app notification type = $type');
    }
  }

  static String translateAppNotificationItemType(AppNotificationItemType type) {
    switch (type) {
      case AppNotificationItemType.soldier:
        return 'Soldiers';
      case AppNotificationItemType.weapon:
        return 'Weapons';
      case AppNotificationItemType.bonus:
        return 'Bonus';
      default:
        throw Exception('Invalid app notification type = $type');
    }
  }
}