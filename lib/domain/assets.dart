import 'package:morningstar/domain/app_constants.dart';
import 'package:morningstar/domain/enums/enums.dart';
import 'extensions/string_extensions.dart';

class Assets {
  static String dbPath = 'assets/db';
  static String soldiersDbPath = '$dbPath/soldiers.json';
  static String weaponsDbPath = '$dbPath/weapons.json';
  static String topPicksDbPath = '$dbPath/top_picks.json';
  static String comicsDbPath = '$dbPath/comics.json';
  static String vehiclesDbPath = '$dbPath/vehicles.json';
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

  static String getComicBasePath(String folder, String name) => '$comicsImageUrl$folder/$name';

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

  static String getComicPath(String name, ComicSeasonType type) {
    switch (type) {
      case ComicSeasonType.six:
        return getComicBasePath('six', name);
      case ComicSeasonType.seven:
        return getComicBasePath('seven', name);
      case ComicSeasonType.eight:
        return getComicBasePath('eight', name);
      case ComicSeasonType.nine:
        return getComicBasePath('nine', name);
      case ComicSeasonType.ten:
        return getComicBasePath('ten', name);
      case ComicSeasonType.eleven:
        return getComicBasePath('eleven', name);
      case ComicSeasonType.twelve:
        return getComicBasePath('twelve', name);
      case ComicSeasonType.thirteen:
        return getComicBasePath('thirteen', name);
      case ComicSeasonType.fourteen:
        return getComicBasePath('fourteen', name);
      case ComicSeasonType.fifteen:
        return getComicBasePath('fifteen', name);
      case ComicSeasonType.sixteen:
        return getComicBasePath('sixteen', name);
      case ComicSeasonType.seventeen:
        return getComicBasePath('seventeen', name);
      case ComicSeasonType.eighteen:
        return getComicBasePath('eighteen', name);
      case ComicSeasonType.nineteen:
        return getComicBasePath('nineteen', name);
      case ComicSeasonType.twenty:
        return getComicBasePath('twenty', name);
      case ComicSeasonType.twentyOne:
        return getComicBasePath('twentyOne', name);
      default:
        throw Exception('Invalid comic season type = $type');
    }
  }

  static String getWeaponPathAll(String? name) {
    if (name.isNullEmptyOrWhitespace) {
      return '$othersBasePath/$noImageAvailableName';
    }
    return '$weaponsBasePath/$name';
  }

  static String getWeaponCloudAll(String? name) {
    if (name.isNullEmptyOrWhitespace) {
      return noImageAvailableName;
    }
    return '$name';
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

  static String translateAppThemeType(AppThemeType theme) {
    switch (theme) {
      case AppThemeType.dark:
        return 'Jet Black';
      case AppThemeType.grey:
        return 'Outer Space Black';
      default:
        throw Exception('The provided app theme type = $theme is not valid');
    }
  }

  static String translateAppLanguageType(AppLanguageType language) {
    switch (language) {
      case AppLanguageType.english:
        return 'English';
      default:
        throw Exception('The provided app language type = $language is not valid');
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

  static String translateAppServerResetTimeType(AppServerResetTimeType type) {
    switch (type) {
      case AppServerResetTimeType.northAmerica:
        return 'North America';
      case AppServerResetTimeType.europe:
        return 'Europe';
      case AppServerResetTimeType.asia:
        return 'Asia';
      default:
        throw Exception('The provided server type = $type is not valid');
    }
  }

  static String translateWeaponModel(WeaponModel model) {
    switch (model) {
      case WeaponModel.assault:
        return 'Assault';
      case WeaponModel.smg:
        return 'SMG';
      case WeaponModel.sniper:
        return 'Sniper';
      case WeaponModel.shotgun:
        return 'Shotgun';
      case WeaponModel.lmg:
        return 'LMG';
      case WeaponModel.marksman:
        return 'Marksman';
      case WeaponModel.pistol:
        return 'Pistol';
      case WeaponModel.axe:
        return 'Axe';
      case WeaponModel.baseMelee:
        return 'Base Melee';
      case WeaponModel.baseballBat:
        return 'Baseball Bat';
      case WeaponModel.launcher:
        return 'Launcher';
      case WeaponModel.knife:
        return 'Knife';
      case WeaponModel.machete:
        return 'Machete';
      case WeaponModel.shovel:
        return 'Shovel';
      case WeaponModel.sickle:
        return 'Sickle';
      case WeaponModel.wrench:
        return 'Wrench';
      case WeaponModel.lethal:
        return 'Lethal';
      case WeaponModel.tactical:
        return 'Tactical';
      default:
        throw Exception('The provided weapon model = $model is not valid.');
    }
  }

  static String translateComicSeasonType(ComicSeasonType type) {
    const season = 'Season';
    switch (type) {
      case ComicSeasonType.six:
        return '$season 6';
      case ComicSeasonType.seven:
        return '$season 7';
      case ComicSeasonType.eight:
        return '$season 8';
      case ComicSeasonType.nine:
        return '$season 9';
      case ComicSeasonType.ten:
        return '$season 10';
      case ComicSeasonType.eleven:
        return '$season 11';
      case ComicSeasonType.twelve:
        return '$season 12';
      case ComicSeasonType.thirteen:
        return '$season 13';
      case ComicSeasonType.fourteen:
        return '$season 1/2021';
      case ComicSeasonType.fifteen:
        return '$season 2/2021';
      case ComicSeasonType.sixteen:
        return '$season 3/2021';
      case ComicSeasonType.seventeen:
        return '$season 4/2021';
      case ComicSeasonType.eighteen:
        return '$season 5/2021';
      case ComicSeasonType.nineteen:
        return '$season 6/2021';
      case ComicSeasonType.twenty:
        return '$season 6a/2021';
      case ComicSeasonType.twentyOne:
        return '$season 7/2021';
      default:
        throw Exception('Invalid comic season type = $type');
    }
  }

  static String translateWeaponType(WeaponType type) {
    switch (type) {
      case WeaponType.primary:
        return 'Primary';
      case WeaponType.secondary:
        return 'Secondary';
      case WeaponType.throwable:
        return 'Throwable';
      default:
        throw Exception('Invalid weapon type = $type');
    }
  }

  static String translateWeaponFilterType(WeaponFilterType type) {
    switch (type) {
      case WeaponFilterType.name:
        return 'Name';
      case WeaponFilterType.damage:
        return 'Damage';
      default:
        throw Exception('Invalid weapon filter type = $type');
    }
  }
}