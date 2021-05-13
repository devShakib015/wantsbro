import 'package:flutter/material.dart';

import 'package:wantsbro/theming/color_constants.dart';

ThemeData mainTheme = ThemeData.dark().copyWith(
  primaryColor: mainColor,
  primaryColorLight: mainColor,
  accentColor: mainColor,
  checkboxTheme: CheckboxThemeData(
    checkColor: MaterialStateProperty.all(white),
    overlayColor: MaterialStateProperty.all(white),
  ),
  timePickerTheme: TimePickerThemeData(
    backgroundColor: mainBackgroundColor,
  ),
  colorScheme: ColorScheme.dark().copyWith(
    primary: white,
  ),
  textTheme: TextTheme(
    bodyText1: TextStyle(
      fontFamily: "Nunito",
      fontSize: 18,
    ),
    bodyText2: TextStyle(
      fontFamily: "Nunito",
      fontSize: 18,
    ),
    button: TextStyle(
      fontFamily: "Nunito",
      color: white,
      fontSize: 18,
    ),
    caption: TextStyle(
      fontFamily: "Nunito",
      fontSize: 18,
    ),
    headline4: TextStyle(
      fontFamily: "Nunito",
      fontSize: 18,
    ),
    headline5: TextStyle(
      fontFamily: "Nunito",
      fontSize: 18,
    ),
    headline6: TextStyle(
      fontFamily: "Nunito",
      fontSize: 18,
    ),
    subtitle1: TextStyle(
      fontFamily: "Nunito",
      fontSize: 18,
    ),
    subtitle2: TextStyle(
      fontFamily: "Nunito",
      fontSize: 18,
    ),
    overline: TextStyle(
      fontFamily: "Nunito",
      fontSize: 18,
    ),
    headline3: TextStyle(
      fontFamily: "Nunito",
      fontSize: 18,
    ),
    headline2: TextStyle(
      fontFamily: "Nunito",
      fontSize: 18,
    ),
    headline1: TextStyle(
      fontFamily: "Nunito",
      fontSize: 18,
    ),
  ),
  bottomAppBarColor: mainColor,
  scaffoldBackgroundColor: mainBackgroundColor,
  appBarTheme: AppBarTheme(
    color: mainBackgroundColor,
    centerTitle: true,
    elevation: 0,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    elevation: 20,
    showSelectedLabels: true,
    selectedLabelStyle: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
    ),
  ),
  dialogBackgroundColor: otherDark,
  highlightColor: mainColor,
  cardColor: mainColor,
  canvasColor: otherDark,
  backgroundColor: mainBackgroundColor,
  primaryColorDark: mainBackgroundColor,
  splashColor: Colors.red,
  tabBarTheme: TabBarTheme(
    labelColor: white,
    unselectedLabelColor: disableWhite,
  ),
  buttonColor: mainColor,
  inputDecorationTheme: InputDecorationTheme(
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: mainColor, width: 3),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: mainColor, width: 4),
    ),
    fillColor: mainColor,
    labelStyle: TextStyle(color: white),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: mainColor, width: 2),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: mainColor, width: 3),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(mainColor)),
  ),
  toggleButtonsTheme: ToggleButtonsThemeData(
    textStyle: TextStyle(color: white),
    color: mainColor,
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(mainColor),
        foregroundColor: MaterialStateProperty.all(white)),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(mainColor),
        foregroundColor: MaterialStateProperty.all(white)),
  ),
  toggleableActiveColor: mainColor,
  buttonTheme: ButtonThemeData(
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
  focusColor: mainColor,
  dividerColor: mainColor,
  iconTheme: IconThemeData(color: white),
  accentIconTheme: IconThemeData(color: white),
  primaryIconTheme: IconThemeData(color: white),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: mainColor,
    foregroundColor: white,
  ),
);
