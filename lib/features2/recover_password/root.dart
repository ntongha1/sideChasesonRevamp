import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sonalysis/core/models/response/UserResultModel.dart';
import 'package:sonalysis/core/navigation/navigation_service.dart';
import 'package:sonalysis/core/utils/colors.dart';
import 'package:sonalysis/core/utils/validator.dart';
import 'package:sonalysis/core/widgets/app_textfield.dart';
import 'package:sonalysis/core/widgets/button.dart';

import '../../core/navigation/keys.dart';
import '../../core/startup/app_startup.dart';
import '../../core/utils/response_message.dart';
import '../../core/utils/styles.dart';
import '../../core/widgets/appBar/appbarUnauth.dart';
import 'cubit/preset_cubit.dart';

class RecoverPasswordScreen extends StatefulWidget {
  const RecoverPasswordScreen({Key? key}) : super(key: key);

  @override
  _RecoverPasswordScreenState createState() => _RecoverPasswordScreenState();
}

class _RecoverPasswordScreenState extends State<RecoverPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  bool canSubmit = false;
  final _formKey = GlobalKey<FormState>();
  UserResultData? userResultData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarUnauth(),
      backgroundColor: AppColors.sonaWhite,
      body: SingleChildScrollView(
        child: Form(
            key: _formKey,
            onChanged: () {
              setState(() {
                canSubmit = _formKey.currentState!.validate();
              });
            },
            child: Container(
                margin: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Reset your password".tr(),
                      textAlign: TextAlign.center,
                      style: AppStyle.h3.copyWith(
                          color: AppColors.sonaBlack2,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: 60.h),
                    AppTextField(
                      headerText: "email".tr(),
                      hintText: "Type here",
                      validator: Validator.emailValidator,
                      readOnly: false,
                      controller: _emailController,
                      textInputType: TextInputType.emailAddress,
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: AppButton(
                            buttonText: "continue".tr(),
                            onPressed: canSubmit
                                ? () {
                                    _handleSubmitEmail();
                                  }
                                : null)),
                    SizedBox(
                      height: 30.h,
                    ),
                    BlocConsumer(
                      bloc: serviceLocator.get<PasswordResetCubit>(),
                      listener: (_, state) {
                        if (state is ResetEmailLoading) {
                          context.loaderOverlay.show();
                        }

                        if (state is ResetEmailError) {
                          context.loaderOverlay.hide();
                          setState(() {
                            canSubmit = true;
                          });
                          ResponseMessage.showErrorSnack(
                              context: context, message: state.message);
                        }

                        if (state is ResetEmailSuccess) {
                          context.loaderOverlay.hide();
                          canSubmit = false;
                          setState(() {});

                          ResponseMessage.showSuccessSnack(
                              context: context,
                              message:
                                  "OTP successfully sent to your email".tr());
                          serviceLocator.get<NavigationService>().toWithPameter(
                              routeName: RouteKeys.routeOTPScreen,
                              data: {
                                "email":
                                    _emailController.text.toLowerCase().trim(),
                                "routeName": RouteKeys.routeResetPasswordScreen,
                                "sendOTPOnload": false,
                                "pageType": "passwordReset",
                                "successTitle":
                                    "OTP Verified Successfully".tr(),
                                "successSubTitle":
                                    "Proceed to reset your password".tr(),
                              });
                        }
                      },
                      builder: (_, state) {
                        return const SizedBox();
                      },
                    ),
                  ],
                ))),
      ),
    );
  }

  Future<void> _handleSubmitEmail() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    await serviceLocator<PasswordResetCubit>()
        .sendResetEmail(_emailController.text.trim());
  }
}
