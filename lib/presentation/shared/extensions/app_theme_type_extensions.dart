import 'package:flutter/material.dart';
import 'package:morningstar/domain/enums/enums.dart';
import 'package:morningstar/theme.dart';

extension AppThemeTypeExtensions on AppThemeType {
  ThemeData getThemeData(AppThemeType theme) {
    switch (theme) {
      case AppThemeType.dark:
        return MorningstarTheme.dark().copyWith(
          scaffoldBackgroundColor: const Color(0xFF000000),
        );
      case AppThemeType.grey:
        return MorningstarTheme.dark().copyWith(
          scaffoldBackgroundColor: Colors.grey[850],
        );
      default:
        throw Exception('Invalid theme type, = $theme');
    }
  }
}