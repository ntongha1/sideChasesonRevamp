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

import '../../../core/navigation/keys.dart';
import '../../../core/startup/app_startup.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/response_message.dart';
import '../../../core/utils/styles.dart';
import '../../../core/widgets/appBar/appbarUnauth.dart';
import '../../../core/widgets/app_password_textfield.dart';
import '../../core/datasource/key.dart';
import '../../core/datasource/local_storage.dart';
import 'cubit/initial_update_profile_cubit.dart';

class InitialUpdateProfileScreen extends StatefulWidget {
  InitialUpdateProfileScreen({Key? key}) : super(key: key);

  @override
  _InitialUpdateProfileScreenState createState() =>
      _InitialUpdateProfileScreenState();
}

class _InitialUpdateProfileScreenState
    extends State<InitialUpdateProfileScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cpasswordController = TextEditingController();
  bool canSubmit = false;
  final _formKey = GlobalKey<FormState>();
  UserResultData? userResultData;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData() async {
    userResultData = (await serviceLocator
        .get<LocalStorage>()
        .readSecureObject(LocalStorageKeys.kUserPrefs))!;
    setState(() {});
  }

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
                  SizedBox(height: 20.h),
                  Text(
                    "Set new password".tr(),
                    textAlign: TextAlign.center,
                    style: AppStyle.h3.copyWith(color: AppColors.sonaBlack2),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    "Fill the following detailss".tr(),
                    textAlign: TextAlign.center,
                    style: AppStyle.text2.copyWith(
                        color: AppColors.sonaBlack2.withOpacity(0.4),
                        fontWeight: FontWeight.w300),
                  ),
                  SizedBox(height: 20.h),
                  AppPasswordTextField(
                    headerText: 'password'.tr(),
                    validator: Validator.passwordValidator,
                    descriptionText: AppConstants.passwordRestriction,
                    textInputAction: TextInputAction.done,
                    onSaved: (val) => _passwordController.text = val!,
                  ),
                  AppPasswordTextField(
                    headerText: 'confirm_password'.tr(),
                    validator: Validator.passwordValidator,
                    //descriptionText: AppConstants.passwordRestriction,
                    textInputAction: TextInputAction.done,
                    onSaved: (val) => _cpasswordController.text = val!,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: AppButton(
                          buttonText: "set_password".tr(),
                          onPressed: canSubmit
                              ? () {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    _handlePasswordReset();
                                  }
                                }
                              : null)),
                  BlocConsumer(
                    bloc: serviceLocator.get<InitialUpdateProfileCubit>(),
                    listener: (_, state) {
                      if (state is PasswordResetLoading) {
                        context.loaderOverlay.show();
                      }

                      if (state is PasswordResetError) {
                        context.loaderOverlay.hide();
                        setState(() {
                          canSubmit = true;
                        });
                        ResponseMessage.showErrorSnack(
                            context: context, message: state.message);
                      }

                      if (state is PasswordResetSuccess) {
                        context.loaderOverlay.hide();
                        //show dialog page
                        serviceLocator.get<NavigationService>().toWithPameter(
                            routeName: RouteKeys.routePopUpPageScreen,
                            data: {
                              "title": "password_updated".tr(),
                              "subTitle":
                                  "your_password_has_been_updated2".tr(),
                              "route":
                                  RouteKeys.routeInitialUpdateProfileScreen2,
                              "routeType": "ClearAll",
                              "buttonText": "okay_thank_you".tr()
                            }).then((value) {
                          setState(() {});
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
      ),
    );
  }

  Future<void> _handlePasswordReset() async {
    // if (_passwordController.text == _cpasswordController.text) {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    await serviceLocator<InitialUpdateProfileCubit>().changeUserPassword(
        _passwordController.text.trim(), userResultData!.user!.id);
    // } else {
    //   ResponseMessage.showErrorSnack(context: context, message: "password_not_the_same".tr());
    // }
  }
}
