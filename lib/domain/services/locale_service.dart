import 'package:morningstar/domain/enums/enums.dart';
import 'package:morningstar/domain/models/models.dart';

abstract class LocaleService {
  LanguageModel getLocaleWithoutLang();

  LanguageModel getLocale(AppLanguageType language);

  String getFormattedLocale(AppLanguageType language);

  String getDayNameFromDate(DateTime date);

  String getDayNameFromDay(int day);
}