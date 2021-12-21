import 'package:morningstar/domain/enums/enums.dart';
import 'package:morningstar/domain/models/home/today_top_pick_soldier_model.dart';
import 'package:morningstar/domain/models/models.dart';

abstract class MorningStarService {
  Future<void> init(AppLanguageType languageType);
  Future<void> initSoldiers();
  Future<void> initTopPicks();
  Future<void> initTranslations(AppLanguageType languageType);

  List<SoldierCardModel> getSoldiersForCard();
  SoldierCardModel getSoldierForCard(String key);
  SoldierFileModel getSoldier(String key);
  List<String> getUpcomingSoldiersKeys();

  TranslationSoldierFile getSoldierTranslation(String key);

  int getServerDay(AppServerResetTimeType type);
  DateTime getServerDate(AppServerResetTimeType type);
  Duration getDurationUntilServerResetDate(AppServerResetTimeType type);

  List<String> getUpComingKeys();

  List<TodayTopPickSoldierModel> getTopPickSoldiers(int day);

  String getItemImageFromNotificationType(String itemKey, AppNotificationType notificationType, {AppNotificationItemType? notificationItemType});
  String getItemImageFromNotificationItemType(String itemKey, AppNotificationItemType notificationItemType);

  List<SoldierFileModel> getAllSoldiersThatCanBeUsedForNotification();
}