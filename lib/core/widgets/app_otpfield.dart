import 'package:sonalysis/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class AppOtpField extends StatelessWidget {
  final int length;
  final double tokenWidth;
  final double tokenHeight;
  final double fontSize;
  final Function(String) onChanged;
  final Function(String) onCompleted;
  final TextEditingController? controller;
  const AppOtpField({
    Key? key,
    required this.tokenWidth,
    required this.fontSize,
    required this.length,
    required this.onChanged,
    required this.onCompleted,
    this.controller,
    required this.tokenHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      length: length,
      controller: controller,
      showCursor: false,
      obscureText: false,
      animationType: AnimationType.fade,
      textStyle: _valueTextStyle,
      hintCharacter: '0',
      keyboardType: TextInputType.number,
      mainAxisAlignment: MainAxisAlignment.center,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      hintStyle: _hintTextStyle,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        fieldHeight: tokenHeight,
        fieldWidth: tokenWidth,
        borderWidth: 1,
        borderRadius: BorderRadius.circular(4.r),
        activeFillColor: Colors.transparent,
        selectedFillColor: Colors.transparent,
        activeColor: AppColors.innerBorder,
        selectedColor: AppColors.innerBorder,
        inactiveColor: AppColors.innerBorder,
        inactiveFillColor: Colors.transparent,
        fieldOuterPadding: EdgeInsets.symmetric(horizontal: 6.5.w),
      ),
      animationDuration: const Duration(milliseconds: 500),
      enableActiveFill: true,
      onCompleted: onCompleted,
      onChanged: onChanged,
      beforeTextPaste: (text) {
        return true;
      },
    );
  }
}

final TextStyle _hintTextStyle = TextStyle(
  fontSize: 36.sp,
  height: 1,
  fontWeight: FontWeight.w500,
  color: AppColors.placeHolder,
);
final TextStyle _valueTextStyle = TextStyle(
  fontSize: 36.sp,
  height: 1,
  fontWeight: FontWeight.w800,
  color: AppColors.titleActive,
);
