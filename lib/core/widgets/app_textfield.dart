import 'package:flutter_svg/flutter_svg.dart';
import 'package:sonalysis/core/utils/colors.dart';
import 'package:sonalysis/core/utils/constants.dart';
import 'package:sonalysis/core/widgets/app_form_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/styles.dart';

class AppTextField extends StatelessWidget {
  final String? initialValue;
  final String? headerText;
  final String? descriptionText;
  final String? hintText;
  final bool obscureText;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final bool readOnly;
  final bool enabled;
  final bool showCountryCode;
  final int lines;
  final int? maxLength;
  final AppTextFieldSize textFieldSize;
  final VoidCallback? onTap;
  final TextInputAction textInputAction;
  final List<TextInputFormatter>? textInputFormatters;
  final TextInputType? textInputType;
  final DescriptionPosition descriptionPosition;

  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmit;
  final TextEditingController? controller;
  final TextEditingController? countryCodeController;

  const AppTextField({
    Key? key,
    this.headerText,
    this.hintText,
    this.obscureText = false,
    this.prefixWidget,
    this.suffixWidget,
    this.readOnly = false,
    this.enabled = true,
    this.showCountryCode = false,
    this.lines = 1,
    this.onTap,
    this.textInputAction = TextInputAction.next,
    this.descriptionPosition = DescriptionPosition.top,
    this.textInputFormatters,
    this.onChanged,
    this.onSubmit,
    this.controller,
    this.maxLength,
    this.countryCodeController,
    this.validator,
    this.textInputType,
    this.descriptionText,
    this.onSaved,
    this.initialValue,
    this.textFieldSize = AppTextFieldSize.normal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        headerText != null
            ? AppLabel(
                headerText: headerText,
                descriptionText: descriptionPosition == DescriptionPosition.top
                    ? descriptionText
                    : null,
              )
            : SizedBox(),
        SizedBox(
          height: headerText != null ? 10 : 0,
        ),
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          initialValue: initialValue,
          minLines: lines,
          maxLines: lines,
          controller: controller,
          textInputAction: textInputAction,
          inputFormatters: textInputFormatters,
          enabled: enabled,
          maxLength: maxLength,
          obscureText: obscureText,
          onChanged: onChanged,
          validator: validator,
          onSaved: onSaved,
          readOnly: readOnly || onTap != null,
          onTap: onTap,
          style: AppStyle.text2.copyWith(
              color: AppColors.sonaBlack2, fontWeight: FontWeight.w400),
          keyboardType: textInputType,
          cursorColor: AppColors.sonaPurple2,
          decoration: InputDecoration(
            errorStyle: const TextStyle(fontSize: 0.01),
            prefixIcon: prefixWidget,
            suffixIcon: suffixWidget,
            suffixIconConstraints: BoxConstraints(
              minHeight: 10.h,
              maxHeight: 20.h,
            ),
            // errorStyle: TextStyle(
            //   fontSize: 12.sp,
            //   fontWeight: FontWeight.w400,
            //   color: AppColors.errorDefault,
            // ),
            hintText: hintText,
            hintStyle: AppStyle.text2.copyWith(
                color: AppColors.sonaGrey2, fontWeight: FontWeight.w400),
            isDense: true,
            filled: true,
            fillColor: enabled
                ? AppColors.sonaGrey6.withOpacity(0.5)
                : AppColors.sonaGrey6,
            // constraints: BoxConstraints(minHeight: 45.h, maxHeight: 45.h),
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.normalRadius),
                borderSide: BorderSide(color: AppColors.sonaGrey6)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.normalRadius),
                borderSide: BorderSide(color: AppColors.sonaGrey6)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.normalRadius),
                borderSide: BorderSide(color: AppColors.sonaGrey6)),
            disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.normalRadius),
                borderSide: BorderSide(color: AppColors.sonaDisabledGrey)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.normalRadius),
                borderSide: BorderSide(color: AppColors.sonalysisMediumPurple)),
          ),
        ),
        SizedBox(height: 4.h),
        if (descriptionPosition == DescriptionPosition.bottom &&
            descriptionText != null)
          Text(
            descriptionText!,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.sonaRed,
              height: 1.33,
            ),
          ),
      ],
    );
  }
}

enum AppTextFieldSize { normal, small }

extension AppTextFieldSizeExt on AppTextFieldSize {
  double get fontSize {
    switch (this) {
      case AppTextFieldSize.normal:
        return 14.sp;
      case AppTextFieldSize.small:
        return 12.sp;
    }
  }
}

enum DescriptionPosition { top, bottom }
