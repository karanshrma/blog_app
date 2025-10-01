
import 'package:flutter/material.dart';
import 'package:offline_first/core/theme/app_pallete.dart';

class AppTheme{
  static _border([Color color = AppPallete.borderColor]) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(10) ,
      borderSide: BorderSide(
          color: color,
          width: 3
      )
  );
  static final darkThemeMode = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppPallete.backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppPallete.backgroundColor,
    ),
    chipTheme: const ChipThemeData(
      color: WidgetStatePropertyAll(AppPallete.backgroundColor) ,
      side: BorderSide.none
    ) ,
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: EdgeInsets.all(27),
      enabledBorder: _border(),
      border: _border(),
      errorBorder: _border(AppPallete.errorColor),
      focusedBorder: _border(AppPallete.gradient2),
    )
  );

}