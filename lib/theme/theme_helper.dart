import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/app_export.dart';

LightCodeColors get appTheme => ThemeHelper().themeColor();
ThemeData get theme => ThemeHelper().themeData();





class ThemeHelper {
  //current app theme
  var _appTheme = PrefUtils().getThemeData();


  Map<String, LightCodeColors> _supportedCustomColor = {
    'lightCode': LightCodeColors()
  };


  Map<String, ColorScheme> _supportedColorScheme = {
    'lightCode': ColorSchemes.lightCodeColorScheme
  };


  LightCodeColors _getThemeColors(){
    return _supportedCustomColor[_appTheme]?? LightCodeColors();
  }

  //return the current theme data
  ThemeData _getThemeData(){
    var colorScheme = _supportedColorScheme[_appTheme]?? ColorSchemes.lightCodeColorScheme;
    return ThemeData(
      visualDensity: VisualDensity.standard,
      colorScheme: colorScheme,
      textTheme: TextThemes.textTheme(colorScheme),
      scaffoldBackgroundColor: colorScheme.onPrimaryContainer,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          shadowColor: appTheme.main,
          elevation: 3,
          visualDensity: const VisualDensity(
            vertical: -4,
            horizontal: -4,
          ),
          padding: EdgeInsets.zero,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
          side: BorderSide(
            color: colorScheme.primary,
              width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          visualDensity: const VisualDensity(
            vertical: -4,
            horizontal: -4,
          ),
          padding: EdgeInsets.zero,
        ),
      ),
      dividerTheme: DividerThemeData(
        thickness: 1,
        space: 1,
        color: appTheme.main,
      ),
    );
  }

  /// return the lightCode colors for the current theme
  LightCodeColors themeColor() => _getThemeColors();
  //return the current theme data
  ThemeData themeData() => _getThemeData();
}


class TextThemes {
  static TextTheme textTheme(ColorScheme colorScheme) => TextTheme(
    bodyLarge: TextStyle(
      color: appTheme.main,
      fontSize: 19.fSize,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w400,
    ),
    bodyMedium: TextStyle(
      color: appTheme.main,
      fontSize: 15.fSize,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w400,
    ),

    displayMedium: TextStyle(
      color: appTheme.main,
      fontSize: 50.fSize,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w400,
    ),
    displaySmall: TextStyle(
      color: colorScheme.onPrimary,
      fontSize: 35.fSize,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w600,
    ),
    headlineLarge: TextStyle(
      color: appTheme.main,
      fontSize: 33.fSize,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w300,
    ),
    headlineMedium: TextStyle(
      color: colorScheme.onPrimaryContainer,
      fontSize: 28.fSize,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w700,
    ),
    headlineSmall: TextStyle(
      color: appTheme.main,
      fontSize: 25.fSize,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w300,
    ),
    titleLarge: TextStyle(
      color: colorScheme.onPrimaryContainer,
      fontSize: 20.fSize,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w600,
    ),
    titleMedium: TextStyle(
      color: appTheme.main,
      fontSize: 16.fSize,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w500,
    ),
    titleSmall: TextStyle(
      color: appTheme.main,
      fontSize: 14.fSize,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w600,
    ),
  );
}

class ColorSchemes {
  static final lightCodeColorScheme = ColorScheme.light(
    primary: Color(0XFF0270d6),
    secondaryContainer: Color(0XFFFFD987),
    onPrimary: Color(0XFF1F41BB),
    onPrimaryContainer: Color(0XFFFFFFFF),
  );
}

class LightCodeColors {
  Color get main => Color(0XFF016CD8);
  Color get colorc3c3 => Color(0xFFC3C3C3);
  Color get color036 => Color(0xFF0363E2);
  Color get mainTitle => Color(0XFF016FD3);
  Color get blueDark => Color(0XFF298AE2);
  Color get color0072 => Color(0xff0072CF);
  Color get blueLight => Color(0XFFB3DBFF);
  Color get white => Color(0XFFFFFFFF);
  Color get gray => Color(0XFF8F8F8F);
  Color get red => Color(0XFFD03D3D);
  Color get gray7272 => Color(0XFF727272);
  Color get grayA0A0 => Color(0XFFA0A0A0);
  Color get grayEE => Color(0XFFEEEEEE);
  Color get grayLite => Color(0XFFededed);
  Color get gray8989 => Color(0XFF898989);
  Color get lightBlue => Color(0XFFE4F0FF);
  Color get orange => Color(0XFFFF9416);
  Color get green => Color(0XFF26A17B);
  Color get error => const Color(0XFFff7373);
  Color get f6f6f6 => const Color(0XFFF6F6F6);
  Color get color7D7D => const Color(0XFF7D7D7D);
  Color get color549FE3 => const Color(0XFF549FE3);
  Color get color8C8C => const Color(0XFF8C8C8C);
  Color get color8383 => const Color(0XFF838383);
  Color get color9999 => const Color(0XFF999999);
  Color get color9898 => const Color(0XFF989898);
  Color get color7CA => const Color(0XFF7CA0F7);
  Color get colorEA96 => const Color(0XFFEA9633);
  Color get colorE132 => const Color(0XFFE13232);

}