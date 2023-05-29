import 'dart:async';

import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sonalysis/core/navigation/keys.dart';
import 'package:sonalysis/core/navigation/navigation_service.dart';
import 'package:sonalysis/core/startup/app_startup.dart';
import 'package:sonalysis/core/utils/colors.dart';
import 'package:sonalysis/core/utils/response_message.dart';
import 'package:sonalysis/core/utils/validator.dart';
import 'package:sonalysis/core/widgets/app_datefield.dart';
import 'package:sonalysis/core/widgets/app_gradient_text.dart';
import 'package:sonalysis/core/widgets/app_textfield.dart';
import 'package:sonalysis/core/widgets/button.dart';
import 'package:sonalysis/core/widgets/popup_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/utils/helpers.dart';
import '../../../core/utils/styles.dart';
import '../../../core/widgets/appBar/appbarUnauth.dart';
import '../cubit/signup_cubit.dart';
import '../models/EmailExistModel.dart';

class CreatePlayerCoachAccount extends StatefulWidget {
  const CreatePlayerCoachAccount({Key? key}) : super(key: key);

  @override
  _CreatePlayerCoachAccountState createState() =>
      _CreatePlayerCoachAccountState();
}

class _CreatePlayerCoachAccountState extends State<CreatePlayerCoachAccount> {
  final TextEditingController _oFirstNameController = TextEditingController();
  final TextEditingController _oLastNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _linkToBioController = TextEditingController();

  bool canSubmit = false, checkEmailLoader = false, emailExists = false;
  bool acceptTerms = false, joinNewsUpdates = false;

