import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:morningstar/domain/app_constants.dart';
import 'package:morningstar/domain/assets.dart';
import 'package:morningstar/domain/enums/enums.dart';
import 'package:morningstar/domain/models/db/top_picks/top_picks_file.dart';
import 'package:morningstar/domain/models/home/today_top_pick_soldier_model.dart';
import 'package:morningstar/domain/models/models.dart';
import 'package:morningstar/domain/services/morningstar_service.dart';

class MorningStarServiceImpl implements MorningStarService {
  late SoldiersFile _soldiersFile;
  late TranslationFile _translationFile;
  late TopPicksFile _topPicksFile;

  @override
  Future<void> init(AppLanguageType languageType) async {
    await Future.wait([
      initSoldiers(),
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
        ? _topPicksFile.topPicks.where((t) => t.days.isNotEmpty)
        : _topPicksFile.topPicks.where((t) => t.days.contains(day));

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

  @override
  TranslationSoldierFile getSoldierTranslation(String key) {
    return _translationFile.soldiers.firstWhere((element) => element.key == key);
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
  List<String> getUpComingKeys() => getUpcomingSoldiersKeys();

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
    switch (notificationItemType) {
      case AppNotificationItemType.soldier:
        final soldier = getSoldier(itemKey);
        return soldier.fullImagePath;
      // TODO: Add weapon case
      case AppNotificationItemType.bonus:
        return Assets.getCODMLogoPath('codm-logo.png');
      default:
        throw Exception('The provide notification type = $notificationItemType is not valid');
    }
  }
}