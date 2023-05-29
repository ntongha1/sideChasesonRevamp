import 'package:another_flushbar/flushbar.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonalysis/core/utils/colors.dart';

class ResponseMessage {
  static void showErrorSnack({
    required BuildContext context,
    required String message,
  }) {
    _showSnack(context, message, AppColors.errorDefault.withOpacity(.9));
  }

  static void showSuccessSnack({
    required BuildContext context,
    required String message,
  }) {
    _showSnack(context, message, const Color(0xFF4ECB71));
  }

  static void _showSnack(BuildContext context, String message, Color color) {
    Flushbar(
      // flushbarStyle: FlushbarStyle.FLOATING,
      flushbarPosition: FlushbarPosition.TOP,

      backgroundColor: color,
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 22.w),
      messageText: Text(
        message,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
          color: Colors.white,
          height: 1,
        ),
      ),
      duration: const Duration(seconds: 5),
    ).show(context);
  }
}
