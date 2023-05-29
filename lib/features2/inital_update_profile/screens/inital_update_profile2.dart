import 'dart:async';

import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sonalysis/core/models/response/UserResultModel.dart';
import 'package:sonalysis/core/startup/app_startup.dart';
import 'package:sonalysis/core/utils/colors.dart';
import 'package:sonalysis/core/utils/response_message.dart';
import 'package:sonalysis/core/utils/validator.dart';
import 'package:sonalysis/core/widgets/button.dart';

import '../../../core/datasource/key.dart';
import '../../../core/datasource/local_storage.dart';
import '../../../core/navigation/keys.dart';
import '../../../core/navigation/navigation_service.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/utils/styles.dart';
import '../../../core/widgets/appBar/appbarUnauth.dart';
import '../../../core/widgets/app_datefield.dart';
import '../../../core/widgets/app_phone_field.dart';
import '../../../core/widgets/app_textfield.dart';
import '../cubit/initial_update_profile_cubit.dart';

class InitialUpdateProfileScreen2 extends StatefulWidget {
  const InitialUpdateProfileScreen2({Key? key}) : super(key: key);

  @override
  _InitialUpdateProfileScreen2State createState() =>
      new _InitialUpdateProfileScreen2State();
}

class _InitialUpdateProfileScreen2State
    extends State<InitialUpdateProfileScreen2> {
  bool canSubmit = false;
  final _formKey = GlobalKey<FormState>();
  UserResultData? userResultData;
  TextEditingController? _oFirstNameController;
  TextEditingController? _oLastNameController;
  TextEditingController? _dobController;
  TextEditingController? _ageController;
  TextEditingController? _countryController;
  TextEditingController? _phoneNumberController;
  TextEditingController? _ePhoneNumberController;
  TextEditingController? _jerseyNumberController;
  TextEditingController? _yearsOfExperienceController;
  TextEditingController? _employmentStartDateController;
  TextEditingController? _employmentEndDateController;
  TextEditingController? _linkToPortfolioController;

  @override
  void initState() {
    super.initState();
    _data();
  }

  _data() async {
    userResultData = await serviceLocator
        .get<LocalStorage>()
        .readSecureObject(LocalStorageKeys.kUserPrefs);
    _oFirstNameController =
        TextEditingController(text: userResultData!.user!.firstName);
    _oLastNameController =
        TextEditingController(text: userResultData!.user!.lastName);
    _jerseyNumberController = TextEditingController();
    _yearsOfExperienceController = TextEditingController();
    _employmentStartDateController = TextEditingController();
    _employmentEndDateController = TextEditingController();
    _linkToPortfolioController = TextEditingController();
    _ePhoneNumberController = TextEditingController();
    if (userResultData!.user!.dob.toString() != "null") {
      _dobController = TextEditingController(text: userResultData!.user!.dob);
      _ageController = TextEditingController(
          text: calculateAge(DateTime.parse(userResultData!.user!.dob!)));
    } else {
      _dobController = TextEditingController();
      _ageController = TextEditingController();
    }
    if (userResultData!.user!.country.toString() != "null") {
      _countryController =
          TextEditingController(text: userResultData!.user!.country!);
    } else {
      _countryController = TextEditingController();
    }
    if (userResultData!.user!.phone.toString() != "null") {
      _phoneNumberController =
          TextEditingController(text: userResultData!.user!.phone!);
    } else {
      _phoneNumberController = TextEditingController();
    }
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
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Set up profile".tr(),
                          textAlign: TextAlign.center,
                          style:
                              AppStyle.h3.copyWith(color: AppColors.sonaBlack2),
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          "Fill the following details".tr(),
                          textAlign: TextAlign.center,
                          style: AppStyle.text2.copyWith(
                              color: AppColors.sonaBlack2.withOpacity(0.4),
                              fontWeight: FontWeight.w300),
                        ),
                        SizedBox(height: 20.h),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.42,
                                child: AppTextField(
                                  headerText: "first_name".tr(),
                                  hintText: "eg_first_name".tr(),
                                  validator: Validator.firstnameValidator,
                                  onChanged: (v) {
                                    setState(() {});
                                    // validateButton();
                                  },
                                  textInputType: TextInputType.name,
                                  textInputFormatters: [
                                    LengthLimitingTextInputFormatter(10),
                                  ],
                                  controller: _oFirstNameController,
                                  //onSaved: (val) => _oFirstNameController.text = val!,
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.42,
                                child: AppTextField(
                                  headerText: "last_name".tr(),
                                  hintText: "eg_last_name".tr(),
                                  validator: Validator.lastnameValidator,
                                  onChanged: (v) {
                                    setState(() {});
                                    // validateButton();
                                  },
                                  textInputType: TextInputType.name,
                                  textInputFormatters: [
                                    LengthLimitingTextInputFormatter(10),
                                  ],
                                  controller: _oLastNameController,
                                  //onSaved: (val) => _oLastNameController.text = val!,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.42,
                                  child: AppDateField(
                                    headerText: "date_of_birth".tr(),
                                    hintText: "date_of_birth".tr(),
                                    onChanged: (DateTime value) {
                                      _dobController!.text =
                                          DateFormat('yyyy-MM-dd')
                                              .format(value);
                                      setState(() {
                                        _ageController!.text =
                                            calculateAge(value).toString();
                                        print(calculateAge(value).toString());
                                      });
                                    },
                                    validator: Validator.requiredValidator,
                                  )),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.42,
                                child: AppTextField(
                                  headerText: "age".tr(),
                                  hintText: "enter_your_age".tr(),
                                  controller: _ageController,
                                  readOnly: true,
                                  validator: Validator.validateAge,
                                  onChanged: (v) {
                                    setState(() {});
                                  },
                                  textInputType: TextInputType.number,
                                  textInputFormatters: [
                                    LengthLimitingTextInputFormatter(10),
                                  ],
                                  onSaved: (val) => _ageController!.text = val!,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.42,
                                child: AppTextField(
                                  headerText: "jersey_number".tr(),
                                  hintText: "18",
                                  validator: Validator.requiredValidator,
                                  onChanged: (v) {
                                    setState(() {});
                                    // validateButton();
                                  },
                                  textInputType: TextInputType.number,
                                  textInputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]'))
                                  ],
                                  controller: _jerseyNumberController,
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.42,
                                child: AppTextField(
                                  headerText: "years_of_experience".tr(),
                                  hintText: "12",
                                  validator: Validator.requiredValidator,
                                  onChanged: (v) {
                                    setState(() {});
                                    // validateButton();
                                  },
                                  textInputType: TextInputType.number,
                                  textInputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]'))
                                  ],
                                  controller: _yearsOfExperienceController,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.44,
                                  child: AppDateField(
                                    headerText: "employment_start_date".tr(),
                                    hintText: "yyyy-MM-dd",
                                    onChanged: (DateTime value) {
                                      _employmentStartDateController!.text =
                                          DateFormat('yyyy-MM-dd')
                                              .format(value);
                                    },
                                    validator: Validator.requiredValidator,
                                  )),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.44,
                                  child: AppDateField(
                                    headerText: "employment_end_date".tr(),
                                    hintText: "yyyy-MM-dd",
                                    maxDate: 2050,
                                    onChanged: (DateTime value) {
                                      _employmentEndDateController!.text =
                                          DateFormat('yyyy-MM-dd')
                                              .format(value);
                                    },
                                    validator: Validator.requiredValidator,
                                  )),
                            ],
                          ),
                        ),
                        AppTextField(
                          headerText: "country".tr(),
                          validator: Validator.requiredValidator,
                          readOnly: true,
                          controller: _countryController,
                          onChanged: (v) {
                            setState(() {});
                            // validateButton();
                          },
                          onTap: () {
                            showCountryPicker(
                                context: context,
                                showPhoneCode: false,
                                countryListTheme: countryListThemeData(),
                                onSelect: (Country country) {
                                  //print("Selected country: ${country.displayName}");
                                  setState(() {
                                    _countryController!.text = country
                                        .displayNameNoCountryCode
                                        .trim()
                                        .replaceAll(RegExp(' \\(.*?\\)'), '');
                                  });
                                });
                          },
                          textInputType: TextInputType.name,
                          //onSaved: (val) => _countryController.text = val!,
                        ),
                        AppPhoneTextField(
                          enabled: true,
                          controller: _phoneNumberController,
                          headerText: 'phone_number'.tr(),
                          validator: Validator.validateMobile,
                          onChanged: (String? value) {},
                        ),
                        AppPhoneTextField(
                          enabled: true,
                          controller: _ePhoneNumberController,
                          headerText: 'emergency_phone_number'.tr(),
                          validator: Validator.validateMobile,
                          onChanged: (String? value) {},
                        ),
                        AppTextField(
                          headerText: "link_to_portfolio".tr(),
                          hintText: "link_to_portfolio".tr(),
                          //validator: Validator.validateLink,
                          textInputType: TextInputType.url,
                          controller: _linkToPortfolioController,
                        ),
                        AppButton(
                            buttonText: "submit".tr(),
                            onPressed: canSubmit
                                ? () {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      _handleUpdateProfile();
                                    }
                                  }
                                : null),
                        SizedBox(
                          height: 20.h,
                        ),
                        BlocConsumer(
                          bloc: serviceLocator.get<InitialUpdateProfileCubit>(),
                          listener: (_, state) {
                            if (state is PasswordResetLoading ||
                                state is UpdateUserProfileLoading) {
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

                            if (state is UpdateUserProfileError) {
                              context.loaderOverlay.hide();
                              setState(() {
                                canSubmit = true;
                              });
                              ResponseMessage.showErrorSnack(
                                  context: context, message: state.message);
                            }

                            if (state is PasswordResetSuccess) {
                              context.loaderOverlay.hide();
                              canSubmit = true;
                              setState(() {});
                              ResponseMessage.showSuccessSnack(
                                  context: context,
                                  message: "Password was successfully updated");
                            }

                            if (state is UpdateUserProfileSuccess) {
                              context.loaderOverlay.hide();
                              String goTo;
                              //show dialog page
                              serviceLocator
                                  .get<NavigationService>()
                                  .toWithPameter(
                                      routeName: RouteKeys.routePopUpPageScreen,
                                      data: {
                                    "title": "profile_updated".tr(),
                                    "subTitle": "your_profile_has_been_updated".tr(),
                                    "route": RouteKeys.routeBottomNaviScreen,
                                    "routeType": "ClearAll",
                                    "buttonText": "okay_thank_you".tr()
                                  });
                            }
                          },
                          builder: (_, state) {
                            return const SizedBox();
                          },
                        ),
                      ],
                    ),
                  ),
                ])),
      ),
    );
  }

  Future<void> _handleUpdateProfile() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    await serviceLocator<InitialUpdateProfileCubit>().updateUserProfile(
        userResultData!.user!.id,
        _oFirstNameController!.text.trim(),
        _oLastNameController!.text.trim(),
        int.parse(_yearsOfExperienceController!.text.trim()),
        _employmentStartDateController!.text.trim(),
        _employmentEndDateController!.text.trim(),
        int.parse(_ageController!.text.trim()),
        _linkToPortfolioController!.text.trim(),
        _ePhoneNumberController!.text.trim(),
        _dobController!.text.trim(),
        _jerseyNumberController!.text.trim(),
        _countryController!.text.trim(),
        _phoneNumberController!.text.trim());
  }
}
