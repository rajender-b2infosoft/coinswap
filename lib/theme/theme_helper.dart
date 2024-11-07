
import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/app_export.dart';

LightCodeColors get appTheme => ThemeHelper().themeColor();
ThemeData get theme => ThemeHelper().themeData();





class ThemeHelper {
  //current app theme
  var _appTheme = PrefUtils().getThemeData();


  Map<String, LightCodeColors> _supportedCustomColor = {
    'lightCode': LightCodeColors(),
    'darkCode': DarkCodeColors()
  };


  Map<String, ColorScheme> _supportedColorScheme = {
    'lightCode': ColorSchemes.lightCodeColorScheme,
    'darkCode': ColorSchemes.darkCodeColorScheme
  };


  LightCodeColors _getThemeColors(){
    return _supportedCustomColor[_appTheme]?? LightCodeColors();
  }

  //return the current theme data
  ThemeData _getThemeData(){
    var colorScheme = _appTheme == 'darkCode' ? ColorSchemes.darkCodeColorScheme : ColorSchemes.lightCodeColorScheme;
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
  static final darkCodeColorScheme = ColorScheme.dark(
    primary: Color(0XFF0270d6),
    secondaryContainer: Color(0XFF555555),
    onPrimary: Color(0XFFFFFFFF),
    onPrimaryContainer: Color(0XFF1F41BB),
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
  Color get darkGreen => Color(0XFF36A62C);
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
  // Color get color0071D0 => const Color(0XFF0071D0);
  Color get color0071D0 => const Color(0XFF016CD8);
  Color get color858585 => const Color(0XFF858585);
  Color get colorB6B6B6 => const Color(0XFFB6B6B6);
  // Color get color0071 => const Color(0XFF0071D0);
  Color get color0071 => const Color(0XFF016CD8);
  Color get color0072D => const Color(0XFF0072D0);
  Color get color5E8DF7 => const Color(0XFF5E8DF7);
  Color get lightGreen => const Color(0XFF4FCD44);
  Color get colorEFEFEF => const Color(0XFFEFEFEF);
  Color get color2628 => const Color(0XFF262847);
  Color get colorBFFFBA => const Color(0XFFBFFFBA);
  Color get color2D9224 => const Color(0XFF2D9224);
  Color get color747474 => const Color(0XFF747474);
  Color get colorFFB8B8 => const Color(0XFFFFB8B8);
  Color get color2E92ED => const Color(0XFF2E92ED);
  Color get black => const Color(0XFF000000);

}

class DarkCodeColors extends LightCodeColors {
  Color get main => Color(0XFF1b1c2e);
  Color get blueDark => Color(0XFF298AE2);
  Color get gray7272 => Color(0XFFD6D6D6);
  Color get gray => Color(0XFFD6D6D6);
  Color get lightBlue => Color(0XFF8A9ED8);
  Color get color549FE3 => const Color(0XFF549FE3);
  Color get white => Color(0XFFFFFFFF);
  Color get blueLight => Color(0XFF5572C6);
  Color get orange => Color(0XFFFF9416);
  Color get green => Color(0XFF26A17B);
  Color get color9898 => const Color(0XFFD6D6D6);
  Color get colorc3c3 => Color(0xFFDDDDDD);
  Color get color8383 => const Color(0XFF5570C4);
  Color get color9999 => const Color(0XFF5570C4);
  Color get color0071 => const Color(0XFF5570C4);
  Color get mainTitle => Color(0XFF5572C6);


  Color get color036 => Color(0xFF0363E2);
  Color get color0072 => Color(0xff0072CF);
  Color get red => Color(0XFFD03D3D);
  Color get grayA0A0 => Color(0XFFA0A0A0);
  Color get grayEE => Color(0XFFEEEEEE);
  Color get grayLite => Color(0XFFededed);
  Color get gray8989 => Color(0XFF898989);
  Color get error => const Color(0XFFff7373);
  Color get f6f6f6 => const Color(0XFFF6F6F6);
  Color get color7D7D => const Color(0XFF7D7D7D);
  Color get color8C8C => const Color(0XFF8C8C8C);
  Color get color7CA => const Color(0XFF7CA0F7);
  Color get colorEA96 => const Color(0XFFEA9633);
  Color get colorE132 => const Color(0XFFE13232);
}