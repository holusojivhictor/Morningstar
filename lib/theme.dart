import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

class Styles {
  static const edgeInsetAll15 = EdgeInsets.all(15);
  static const edgeInsetAll10 = EdgeInsets.all(10);
  static const edgeInsetAll5 = EdgeInsets.all(5);
  static const edgeInsetAll0 = EdgeInsets.zero;
  static const edgeInsetHorizontal16 = EdgeInsets.symmetric(horizontal: 16);
  static const edgeInsetVertical5 = EdgeInsets.symmetric(vertical: 5);
  static const edgeInsetHorizontal5 = EdgeInsets.symmetric(horizontal: 5);
  static const edgeInsetVertical16 = EdgeInsets.symmetric(vertical: 16);
  static const edgeInsetVertical10 = EdgeInsets.symmetric(vertical: 10);
  static const edgeInsetHorizontal10 = EdgeInsets.symmetric(horizontal: 10);

  static const double smallButtonSplashRadius = 18;
  static const double mediumButtonSplashRadius = 25;

  static const modalBottomSheetShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      topRight: Radius.circular(35),
      topLeft: Radius.circular(35),
    ),
  );
  static const modalBottomSheetContainerMargin = EdgeInsets.only(left: 10, right: 10, bottom: 10);
  static const modalBottomSheetContainerPadding = EdgeInsets.only(left: 10, right: 10, top: 10);

  static BorderRadius homeCardItemBorderRadius = BorderRadius.circular(30);

  static const cardItemDetailShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      topRight: Radius.circular(20),
      topLeft: Radius.circular(20),
      bottomLeft: Radius.circular(20),
      bottomRight: Radius.circular(20),
    ),
  );

  static const mainCardBorderRadius = BorderRadius.only(
    bottomLeft: Radius.circular(10),
    bottomRight: Radius.circular(10),
    topLeft: Radius.circular(10),
    topRight: Radius.circular(10),
  );

  static const videoPlayerBorderRadius = BorderRadius.only(
    bottomLeft: Radius.circular(25),
    bottomRight: Radius.circular(25),
    topLeft: Radius.circular(25),
    topRight: Radius.circular(25),
  );

  static final RoundedRectangleBorder cardShape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(10));
  static const RoundedRectangleBorder mainCardShape = RoundedRectangleBorder(borderRadius: mainCardBorderRadius);
  static final RoundedRectangleBorder floatingCardShape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(20));

  static const double cardThreeElevation = 3;
  static const double cardTenElevation = 10;

  static const listItemWithIconOffset = Offset(-15, 0);

  static const endDrawerFilterItemMargin = EdgeInsets.only(top: 20);
  static const double endDrawerIconSize = 30;

  static double getIconSizeForItemPopupMenuFilter(bool forEndDrawer, bool forDefaultIcons) {
    if (forDefaultIcons) {
      return forEndDrawer ? 36 : 24;
    }
    return forEndDrawer ? 26 : 18;
  }

  static const double materialCardHeight = 360;
  static const double materialCardWidth = 220;
  static const double homeCardHeight = 170;
  static const double homeCardWidth = 280;
}

TextTheme textTheme(BuildContext context) {
  return GoogleFonts.latoTextTheme(Theme.of(context).textTheme);
}

Color kTextDark = Colors.black;
Color kTextLight = Colors.white;

class MorningstarTheme {
  static TextTheme lightTextTheme = TextTheme(
    bodyText1: GoogleFonts.lato(
      fontSize: 14.0,
      fontWeight:FontWeight.w700,
      color: kTextDark,
    ),
    bodyText2: GoogleFonts.lato(
      fontSize: 12.0,
      fontWeight:FontWeight.normal,
      color: kTextDark,
    ),
    headline1: GoogleFonts.lato(
      fontSize: 26.0,
      fontWeight:FontWeight.bold,
      color: kTextDark,
    ),
    headline2: GoogleFonts.lato(
      fontSize: 18.0,
      fontWeight:FontWeight.w700,
      color: kTextDark,
    ),
    headline3: GoogleFonts.lato(
      fontSize: 14.0,
      fontWeight:FontWeight.w600,
      color: kTextDark,
    ),
    headline4: GoogleFonts.lato(
      fontSize: 16.0,
      fontWeight:FontWeight.w500,
      color: kTextDark,
    ),
    headline5: GoogleFonts.lato(
      fontSize: 24.0,
      fontWeight:FontWeight.w500,
      color: kTextDark,
    ),
    headline6: GoogleFonts.lato(
      fontSize: 20.0,
      fontWeight:FontWeight.w500,
      color: kTextDark,
    ),
  );

  static TextTheme darkTextTheme = TextTheme(
    bodyText1: GoogleFonts.lato(
      fontSize: 14.0,
      fontWeight:FontWeight.w700,
      color: kTextLight,
    ),
    bodyText2: GoogleFonts.lato(
      fontSize: 12.0,
      fontWeight:FontWeight.normal,
      color: kTextLight,
    ),
    headline1: GoogleFonts.lato(
      fontSize: 26.0,
      fontWeight:FontWeight.bold,
      color: kTextLight,
    ),
    headline2: GoogleFonts.lato(
      fontSize: 18.0,
      fontWeight:FontWeight.w700,
      color: kTextLight,
    ),
    headline3: GoogleFonts.lato(
      fontSize: 14.0,
      fontWeight:FontWeight.w600,
      color: kTextLight,
    ),
    headline4: GoogleFonts.lato(
      fontSize: 16.0,
      fontWeight:FontWeight.w500,
      color: kTextLight,
    ),
    headline5: GoogleFonts.lato(
      fontSize: 24.0,
      fontWeight:FontWeight.w500,
      color: kTextLight,
    ),
    headline6: GoogleFonts.lato(
      fontSize: 20.0,
      fontWeight:FontWeight.w500,
      color: kTextLight,
    ),
  );

  static ThemeData light() {
    return ThemeData(
      dividerColor: const Color(0xFFF9F9F9),
      bottomAppBarColor: const Color(0xFFF1F1F1),
      canvasColor: Colors.grey[50],
      cardColor: Colors.white,
      shadowColor: const Color(0xFFC3EDDA),
      indicatorColor: Colors.black,
      textSelectionTheme: const TextSelectionThemeData(cursorColor: Colors.black),
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF1F1F1),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
      ),
      textTheme: lightTextTheme,
      primaryColor: const Color(0xFFFFE600),
      colorScheme: const ColorScheme.light(primary: Color(0xFFFFE600)).copyWith(secondary: Colors.yellowAccent),
    );
  }
  static ThemeData dark() {
    return ThemeData(
      dividerColor: Colors.black,
      bottomAppBarColor: const Color(0xFF272C2F),
      canvasColor: Colors.black54,
      cardColor: Colors.grey.shade900,
      shadowColor: const Color(0xFF192C31),
      indicatorColor: Colors.white,
      textSelectionTheme: const TextSelectionThemeData(cursorColor: Colors.white),
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF000000),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
      ),
      textTheme: darkTextTheme,
      primaryColor: const Color(0xFFFFE600),
      colorScheme: const ColorScheme.dark(primary: Color(0xFFFFE600)).copyWith(secondary: Colors.yellowAccent),
    );
  }
}