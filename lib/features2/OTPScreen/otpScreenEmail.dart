import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:sonalysis/core/models/response/UserResultModel.dart';
import 'package:sonalysis/core/utils/colors.dart';
import 'package:sonalysis/core/utils/styles.dart';
import 'package:sonalysis/core/widgets/app_gradient_text.dart';
import 'package:sonalysis/core/widgets/popup_screen.dart';

import '../../../core/widgets/button.dart';
import '../../core/startup/app_startup.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/response_message.dart';
import '../../core/widgets/GradientProgressBar.dart';
import '../../core/widgets/appBar/appbarUnauth.dart';
import '../../core/widgets/otp_timer.dart';
import '../signup/cubit/signup_cubit.dart';

class OTPScreenEmail extends StatefulWidget {
  OTPScreenEmail({Key? key, required this.data}) : super(key: key);

  Map? data;

  @override
  _OTPScreenEmailState createState() => _OTPScreenEmailState();
}

class _OTPScreenEmailState extends State<OTPScreenEmail>
    with TickerProviderStateMixin {
  bool? canSubmit = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();
  late AnimationController _animationController;
  bool hideResendButton = true;
  final int time = AppConstants.timerTime;
  late int totalTimeInSeconds;
  bool showSuccess = false;
  UserResultData? userResultData;
  String? deviceToken;

  @override
  void initState() {
    super.initState();
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
    _getData();
  }

  Future<void> _getData() async {
    if (widget.data!["sendOTPOnload"]) {
      await serviceLocator<SignupCubit>()
          .sendOTPTOEmailNewFlow(widget.data!["email"]!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBarUnauth(),
          backgroundColor: AppColors.sonaWhite,
          body: Container(
            margin: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
            child: Form(
                key: _formKey,
                onChanged: () {
                  setState(() {
                    canSubmit = _formKey.currentState!.validate();
                  });
                },
                child: ListView(
                  children: [
                    widget.data!["pageType"] == "clubRegistration"
                        ? Text(
                            "Create account count"
                                .tr(namedArgs: {"this": "2", "that": "5"}),
                            textAlign: TextAlign.left,
                            style: AppStyle.text2.copyWith(
                                color: AppColors.sonaGrey2,
                                fontWeight: FontWeight.w400),
                          )
                        : SizedBox.shrink(),
                    widget.data!["pageType"] == "clubRegistration"
                        ? SizedBox(height: 10.h)
                        : SizedBox.shrink(),
                    widget.data!["pageType"] == "clubRegistration"
                        ? GradientProgressBar(
                            percent: 40,
                            gradient: AppColors.sonalysisGradient,
                            backgroundColor: AppColors.sonaGrey6,
                          )
                        : SizedBox.shrink(),
                    SizedBox(height: 20.h),
                    Text(
                      "Verify email address".tr(),
                      textAlign: TextAlign.center,
                      style: AppStyle.h3.copyWith(
                          color: AppColors.sonaBlack2,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      "Enter OTP sent to ".tr() +
                          widget.data!["email"]!.toString(),
                      textAlign: TextAlign.center,
                      style: AppStyle.text2.copyWith(
                          color: AppColors.sonaGrey2,
                          fontWeight: FontWeight.w400),
                    ).tr(),
                    SizedBox(height: 40.h),
                    OTPTextField(
                      otpFieldStyle: OtpFieldStyle(
                        enabledBorderColor: AppColors.sonaGrey5,
                        disabledBorderColor:
                            AppColors.sonaGrey5.withOpacity(0.4),
                        focusBorderColor: AppColors.sonaGrey3.withOpacity(0.4),
                        backgroundColor: Colors.transparent,
                        errorBorderColor: Colors.red,
                      ),
                      length: 6,
                      width: 360,
                      fieldWidth: 50,
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                      style: AppStyle.text2.copyWith(
                          color: AppColors.sonaBlack2,
                          fontWeight: FontWeight.w800),
                      keyboardType: TextInputType.number,
                      textFieldAlignment: MainAxisAlignment.spaceEvenly,
                      fieldStyle: FieldStyle.box,
                      onChanged: (pin) {
                        if (pin.length == 6) {
                          canSubmit = true;
                        } else {
                          canSubmit = false;
                        }
                        setState(() {});
                      },
                      onCompleted: (pin) {
                        //print("Completed: " + pin);
                        _otpController.text = pin;
                        //do submit
                        canSubmit = true;
                        setState(() {});
                      },
                    ),
                    SizedBox(height: 23.h),
                    Center(child: OtpTimer(controller: _animationController)),
                    Center(
                      child: TextButton(
                        onPressed: () async {
                          if (hideResendButton) return;
                          _otpController.clear();
                          _sendOTP();
                          _startCountdown();
                        },
                        child: GradientText(
                          "Resend Code",
                          gradient: AppColors.sonalysisGradient,
                          style: AppStyle.text2.copyWith(),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 60.h,
                    ),
                    AppButton(
                        buttonText: "continue".tr(),
                        onPressed: canSubmit!
                            ? () {
                                _verifyOTP();
                              }
                            : null),
                    BlocConsumer(
                      bloc: serviceLocator.get<SignupCubit>(),
                      listener: (_, state) {
                        if (state is VerifyOTPLoading ||
                            state is SendOTPTOEmailLoading) {
                          context.loaderOverlay.show();
                        }

                        if (state is VerifyOTPError) {
                          context.loaderOverlay.hide();
                          setState(() {
                            canSubmit = true;
                          });
                          ResponseMessage.showErrorSnack(
                              context: context, message: state.message);
                        }

                        if (state is SendOTPTOEmailError) {
                          context.loaderOverlay.hide();
                          ResponseMessage.showErrorSnack(
                              context: context, message: state.message);
                        }

                        if (state is SendOTPTOEmailSuccess) {
                          context.loaderOverlay.hide();
                          ResponseMessage.showSuccessSnack(
                              context: context,
                              message: "Check your email for OTP!");
                        }

                        if (state is VerifyOTPSuccess) {
                          context.loaderOverlay.hide();

                          setState(() {
                            showSuccess = true;
                          });
                        }
                      },
                      builder: (_, state) {
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                )),
          ),
        ),
        Positioned(
            child: showSuccess
                ? PopUpPageScreen(data: {
                    "title": widget.data!["successTitle"]!,
                    "subTitle": widget.data!["successSubTitle"]!,
                    "route": widget.data!["routeName"],
                    "routeData": {
                      "email": widget.data!["email"],
                    },
                    "routeType": "ClearAll",
                    "buttonText": "continue".tr()
                  })
                : Container())
      ],
    );
  }

  Future<void> _sendOTP() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    await serviceLocator<SignupCubit>().sendOTPTOEmail(widget.data!["email"]!);
  }

  Future<void> _verifyOTP() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    await serviceLocator<SignupCubit>().verifyOTPEmailNewFlow(
        _otpController.text.trim(), widget.data!["email"]!);
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
