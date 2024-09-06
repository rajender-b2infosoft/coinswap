import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/app_export.dart';


class CustomTextFormField extends StatelessWidget {
  CustomTextFormField(
      {Key? key,
        this.maxlength,
        this.readOnly,
        this.alignment,
        this.width,
        this.height,
        this.scrollPadding,
        this.controller,
        this.focusNode,
        this.autofocus=false,
        this.textStyle,
        this.obscureText=false,
        this.textInputAction = TextInputAction.next,
        this.textInputType = TextInputType.text,
        this.hintText,
        this.label,
        this.labelStyle,
        this.hintStyle,
        this.prefix,
        this.prefixConstraints,
        this.suffix,
        this.suffixConstraints,
        this.contentPadding,
        this.borderDecoration,
        this.focuseDecoration,
        this.fillColors,
        this.cursorColor,
        this.filled=true,
        this.validator,
        this.onChanged,
      }):super(key: key);
  final int? maxlength;
  final bool? readOnly;
  final Alignment? alignment;
  final double? width;
  final double? height;
  final TextEditingController? scrollPadding;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool? autofocus;
  final TextStyle? textStyle;
  final bool? obscureText;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  //final int? maxLines;
  final String? hintText;
  final String? label;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final Widget? prefix;
  final BoxConstraints? prefixConstraints;
  final Widget? suffix;
  final BoxConstraints? suffixConstraints;
  final EdgeInsets? contentPadding;
  final InputBorder? borderDecoration;
  final InputBorder? focuseDecoration;
  final Color? fillColors;
  final Color? cursorColor;
  final bool? filled;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context){
    return alignment != null ? Align(
        alignment: alignment ?? Alignment.center,
        child: textFormFieldWidget(context))
        :textFormFieldWidget(context);
  }

  Widget textFormFieldWidget(BuildContext context) => SizedBox(
    width: width??double.maxFinite,
    height: height??null,
    child: TextFormField(
      maxLength: maxlength,
      readOnly: readOnly??false,
      scrollPadding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom
      ),
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      onTapOutside: (event){
        if(focusNode != null){
          focusNode?.unfocus();
        }else{
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },

      autofocus: autofocus!,
      style: textStyle??CustomTextStyles.titleMediumGray60001,
      obscureText: obscureText!,
      inputFormatters: textInputType == TextInputType.number ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly] : null,
      textInputAction: textInputAction,
      keyboardType: textInputType,
      //maxLength: maxLines,
      decoration: decoration,
      cursorColor: cursorColor,
      validator: validator,
    ),
  );
  InputDecoration get decoration => InputDecoration(
    labelText: label??'',
    labelStyle: labelStyle??TextStyle(),
    hintText: hintText??'',
    hintStyle: hintStyle??theme.textTheme.titleMedium,
    prefixIcon: prefix,
    prefixIconConstraints: prefixConstraints,
    suffixIcon: suffix,
    suffixIconConstraints: suffixConstraints,
    isDense: true,
    contentPadding: contentPadding??EdgeInsets.all(20.h),
    fillColor: fillColors??theme.colorScheme.secondaryContainer,
    filled: filled,
    border: borderDecoration??
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.h),
          borderSide: BorderSide(
            color: appTheme.orange,
            width: 1,
          ),
        ),
    enabledBorder: borderDecoration??
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.h),
          borderSide: BorderSide(
            color: appTheme.orange,
            width: 1,
          ),
        ),
    focusedBorder: focuseDecoration??
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.h),
          borderSide: BorderSide(
            color: appTheme.orange,
            width: 1,
          ),
        ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.h),
      borderSide: BorderSide(
        color: appTheme.error,
        width: 1,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.h),
      borderSide: BorderSide(
        color: appTheme.error,
        width: 2,
      ),
    ),
    errorStyle: TextStyle(
        color: appTheme.error,
        fontSize: 12.fSize
    ),
  );

}