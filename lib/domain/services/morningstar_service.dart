import 'package:morningstar/domain/enums/enums.dart';
import 'package:morningstar/domain/models/models.dart';

abstract class MorningStarService {
  Future<void> init(AppLanguageType languageType);
  Future<void> initSoldiers();
  Future<void> initWeapons();
  Future<void> initTopPicks();
  Future<void> initComics();
  Future<void> initVehicles();
  Future<void> initTranslations(AppLanguageType languageType);

  List<SoldierCardModel> getSoldiersForCard();
  SoldierCardModel getSoldierForCard(String key);
  SoldierFileModel getSoldier(String key);
  List<String> getUpcomingSoldiersKeys();
  List<TierListRowModel> getDefaultWeaponTierList(List<int> colors);

  List<VehicleCardModel> getVehiclesForCard();
  VehicleCardModel getVehicleForCard(String key);
  VehicleFileModel getVehicle(String key);

  List<ComicCardModel> getComicsForCard();
  ComicCardModel getComicForCard(String name);
  ComicFileModel getComic(String name);

  List<WeaponCardModel> getWeaponsForCard();
  WeaponCardModel getWeaponForCard(String key);
  WeaponFileModel getWeapon(String key);
  List<String> getUpcomingWeaponsKeys();

  TranslationSoldierFile getSoldierTranslation(String key);
  TranslationWeaponFile getWeaponTranslation(String key);

  int getServerDay(AppServerResetTimeType type);
  DateTime getServerDate(AppServerResetTimeType type);
  Duration getDurationUntilServerResetDate(AppServerResetTimeType type);

  List<String> getUpComingKeys();

  List<TodayTopPickSoldierModel> getTopPickSoldiers(int day);
  List<TodayTopPickWeaponModel> getTopPickWeapons(int day);

  String getItemImageFromNotificationType(String itemKey, AppNotificationType notificationType, {AppNotificationItemType? notificationItemType});
  String getItemImageFromNotificationItemType(String itemKey, AppNotificationItemType notificationItemType);

  List<SoldierFileModel> getAllSoldiersThatCanBeUsedForNotification();
}