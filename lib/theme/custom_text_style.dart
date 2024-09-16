import 'package:flutter/material.dart';
import '../core/app_export.dart';

extension on TextStyle {
  TextStyle get poppins {
    return copyWith(
      fontFamily: 'Poppins',
    );
  }
}

class CustomTextStyles {
  static get pageTitleMain=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.mainTitle,
    fontFamily: 'Raleway',
    fontSize: 27,
    fontWeight: FontWeight.w400,
  );
  static get pageTitleMain25=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.mainTitle,
    fontFamily: 'Raleway',
    fontSize: 25,
    fontWeight: FontWeight.w400,
  );
  static get gray12=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.gray,
    fontSize: 12,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
  );
  static get gray17=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.gray8989,
    fontSize: 17,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
  );
  static get white18=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.white,
    fontSize: 18,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w300,
  );
  static get gray7D7D_11=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.gray,
    fontSize: 11,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
  );
  static get gray11=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.gray,
    fontSize: 11,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
  );
  static get main28=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.main,
    fontSize: 28,
    fontFamily: 'Raleway',
    fontWeight: FontWeight.w400,
  );
  static get gray14=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.gray,
    fontSize: 14,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
  );
  static get main18=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.main,
    fontSize: 18,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w300,
  );
  static get main18_400=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.color036,
    fontSize: 18,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
  );
  static get title27_400=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.white,
    fontFamily: 'Raleway',
    fontSize: 27,
    fontWeight: FontWeight.w400,
  );
  static get white23=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.blueLight,
    fontSize: 23,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w300,
  );
  static get white30=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.white,
    fontSize: 30,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w300,
  );
  static get white20=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.blueLight,
    fontSize: 20,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w300,
  );
  static get white17=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.white,
    fontSize: 17,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w300,
  );
  static get gray7272_17=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.gray7272,
    fontFamily: 'Poppins',
    fontSize: 17,
    fontWeight: FontWeight.w400,
  );
  static get size10_7272=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.gray7272,
    fontSize: 10,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
  );
  static get gray8_7272=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.gray7272,
    fontSize: 8,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
  );
  static get orange11=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.orange,
    fontSize: 11,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
  );
  static get orange12=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.orange,
    fontSize: 12,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
  );
  static get red11=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.red,
    fontSize: 11,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
  );
  static get gray7272_13=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.gray7272,
    fontFamily: 'Poppins',
    fontSize: 13,
    fontWeight: FontWeight.w400,
  );
  static get grayA0A0_12=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.grayA0A0,
    fontFamily: 'Poppins',
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );
  static get gray7272_12=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.gray7272,
    fontFamily: 'Poppins',
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );
  static get gray7272_19=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.gray7272,
    fontFamily: 'Poppins',
    fontSize: 19,
    fontWeight: FontWeight.w400,
  );
  static get main14=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.main,
    fontSize: 14,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
  );
  static get gray7272_16=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.gray7272,
    fontFamily: 'Poppins',
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );
  static get color9898_13=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.color9898,
    fontFamily: 'Poppins',
    fontSize: 13,
    fontWeight: FontWeight.w400,
  );
  static get color549FE3_17=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.color549FE3,
    fontFamily: 'Poppins',
    fontSize: 17,
    fontWeight: FontWeight.w400,
  );
  static get gray7272_14=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.gray7272,
    fontFamily: 'Poppins',
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
  static get size8C8C_10=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.color8C8C,
    fontSize: 10,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
  );
  static get size8C8C_12=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.color9898,
    fontSize: 12,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
  );
  static get main24=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.main,
    fontSize: 24,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w300,
  );
  static get main22=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.main,
    fontSize: 22,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
  );
  static get sideBarGray=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.color858585,
    fontFamily: 'Raleway',
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
  static get sideBarWhite=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.white,
    fontFamily: 'Raleway',
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
  static get color0072D_16=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.color0072D,
    fontSize: 16,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
  );
  static get color0071D0_20=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.main,
    fontSize: 20,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
  );
  static get green16=> theme.textTheme.titleMedium!.copyWith(
      color: appTheme.green,
      fontSize: 16,
      fontFamily: 'Poppins'
  );
  static get color5E8DF7_16=> theme.textTheme.titleMedium!.copyWith(
      color: appTheme.color5E8DF7,
      fontSize: 16,
      fontFamily: 'Poppins'
  );
  static get color0072D_20=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.color0072D,
    fontSize: 20,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
  );
  static get color9898_18=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.color9898,
    fontFamily: 'Poppins',
    fontSize: 18,
    fontWeight: FontWeight.w400,
  );
  static get color0071=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.color0071,
    fontSize: 14,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
  );



  static get white21=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.white,
    fontSize: 18,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w300,
  );
  static get pageTitle25=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.mainTitle,
    fontFamily: 'Raleway',
    fontSize: 25,
    fontWeight: FontWeight.w400,
  );
  static get gray16=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.gray,
    fontSize: 16,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
  );
  static get gray7D7D_13=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.gray,
    fontSize: 13,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
  );

  static get gray13=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.gray,
    fontSize: 13,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
  );
  static get main13=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.main,
    fontSize: 13,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
  );

  static get gray19=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.gray8989,
    fontSize: 19,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
  );

  static get main21=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.main,
    fontSize: 18,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w300,
  );
  static get main20=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.main,
    fontSize: 20,
    fontFamily: 'Raleway',
    fontWeight: FontWeight.w200,
  );

  static get gray10=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.gray,
    fontSize: 10,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
  );
  static get size12_7272=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.gray7272,
    fontSize: 12,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
  );

  static get titleMediumGray60001=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.gray,
    fontFamily: 'Poppins',
  );

  static get main27=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.main,
    fontSize: 27,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
  );



  static get titleMediumMain=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.white,
    fontFamily: 'Raleway',
    fontSize: 30,
    fontWeight: FontWeight.w500,
  );
  static get title30_400=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.white,
    fontFamily: 'Raleway',
    fontSize: 30,
    fontWeight: FontWeight.w400,
  );

  static get gray25=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.gray,
    fontFamily: 'Poppins',
    fontSize: 25,
    fontWeight: FontWeight.w500,
  );
  static get gray7272_18=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.gray7272,
    fontFamily: 'Poppins',
    fontSize: 18,
    fontWeight: FontWeight.w400,
  );
  static get color9898_15=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.color9898,
    fontFamily: 'Poppins',
    fontSize: 15,
    fontWeight: FontWeight.w400,
  );
  static get gray7272_15=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.gray7272,
    fontFamily: 'Poppins',
    fontSize: 15,
    fontWeight: FontWeight.w400,
  );
  static get grayA0A0_14=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.grayA0A0,
    fontFamily: 'Poppins',
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
  static get gray7272_21=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.gray7272,
    fontFamily: 'Poppins',
    fontSize: 21,
    fontWeight: FontWeight.w300,
  );

  static get titleMediumGray=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.gray,
  );


  static get green19=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.green,
    fontSize: 19,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
  );
  static get orange16=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.orange,
    fontSize: 16,
    fontFamily: 'Poppins'
  );
  static get orange14=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.orange,
    fontSize: 14,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
  );
  static get green14=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.green,
    fontSize: 14,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
  );
  static get color7CA_14=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.color7CA,
    fontSize: 14,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
  );
  static get gray18=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.gray,
    fontSize: 18,
    fontFamily: 'Poppins'
  );
  static get gray18_color747474=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.color747474,
    fontSize: 18,
    fontFamily: 'Poppins',
  );
  static get main_20=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.main,
    fontSize: 20,
    fontFamily: 'Poppins'
  );
  static get main16=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.main,
    fontSize: 16,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
  );
  static get main19=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.main,
    fontSize: 19,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
  );
  static get main17=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.main,
    fontSize: 17,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
  );
  static get blue15=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.blueDark,
    fontSize: 15,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
  );
  static get blue17=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.blueDark,
    fontSize: 17,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
  );
  static get blue24_300=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.color0072,
    fontSize: 24,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
  );

  static get white19=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.white,
    fontSize: 19,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w300,
  );

  static get white17_400=> theme.textTheme.titleMedium!.copyWith(
    color: appTheme.white,
    fontSize: 17,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
  );

  static get headlineMediumRegular=> theme.textTheme.headlineMedium!.copyWith(
    fontWeight: FontWeight.w400,
    fontSize: 24,
    fontFamily: 'Poppins',
  );




  static get displayMediumPrimary => theme.textTheme.displayMedium!.copyWith(
    color: theme.colorScheme.primary,
    fontWeight: FontWeight.w700,
  );

  static get displaySmallPrimary => theme.textTheme.displaySmall!.copyWith(
    color: theme.colorScheme.primary,
    fontSize: 38.fSize,
    fontWeight: FontWeight.w700,
  );
  static get headlineLargePrimary => theme.textTheme.headlineLarge!.copyWith(
    color: theme.colorScheme.primary,
  );
  static get headlineLargePrimary_1 => theme.textTheme.headlineLarge!.copyWith(
    color: theme.colorScheme.primary,
  );
  static get headlineMediumGray600 => theme.textTheme.headlineMedium!.copyWith(
    color: appTheme.main,
    fontWeight: FontWeight.w300,
  );
  static get headlineMediumLight=> theme.textTheme.headlineMedium!.copyWith(
    fontWeight: FontWeight.w300,
  );
  static get headlineMediumOnPrimary=> theme.textTheme.headlineMedium!.copyWith(
    color: theme.colorScheme.onPrimary,
    fontWeight: FontWeight.w600,
  );
  static get headlineMediumOnPrimaryBold=> theme.textTheme.headlineMedium!.copyWith(
    color: theme.colorScheme.onPrimary,
    fontWeight: FontWeight.w600,
  );



}