  EmailExistModel? emailExistModel;
  final _formKey = GlobalKey<FormState>();
  bool showSuccess = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBarUnauth(),
          backgroundColor: AppColors.sonaWhite,
          body: Container(
              margin: EdgeInsets.only(left: 20.w, right: 20.w, top: 40.h),
              child: Form(
                key: _formKey,
                onChanged: () {
                  setState(() {
                    canSubmit = _formKey.currentState!.validate();
                  });
                },
                child: ListView(
                  children: [
                    Text(
                      "Let’s get you started".tr(),
                      textAlign: TextAlign.center,
                      style: AppStyle.h3.copyWith(
                          color: AppColors.sonaBlack2,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      "Fill the following details".tr(),
                      textAlign: TextAlign.center,
                      style: AppStyle.text2.copyWith(
                          color: AppColors.sonaGrey2,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: 40.h),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.43,
                            child: AppTextField(
                              headerText: "first_name".tr() + "*",
                              hintText: "Type here".tr(),
                              validator: Validator.firstnameValidator,
                              onChanged: (val) =>
                                  _oFirstNameController.text = val,
                              textInputType: TextInputType.name,
                              textInputFormatters: [
                                LengthLimitingTextInputFormatter(10),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.43,
                            child: AppTextField(
                              headerText: "last_name".tr() + "*",
                              hintText: "Type here".tr(),
                              validator: Validator.lastnameValidator,
                              textInputType: TextInputType.name,
                              textInputFormatters: [
                                LengthLimitingTextInputFormatter(10),
                              ],
                              onChanged: (val) =>
                                  _oLastNameController.text = val,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.43,
                              child: AppDateField(
                                headerText: "date_of_birth".tr() + "*",
                                hintText: "Type here".tr(),
                                onChanged: (DateTime value) {
                                  _dobController.text =
                                      DateFormat('yyyy-MM-dd').format(value);
                                  setState(() {
                                    _ageController.text =
                                        calculateAge(value).toString();
                                    print(calculateAge(value).toString());
                                  });
                                },
                                validator: Validator.requiredValidator,
                              )),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.43,
                            child: AppTextField(
                              headerText: "age".tr() + "*",
                              hintText: "Type here".tr(),
                              controller: _ageController,
                              readOnly: true,
                              validator: Validator.validateAge,
                              textInputType: TextInputType.number,
                              textInputFormatters: [
                                LengthLimitingTextInputFormatter(10),
                              ],
                              onChanged: (val) => _ageController.text = val,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Focus(
                      child: AppTextField(
                        headerText: "email".tr() + "*",
                        hintText: "Type here".tr(),
                        descriptionText: emailExists
                            ? "This email already exist, please try another!"
                                .tr()
                            : "",
                        validator: Validator.emailValidator,
                        readOnly: false,
                        suffixWidget: checkEmailLoader
                            ? Container(
                                height: 20,
                                width: 20,
                                margin: EdgeInsets.only(right: 10),
                                child: CircularProgressIndicator(
                                  color: AppColors.sonalysisMediumPurple,
                                  strokeWidth: 2,
                                ),
                              )
                            : SizedBox.shrink(),
                        textInputType: TextInputType.emailAddress,
                        onChanged: (val) => _emailController.text = val,
                      ),
                      onFocusChange: (hasFocus) {
                        //print(hasFocus.toString());
                        if (!hasFocus && validateEmail(_emailController.text)) {
                          checkEmailLoader = true;
                          _handleDoesUserExistEmailVerify();
                        } else {
                          checkEmailLoader = false;
                        }
                        setState(() {});
                      },
                    ),
                    SizedBox(height: 20.h),
                    AppTextField(
                      headerText: "country".tr() + "*",
                      hintText: "Type here".tr(),
                      validator: Validator.requiredValidator,
                      readOnly: true,
                      controller: _countryController,
                      suffixWidget: Container(
                          width: 20.w,
                          height: 20.h,
                          margin: EdgeInsets.only(right: 20),
                          child: SvgPicture.asset('assets/svgs/drop_grey.svg')),
                      onTap: () {
                        showCountryPicker(
                            context: context,
                            showPhoneCode: false,
                            countryListTheme: countryListThemeData(),
                            onSelect: (Country country) {
                              setState(() {
                                _countryController.text = country
                                    .displayNameNoCountryCode
                                    .trim()
                                    .replaceAll(RegExp(' \\(.*?\\)'), '');
                              });
                              //print("Selected country: ${country.displayName}");
                            });
                      },
                      textInputType: TextInputType.name,
                      onChanged: (val) => _countryController.text = val,
                    ),
                    SizedBox(height: 20.h),
                    AppTextField(
                      headerText: "link_to_portfolio".tr(),
                      hintText: "Type here".tr(),
                      //validator: Validator.requiredValidator,
                      readOnly: false,
                      textInputType: TextInputType.url,
                      onChanged: (val) => _linkToBioController.text = val,
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        GestureDetector(
                            onTap: () => setState(() {
                                  acceptTerms = !acceptTerms;
                                }),
                            child: Container(
                                height: 20,
                                width: 20,
                                child: Container(
                                  child: acceptTerms
                                      ? SvgPicture.asset(
                                          'assets/svgs/checkbox.svg')
                                      : SvgPicture.asset(
                                          'assets/svgs/checkbox_holder.svg'),
                                ))),
                        SizedBox(width: 10.w),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Wrap(
                              children: [
                                GestureDetector(
                                  onTap: () => setState(() {
                                    acceptTerms = !acceptTerms;
                                  }),
                                  child: Text(
                                    "I have read, understood and I agree to Sonalysis’"
                                        .tr(),
                                    style: AppStyle.text1.copyWith(
                                        color: AppColors.sonaBlack2,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    // open google.com in a webview
                                    await canLaunchUrl(Uri.parse(
                                            "https://sonalysis.com/privacy-policy/"))
                                        ? await launchUrl(Uri.parse(
                                            "https://sonalysis.com/privacy-policy/"))
                                        : showToast(
                                            "Sorry, not available", "error");
                                  },
                                  child: GradientText(
                                    "Privacy Policy".tr(),
                                    gradient: AppColors.sonalysisGradient,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                Text(
                                  " and ".tr().tr(),
                                  style: AppStyle.text1.copyWith(
                                      color: AppColors.sonaBlack2,
                                      fontWeight: FontWeight.w400),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    // open google.com in a webview
                                    await canLaunchUrl(Uri.parse(
                                            "https://sonalysis.com/terms-of-use/"))
                                        ? await launchUrl(Uri.parse(
                                            "https://sonalysis.com/terms-of-use/"))
                                        : showToast(
                                            "Sorry, not available", "error");
                                  },
                                  child: GradientText(
                                    "Terms and conditions.".tr(),
                                    gradient: AppColors.sonalysisGradient,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ))
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        GestureDetector(
                            onTap: () => setState(() {
                                  joinNewsUpdates = !joinNewsUpdates;
                                }),
                            child: Container(
                                height: 20,
                                width: 20,
                                child: Container(
                                  child: joinNewsUpdates
                                      ? SvgPicture.asset(
                                          'assets/svgs/checkbox.svg')
                                      : SvgPicture.asset(
                                          'assets/svgs/checkbox_holder.svg'),
                                ))),
                        SizedBox(width: 10.w),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Wrap(
                              children: [
                                GestureDetector(
                                  onTap: () => setState(() {
                                    joinNewsUpdates = !joinNewsUpdates;
                                  }),
                                  child: Text(
                                    "Join Sonalysis community for exclusive access to business resources and events to help you grow"
                                        .tr(),
                                    style: AppStyle.text1.copyWith(
                                        color: AppColors.sonaBlack2,
                                        fontWeight: FontWeight.w400),
                                  ),
                                )
                              ],
                            ))
                      ],
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                    AppButton(
                        buttonText: "submit".tr(),
                        onPressed: canSubmit && !emailExists
                            ? () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  _handleRegister();
                                }
                              }
                            : null),
                    SizedBox(
                      height: 30.h,
                    ),
                    BlocConsumer(
                      bloc: serviceLocator.get<SignupCubit>(),
                      listener: (_, state) {
                        if (state is RegisterPlayerLoading) {
                          context.loaderOverlay.show();
                        }

                        if (state is RegisterPlayerError) {
                          context.loaderOverlay.hide();
                          setState(() {
                            canSubmit = true;
                          });
                          ResponseMessage.showErrorSnack(
                              context: context, message: state.message);
                        }

                        if (state is RegisterPlayerSuccess) {
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
        ),
        Positioned(
            child: showSuccess
                ? PopUpPageScreen(data: {
                    "title": "your_request_is_processing".tr(),
                    "subTitle": "We will be in touch".tr(),
                    "route": RouteKeys.routeLoginScreen,
                    "routeType": "ClearAll",
                    "buttonText": "finish".tr()
                  })
                : Container())
      ],
    );
  }

  Future<void> _handleDoesUserExistEmailVerify() async {
    await serviceLocator<SignupCubit>()
        .doesUserExistEmailVerify(_emailController.text.trim());

    checkEmailLoader = false;
    emailExistModel = serviceLocator.get<EmailExistModel>();
    setState(() {});
    if (emailExistModel!.data!.user!) {
      emailExists = true;

      ResponseMessage.showErrorSnack(
          context: context, message: "Email already exist".tr());
    } else {
      emailExists = false;
    }
    setState(() {});
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    await serviceLocator<SignupCubit>().registerPlayer(
        "player",
        "",
        _emailController.text.toLowerCase().trim(),
        "",
        _oFirstNameController.text.trim(),
        _oLastNameController.text.trim(),
        _countryController.text.trim());
  }
}
