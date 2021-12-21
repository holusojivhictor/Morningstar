import 'package:morningstar/domain/enums/enums.dart';
import 'package:morningstar/domain/models/models.dart';

const languagesMap = {
  AppLanguageType.english: LanguageModel('en', 'US'),
};

const serverResetHour = 4;

const dailyCheckInResetDuration = Duration(hours: 24);