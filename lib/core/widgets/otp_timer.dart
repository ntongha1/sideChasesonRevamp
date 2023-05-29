import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/colors.dart';

class OtpTimer extends StatelessWidget {
  final AnimationController controller;

  const OtpTimer({Key? key, required this.controller}) : super(key: key);

  String get timerString {
    Duration duration = controller.duration! * controller.value;
    if (duration.inHours > 0) {
      return '${duration.inHours}:${duration.inMinutes % 60}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
    }
    return '${duration.inMinutes % 60}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  Duration? get duration {
    Duration? duration = controller.duration;
    return duration;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget? child) {
        return RichText(
          text: TextSpan(
              text:
                  timerString == "0:00" ? "Code Expired " : 'Code Expires in  ',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.sonaBlack2,
                height: 1.37,
              ),
              children: [
                TextSpan(
                  text: timerString == "0:00" ? "" : timerString,
                  style: TextStyle(
                    color: AppColors.sonalysisMediumPurple,
                  ),
                ),
              ]),
        );
      },
    );
  }
}
