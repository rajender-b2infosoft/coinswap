import 'package:flutter/material.dart';
import '../core/app_export.dart';

class CustomButtonStyle {
  static ButtonStyle get fillOnPrimaryContainer => ElevatedButton.styleFrom(
    backgroundColor: theme.colorScheme.onPrimaryContainer,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.h),
    ),
  );
  static ButtonStyle get fillPrimary => ElevatedButton.styleFrom(
    backgroundColor: theme.colorScheme.primary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.h),
    ),
  );
  static ButtonStyle get none => ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
    elevation: MaterialStateProperty.all<double>(0),
  );
}