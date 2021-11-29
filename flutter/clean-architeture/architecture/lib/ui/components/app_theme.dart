import 'package:flutter/material.dart';

ThemeData makeAppTheme() {
  const primaryColor = const Color.fromRGBO(136, 14, 79, 1);
  const primaryColorDark = const Color.fromRGBO(96, 0, 39, 1);
  const primaryColorLight = const Color.fromRGBO(188, 71, 123, 1);
  const secondaryColor = const Color.fromRGBO(0, 77, 64, 1);
  const secondaryColorDark = const Color.fromRGBO(0, 37, 26, 1);
  final disabledColor = Colors.grey[400];
  final dividerColor = Colors.grey;
  const textTheme = TextTheme(
      headline1: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: primaryColorDark
      )
  );
  const inputDecorationTheme = InputDecorationTheme(
      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: primaryColorLight)
      ),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: primaryColor)
      ),
      alignLabelWithHint: true
  );
  final buttonTheme = ButtonThemeData(
      colorScheme: const ColorScheme.light(primary: primaryColor),
      buttonColor: primaryColor,
      splashColor: primaryColorLight,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
      )
  );

  return ThemeData(
      primaryColor: primaryColor,
      primaryColorDark: primaryColorDark,
      primaryColorLight: primaryColorLight,
      highlightColor: secondaryColor,
      secondaryHeaderColor: secondaryColorDark,
      disabledColor: disabledColor,
      dividerColor: dividerColor,
      colorScheme: const ColorScheme.light(primary: primaryColor),
      backgroundColor: Colors.white,
      textTheme: textTheme,
      inputDecorationTheme: inputDecorationTheme,
      buttonTheme: buttonTheme
  );
}