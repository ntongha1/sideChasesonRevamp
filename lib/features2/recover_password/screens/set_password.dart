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
import 'package:sonalysis/core/widgets/button.dart';
import 'package:sonalysis/core/widgets/popup_screen.dart';

import '../../../core/navigation/keys.dart';
import '../../../core/startup/app_startup.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/response_message.dart';
import '../../../core/utils/styles.dart';
import '../../../core/widgets/appBar/appbarUnauth.dart';
import '../../../core/widgets/app_password_textfield.dart';
import '../cubit/preset_cubit.dart';

class SetPasswordScreen extends StatefulWidget {
  SetPasswordScreen({Key? key, required this.data}) : super(key: key);

  Map? data;
  @override
  _SetPasswordScreenState createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cpasswordController = TextEditingController();
  bool canSubmit = false;
  final _formKey = GlobalKey<FormState>();
  UserResultData? userResultData;
  bool showSuccess = false;

  @override
  void initState() {
    // TODO: implement initState

    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
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
                    margin:
                        EdgeInsets.symmetric(vertical: 40.h, horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Set new password".tr(),
                          style: AppStyle.h3.copyWith(
                              color: AppColors.sonaBlack2,
                              fontWeight: FontWeight.w400),
                        ).tr(),
                        SizedBox(height: 10.h),
                        Text(
                          "Fill the following details".tr(),
                          textAlign: TextAlign.center,
                          style: AppStyle.text2.copyWith(
                              color: AppColors.sonaGrey2,
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          height: 40.h,
                        ),
                        AppPasswordTextField(
                          initialValue: _passwordController.text,
                          headerText: 'New password'.tr(),
                          validator: Validator.passwordValidator,
                          hintText: "Type here",
                          descriptionText:
                              (Validator.passwordValidator("") == null ||
                                      Validator.passwordValidator("") ==
                                          "Invalid password")
                                  ? ""
                                  : AppConstants.passwordRestriction,
                          textInputAction: TextInputAction.done,
                          onSaved: (val) => _passwordController.text = val!,
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        AppPasswordTextField(
                          initialValue: _cpasswordController.text,
                          headerText: 'confirm_password'.tr(),
                          hintText: "Type here",
                          validator: Validator.passwordValidator,
                          //descriptionText: AppConstants.passwordRestriction,
                          textInputAction: TextInputAction.done,
                          onSaved: (val) => _cpasswordController.text = val!,
                        ),
                        SizedBox(
                          height: 40.h,
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: AppButton(
                                buttonText: "Continue".tr(),
                                onPressed: !canSubmit
                                    ? null
                                    : () {
                                        context.loaderOverlay.hide();

                                        if (_cpasswordController.text !=
                                            _passwordController.text) {
                                          ResponseMessage.showErrorSnack(
                                              context: context,
                                              message:
                                                  "Password does not match");
                                          return;
                                        }
                                        //show dialog page
                                        context.loaderOverlay.hide();
                                        _handleResetPassword();
                                        // setState(() {
                                        //   showSuccess = true;
                                        // });
                                      })),
                        BlocConsumer(
                          bloc: serviceLocator.get<PasswordResetCubit>(),
                          listener: (_, state) {
                            if (state is ResetPasswordLoading) {
                              context.loaderOverlay.show();
                            }

                            if (state is ResetPasswordError) {
                              context.loaderOverlay.hide();
                              setState(() {
                                canSubmit = true;
                              });
                              ResponseMessage.showErrorSnack(
                                  context: context, message: state.message);
                            }

                            if (state is ResetPasswordSuccess) {
                              context.loaderOverlay.hide();
                              setState(() {
                                showSuccess = true;
                              });
                            }
                          },
                          builder: (_, state) {
                            return const SizedBox();
                          },
                        ),
                      ],
                    ),
                  )),
            )),
        Positioned(
            child: showSuccess
                ? PopUpPageScreen(data: {
                    "title": "Password created successfully".tr(),
                    "subTitle": "your_password_has_been_updated".tr(),
                    "route": RouteKeys.routeInitialUpdateProfileScreen3,
                    "routeType": "ClearAll",
                    "buttonText": "okay_thank_you".tr()
                  })
                : Container())
      ],
    );
  }

  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    await serviceLocator<PasswordResetCubit>().doResetPassword(
        widget.data!["email"], _passwordController.text.toString());
  }
}
