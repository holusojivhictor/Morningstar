import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:morningstar/domain/app_constants.dart';
import 'package:morningstar/domain/assets.dart';
import 'package:morningstar/domain/enums/enums.dart';
import 'package:morningstar/domain/models/db/weapons/weapons_file.dart';
import 'package:morningstar/domain/models/models.dart';
import 'package:morningstar/domain/services/morningstar_service.dart';

class MorningStarServiceImpl implements MorningStarService {
  late SoldiersFile _soldiersFile;
  late WeaponsFile _weaponsFile;
  late TranslationFile _translationFile;
  late TopPicksFile _topPicksFile;

  @override
  Future<void> init(AppLanguageType languageType) async {
    await Future.wait([
      initSoldiers(),
      initWeapons(),
      initTopPicks(),
      initTranslations(languageType),
    ]);
  }
  
  @override
  Future<void> initSoldiers() async {
    final jsonStr = await rootBundle.loadString(Assets.soldiersDbPath);
    final json = jsonDecode(jsonStr) as Map<String, dynamic>;
    _soldiersFile = SoldiersFile.fromJson(json);
  }

  @override
  Future<void> initWeapons() async {
    final jsonStr = await rootBundle.loadString(Assets.weaponsDbPath);
    final json = jsonDecode(jsonStr) as Map<String, dynamic>;
    _weaponsFile = WeaponsFile.fromJson(json);
  }

  @override
  Future<void> initTranslations(AppLanguageType languageType) async {
    final transJsonStr = await rootBundle.loadString(Assets.getTranslationPath(languageType));
    final transJson = jsonDecode(transJsonStr) as Map<String, dynamic>;
    _translationFile = TranslationFile.fromJson(transJson);
  }

  @override
  Future<void> initTopPicks() async {
    final jsonStr = await rootBundle.loadString(Assets.topPicksDbPath);
    final json = jsonDecode(jsonStr) as Map<String, dynamic>;
    _topPicksFile = TopPicksFile.fromJson(json);
  }

  @override
  List<TodayTopPickSoldierModel> getTopPickSoldiers(int day) {
    final iterable = day == DateTime.sunday
        ? _topPicksFile.soldiers.where((t) => t.days.isNotEmpty)
        : _topPicksFile.soldiers.where((t) => t.days.contains(day));

    return iterable.map((e) {
      final translation = _translationFile.soldiers.firstWhere((t) => t.key == e.key);

      return TodayTopPickSoldierModel.fromDays(
        key: e.key,
        name: translation.name,
        imageUrl: e.imageUrl,
        stars: e.rarity,
        elementType: e.elementType,
        isNew: e.isNew,
        isComingSoon: e.isComingSoon,
      );
    }).toList();
  }

  @override
  List<TodayTopPickWeaponModel> getTopPickWeapons(int day) {
    final iterable = day == DateTime.sunday
        ? _topPicksFile.weapons.where((t) => t.days.isNotEmpty)
        : _topPicksFile.weapons.where((t) => t.days.contains(day));

    return iterable.map((e) {
      final translation = _translationFile.weapons.firstWhere((t) => t.key == e.key);

      return TodayTopPickWeaponModel.fromDays(
        key: e.key,
        imageUrl: e.fullImagePath,
        name: translation.name,
        damage: e.damage,
        accuracy: e.accuracy,
        range: e.range,
        fireRate: e.fireRate,
        mobility: e.mobility,
        control: e.control,
        type: e.type,
        model: e.model,
        isComingSoon: e.isComingSoon,
      );
    }).toList();
  }

  @override
  List<TierListRowModel> getDefaultWeaponTierList(List<int> colors) {
    assert(colors.length == 7);

    final sssTier = _weaponsFile.weapons
        .where((weapon) => !weapon.isComingSoon && weapon.tier == 'sss')
        .map((weapon) => ItemCommon(weapon.key, Assets.getWeaponCloudAll(weapon.imageUrl)))
        .toList();
    final ssTier = _weaponsFile.weapons
        .where((weapon) => !weapon.isComingSoon && weapon.tier == 'ss')
        .map((weapon) => ItemCommon(weapon.key, Assets.getWeaponCloudAll(weapon.imageUrl)))
        .toList();
    final sTier = _weaponsFile.weapons
        .where((weapon) => !weapon.isComingSoon && weapon.tier == 's')
        .map((weapon) => ItemCommon(weapon.key, Assets.getWeaponCloudAll(weapon.imageUrl)))
        .toList();
    final aTier = _weaponsFile.weapons
        .where((weapon) => !weapon.isComingSoon && weapon.tier == 'a')
        .map((weapon) => ItemCommon(weapon.key, Assets.getWeaponCloudAll(weapon.imageUrl)))
        .toList();
    final bTier = _weaponsFile.weapons
        .where((weapon) => !weapon.isComingSoon && weapon.tier == 'b')
        .map((weapon) => ItemCommon(weapon.key, Assets.getWeaponCloudAll(weapon.imageUrl)))
        .toList();
    final cTier = _weaponsFile.weapons
        .where((weapon) => !weapon.isComingSoon && weapon.tier == 'c')
        .map((weapon) => ItemCommon(weapon.key, Assets.getWeaponCloudAll(weapon.imageUrl)))
        .toList();
    final dTier = _weaponsFile.weapons
        .where((weapon) => !weapon.isComingSoon && weapon.tier == 'd')
        .map((weapon) => ItemCommon(weapon.key, Assets.getWeaponCloudAll(weapon.imageUrl)))
        .toList();

    return <TierListRowModel>[
      TierListRowModel.row(tierText: 'SSS', tierColor: colors.first, items: sssTier),
      TierListRowModel.row(tierText: 'SS', tierColor: colors[1], items: ssTier),
      TierListRowModel.row(tierText: 'S', tierColor: colors[2], items: sTier),
      TierListRowModel.row(tierText: 'A', tierColor: colors[3], items: aTier),
      TierListRowModel.row(tierText: 'B', tierColor: colors[4], items: bTier),
      TierListRowModel.row(tierText: 'C', tierColor: colors[5], items: cTier),
      TierListRowModel.row(tierText: 'D', tierColor: colors.last, items: dTier),
    ];
  }

