import 'package:flutter/material.dart';
import '../core/app_export.dart';

class AppDecoration{
  //Fill decoration
  static BoxDecoration get fillOnPrimaryContainer => BoxDecoration(
    color: theme.colorScheme.onPrimaryContainer,
  );
  //Gradient decoration
  static BoxDecoration get gradientCyanToBlue => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment(0,0.06),
      end: Alignment(1, 0.06),
      colors: [appTheme.main, appTheme.white],
    ),
  );
  static BoxDecoration get gradientLightBlueToBlue => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment(0,0.5),
      end: Alignment(1, 0.5),
      colors: [appTheme.main, appTheme.white],
    ),
  );
 //outline decoration
  static BoxDecoration get outlineBlack => BoxDecoration(
    color: theme.colorScheme.onPrimaryContainer,
    boxShadow: [
    BoxShadow(
      color: appTheme.main.withOpacity(0.65),
      spreadRadius: 2.h,
      blurRadius: 2.h,
        offset: Offset(0, 4)
    ),
    ]
  );

  static BoxDecoration get outlineOrangA => BoxDecoration(
    color: theme.colorScheme.secondaryContainer,
    border: Border.all(
      color: appTheme.main,
      width: 1.h,
    ),
  );

}

class BorderRadiusStyle {
  //custom border
  static BorderRadius get customBorderBR34  => BorderRadius.only(
    topLeft: Radius.circular(20.h),
    bottomRight: Radius.circular(34.4),
  );

  static BorderRadius get customBorderTL20  => BorderRadius.horizontal(
    left: Radius.circular(20.h),
  );

  static BorderRadius get customBorderTL50  => BorderRadius.vertical(
    top: Radius.circular(50.h),
  );

  static BorderRadius get roundedBorder10  => BorderRadius.circular(10.h );

}