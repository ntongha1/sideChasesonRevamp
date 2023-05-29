import 'dart:async';
import 'package:sonalysis/core/utils/colors.dart';
import 'package:sonalysis/core/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_otpfield.dart';
import 'button.dart';
import 'otp_timer.dart';

class TokenScreen extends StatefulWidget {
  final int tokenLength;
  final ValueChanged<String> onCompleted;
  final ValueChanged<String> onSubmit;
  final Function() onResetCode;
  // final bool got;
  final bool resetCode;

  /// title and subtitle
  final Widget titleWidget;
  const TokenScreen({
    Key? key,
    required this.onSubmit,
    required this.tokenLength,
    required this.onCompleted,
    required this.onResetCode,
    required this.titleWidget,
    // required this.got,
    this.resetCode = false,
  }) : super(key: key);

  @override
  State<TokenScreen> createState() => _TokenScreenState();
}

class _TokenScreenState extends State<TokenScreen>
    with TickerProviderStateMixin {
  int endTime = 0;
  bool tokenValid = false;
  bool canResend = false;
  // int endTime = 0;
  final int time = AppConstants.timerTime;
  Timer? timer;
  late int totalTimeInSeconds;
  bool hideResendButton = true;
  String _token = '';
  // bool hasGottenResponse = false;

  late AnimationController _animationController;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: time))
          ..addStatusListener((status) {
            if (status == AnimationStatus.dismissed) {
              setState(() {
                hideResendButton = !hideResendButton;
              });
            }
          });
    _animationController.reverse(
        from: _animationController.value == 0.0
            ? 1.0
            : _animationController.value);
    _startCountdown();
    super.initState();
  }

  @override
  void dispose() {
    // _controller.dispose();
    timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if (widget.got) {
    //   _startCountdown();
    // }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.h),
        widget.titleWidget,
        SizedBox(height: 48.h),
        AppOtpField(
          controller: _controller,
          length: widget.tokenLength,
          tokenWidth: 38.w,
          tokenHeight: 67.h,
          onChanged: (v) {
            _token = v;
            setState(() {});
          },
          onCompleted: (v) {
            _token = v;
            setState(() {});
          },
          fontSize: 20.sp,
        ),
        SizedBox(height: 30.h),
        Center(child: OtpTimer(controller: _animationController)),
        SizedBox(height: 26.h),
        // const AppError(error: "Invalid verification code, retry"),

        AppButton(
          buttonText: 'Submit',
          onPressed: _token.length < widget.tokenLength
              ? null
              : !hideResendButton
                  ? null
                  : _token.length == widget.tokenLength
                      ? () {
                          widget.onSubmit(_token);
                        }
                      : null,
        ),
        SizedBox(height: 25.h),
        Text(
          "Didn't see a verification code?",
          style: TextStyle(
            color: const Color(0xFF242F40),
            fontWeight: FontWeight.w400,
            fontSize: 16.sp,
          ),
        ),
        SizedBox(height: 7.h),
        TextButton(
          onPressed: () async {
            if (hideResendButton) return;
            _controller.clear();
            await widget.onResetCode();
            _startCountdown();
          },
          child: Text(
            "Resend Code",
            style: TextStyle(
              color: hideResendButton
                  ? AppColors.primaryActive.withOpacity(0.5)
                  : AppColors.primaryActive,
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }

  Future _startCountdown() async {
    setState(() {
      hideResendButton = true;
      totalTimeInSeconds = time;
    });
    _animationController.reverse(
      from:
          _animationController.value == 0.0 ? 1.0 : _animationController.value,
    );
  }
}