  @override
  List<WeaponCardModel> getWeaponsForCard() {
    return _weaponsFile.weapons.map((e) => _toWeaponForCard(e)).toList();
  }

  @override
  WeaponFileModel getWeapon(String key) {
    return _weaponsFile.weapons.firstWhere((element) => element.key == key);
  }

  @override
  WeaponCardModel getWeaponForCard(String key) {
    final weapon = _weaponsFile.weapons.firstWhere((el) => el.key == key);
    return _toWeaponForCard(weapon);
  }

  @override
  List<SoldierCardModel> getSoldiersForCard() {
    return _soldiersFile.soldiers.map((e) => _toSoldierForCard(e)).toList();
  }

  @override
  SoldierFileModel getSoldier(String key) {
    return _soldiersFile.soldiers.firstWhere((element) => element.key == key);
  }

  @override
  SoldierCardModel getSoldierForCard(String key) {
    final soldier = _soldiersFile.soldiers.firstWhere((el) => el.key == key);
    return _toSoldierForCard(soldier);
  }

  SoldierCardModel _toSoldierForCard(SoldierFileModel soldier) {
    final translation = getSoldierTranslation(soldier.key);

    return SoldierCardModel(
      key: soldier.key,
      elementType: soldier.elementType,
      name: translation.name,
      imageUrl: soldier.imageUrl,
      stars: soldier.rarity,
      isComingSoon: soldier.isComingSoon,
      isNew: soldier.isNew,
    );
  }

  WeaponCardModel _toWeaponForCard(WeaponFileModel weapon) {
    final translation = getWeaponTranslation(weapon.key);
    return WeaponCardModel(
      key: weapon.key,
      damage: weapon.damage,
      accuracy: weapon.accuracy,
      range: weapon.range,
      fireRate: weapon.fireRate,
      mobility: weapon.mobility,
      control: weapon.control,
      imageUrl: weapon.fullImagePath,
      name: translation.name,
      type: weapon.type,
      model: weapon.model,
      isComingSoon: weapon.isComingSoon,
    );
  }

  @override
  TranslationSoldierFile getSoldierTranslation(String key) {
    return _translationFile.soldiers.firstWhere((element) => element.key == key);
  }

  @override
  TranslationWeaponFile getWeaponTranslation(String key) {
    return _translationFile.weapons.firstWhere((element) => element.key == key);
  }

  @override
  int getServerDay(AppServerResetTimeType type) {
    return getServerDate(type).weekday;
  }

  @override
  DateTime getServerDate(AppServerResetTimeType type) {
    final now = DateTime.now();
    final nowUtc = now.toUtc();
    DateTime server;
    switch (type) {
      case AppServerResetTimeType.northAmerica:
        server = nowUtc.subtract(const Duration(hours: 5));
        break;
      case AppServerResetTimeType.europe:
        server = nowUtc.add(const Duration(hours: 1));
        break;
      case AppServerResetTimeType.asia:
        server = nowUtc.add(const Duration(hours: 8));
        break;
      default:
        throw Exception('Invalid server reset type');
    }

    if (server.hour >= serverResetHour) {
      return server;
    }

    return server.subtract(const Duration(days: 1));
  }

  @override
  Duration getDurationUntilServerResetDate(AppServerResetTimeType type) {
    final serverDate = getServerDate(type);
    final serverResetDate = DateTime.utc(serverDate.year, serverDate.month, serverDate.day, serverResetHour);
    final dateToUse = serverDate.isBefore(serverResetDate) ? serverDate : serverDate.subtract(const Duration(days: 1));
    return serverResetDate.difference(dateToUse);
  }

  @override
  List<String> getUpcomingSoldiersKeys() => _soldiersFile.soldiers.where((el) => el.isComingSoon).map((e) => e.key).toList();

  @override
  List<String> getUpcomingWeaponsKeys() => _weaponsFile.weapons.where((el) => el.isComingSoon).map((e) => e.key).toList();

  @override
  List<String> getUpComingKeys() => getUpcomingSoldiersKeys() + getUpcomingWeaponsKeys();

  @override
  List<SoldierFileModel> getAllSoldiersThatCanBeUsedForNotification() {
    return _soldiersFile.soldiers.where((el) => el.canBeUsedForNotif).toList();
  }

  @override
  String getItemImageFromNotificationType(
      String itemKey,
      AppNotificationType notificationType, {AppNotificationItemType? notificationItemType,
  }) {
    switch (notificationType) {
      case AppNotificationType.custom:
      case AppNotificationType.dailyCheckIn:
        return getItemImageFromNotificationItemType(itemKey, notificationItemType!);
      default:
        throw Exception('The provide notification type = $notificationType is not valid');
    }
  }

  @override
  String getItemImageFromNotificationItemType(String itemKey, AppNotificationItemType notificationItemType) {
    final logoPath = Assets.getCODMLogoPath('codm-logo.png');
    switch (notificationItemType) {
      case AppNotificationItemType.soldier:
        return logoPath;
      // TODO: Add weapon case
      case AppNotificationItemType.bonus:
        return logoPath;
      default:
        throw Exception('The provide notification type = $notificationItemType is not valid');
    }
  }
}