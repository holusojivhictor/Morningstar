import 'package:intl/intl.dart';
import 'package:morningstar/domain/app_constants.dart';
import 'package:morningstar/domain/enums/enums.dart';
import 'package:morningstar/domain/models/models.dart';
import 'package:morningstar/domain/services/locale_service.dart';
import 'package:morningstar/domain/services/settings_service.dart';

class LocaleServiceImpl implements LocaleService {
  final SettingsService _settingsService;

  LocaleServiceImpl(this._settingsService);

  @override
  String getFormattedLocale(AppLanguageType language) {
    final locale = getLocale(language);
    return '${locale.code}_${locale.countryCode}';
  }

  @override
  LanguageModel getLocaleWithoutLang() {
    return getLocale(_settingsService.language);
  }

  @override
  LanguageModel getLocale(AppLanguageType language) {
    if (!languagesMap.entries.any((kvp) => kvp.key == language)) {
      throw Exception('The language = $language is not a valid value');
    }

    return languagesMap.entries.firstWhere((kvp) => kvp.key == language).value;
  }

  @override
  String getDayNameFromDate(DateTime date) {
    final locale = getFormattedLocale(_settingsService.language);
    return DateFormat('EEEE', locale).format(date).toUpperCase();
  }

  @override
  String getDayNameFromDay(int day) {
    final dates = List.generate(7, (index) => DateTime.now().add(Duration(days: index)));

    for (final date in dates) {
      if (date.weekday != day) {
        continue;
      }
      return getDayNameFromDate(date);
    }

    return 'N/A';
  }
}