import 'dart:io';

import 'package:connectycube_flutter_call_kit/connectycube_flutter_call_kit.dart';
import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sonalysis/core/utils/colors.dart';
import 'package:sonalysis/core/utils/styles.dart';
import 'package:sonalysis/core/widgets/app_gradient_text.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/datasource/key.dart';
import '../../../core/datasource/local_storage.dart';
import '../../../core/models/response/UserResultModel.dart';
import '../../../core/navigation/keys.dart';
import '../../../core/navigation/navigation_service.dart';
import '../../../core/startup/app_startup.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/utils/response_message.dart';
import '../../../core/utils/validator.dart';
import '../../../core/widgets/GradientProgressBar.dart';
import '../../../core/widgets/appBar/appbarUnauth.dart';
import '../../../core/widgets/app_password_textfield.dart';
import '../../../core/widgets/app_phone_field.dart';
import '../../../core/widgets/app_textfield.dart';
import '../../../core/widgets/button.dart';
import '../../signup/cubit/signup_cubit.dart';
import '../cubit/initial_update_profile_cubit.dart';

class InitialUpdateProfileScreen3 extends StatefulWidget {
  InitialUpdateProfileScreen3({Key? key}) : super(key: key);

  @override
  _InitialUpdateProfileScreen3State createState() =>
      _InitialUpdateProfileScreen3State();
}

class _InitialUpdateProfileScreen3State
    extends State<InitialUpdateProfileScreen3> {
  final TextEditingController _clubNameController = TextEditingController();
  final TextEditingController _oFirstNameController = TextEditingController();
  final TextEditingController _oLastNameController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String beforeImg = "";
  bool canSubmit = false, checkEmailLoader = false, emailExists = false;
  String? _deviceToken;
  XFile? selectedPhoto, xFileForCropper;
  File? _croppedFile;
  final ImagePicker _imagePicker = ImagePicker();
  bool _imagePicked = false;
  final _formKey = GlobalKey<FormState>();
  bool acceptTerms = false, joinNewsUpdates = false;
  final TextEditingController _otpController = TextEditingController();
  UserResultData? userResultData;
  bool wasFormSubmitted = false;
  String phoneNumberText = "";

  @override
  void initState() {
    super.initState();
    data();
  }

  data() async {
    userResultData = await serviceLocator
        .get<LocalStorage>()
        .readSecureObject(LocalStorageKeys.kUserPrefs);
    setPresetFields(userResultData);
    await ConnectycubeFlutterCallKit.getToken().then((token) {
      //print('Device Token: ' '${token}');
      setState(() {
        if (Platform.isIOS) {
          _deviceToken = "token";
        } else {
          _deviceToken = token;
        }
      });
    });
  }

  setPresetFields(UserResultData? d) {
    if (d != null && d.user != null && d.user!.firstName != null) {
      _oFirstNameController.text = d.user!.firstName!;
      _oLastNameController.text = d.user!.lastName!;
      print("So I was here" + d.user!.firstName! + " " + d.user!.lastName!);
      setState(() {});
      if (d.user!.players![0].photo != null) {
        beforeImg = d.user!.players![0].photo!;
      }
    }
  }

  handlePickPhoto() async {
    XFile? _imagePickerResult = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 675,
        maxWidth: 960,
        preferredCameraDevice: CameraDevice.front);
    if (_imagePickerResult != null) {
      setState(() {
        selectedPhoto = _imagePickerResult;
      });
      cropImage(selectedPhoto);
    }
  }

  cropImage(XFile? documentImages) async {
    File? croppedFile = await ImageCropper().cropImage(
        sourcePath: documentImages!.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop selected image',
            toolbarColor: AppColors.sonaBlack,
            toolbarWidgetColor: Colors.white,
            activeControlsWidgetColor: Colors.white.withOpacity(0.4),
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: const IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));

    if (croppedFile != null) {
      setState(() {
        _croppedFile = croppedFile;
        _imagePicked = true;
      });
      //_validate(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarUnauth(),
      backgroundColor: AppColors.sonaWhite,
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        child: Form(
            key: _formKey,
            onChanged: () {
              setState(() {
                canSubmit = _formKey.currentState!.validate();
              });
              print('form state' + _formKey.currentState.toString());
              print('can submit ' + canSubmit.toString());
            },
            child: ListView(
              children: [
                Text(
                  "Create account count"
                      .tr(namedArgs: {"this": "3", "that": "5"}),
                  textAlign: TextAlign.left,
                  style: AppStyle.text2.copyWith(
                      color: AppColors.sonaGrey2, fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 10.h),
                GradientProgressBar(
                  percent: 60,
                  gradient: AppColors.sonalysisGradient,
                  backgroundColor: AppColors.sonaGrey6,
                ),
                SizedBox(height: 40.h),
                Text(
                  "Let’s get you started".tr(),
                  textAlign: TextAlign.center,
                  style: AppStyle.h3.copyWith(
                      color: AppColors.sonaBlack2, fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 10.h),
                Text(
                  "Fill the following details".tr(),
                  textAlign: TextAlign.center,
                  style: AppStyle.text2.copyWith(
                      color: AppColors.sonaGrey2, fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 40.h),
                InkWell(
                    onTap: () {
                      handlePickPhoto();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              _croppedFile != null
                                  ? CircleAvatar(
                                      backgroundColor: AppColors.sonaGrey6,
                                      radius: 50,
                                      backgroundImage: FileImage(_croppedFile!),
                                    )
                                  : beforeImg != ""
                                      ? CircleAvatar(
                                          child: Image.network(
                                            beforeImg,
                                            height: 100,
                                            width: 100,
                                            fit: BoxFit.cover,
                                          ),
                                          radius: 50,
                                        )
                                      : CircleAvatar(
                                          backgroundColor: AppColors.sonaGrey6,
                                          radius: 50,
                                          child: ClipOval(
                                            child: SizedBox(
                                                width: 100.0,
                                                height: 100.0,
                                                child: SizedBox.shrink()),
                                          ),
                                        ),
                              Positioned(
                                right: 4.0,
                                bottom: 4.0,
                                child: SvgPicture.asset(
                                  "assets/svgs/plus_icon.svg",
                                  height: 24,
                                  width: 24,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
                SizedBox(
                  height: 20.h,
                ),
                if (Validator.requiredValidatorString(
                        _clubNameController.text, wasFormSubmitted) !=
                    '')
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.43,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10.h),
                        Text(
                          Validator.requiredValidatorString(
                              _clubNameController.text, wasFormSubmitted),
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.sonaRed,
                            height: 1.33,
                          ),
                        ),
                      ],
                    ),
                  ),
                SizedBox(
                  height: 20.h,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.43,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppTextField(
                                controller: _oFirstNameController,
                                headerText: "First name".tr(),
                                hintText: "Type here".tr(),
                                validator: Validator.firstnameValidator,
                                textInputType: TextInputType.name,
                                textInputFormatters: [
                                  LengthLimitingTextInputFormatter(10),
                                ],
                              )
                            ],
                          )),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.43,
                        child: AppTextField(
                          controller: _oLastNameController,
                          headerText: "Last name".tr(),
                          hintText: "Type here".tr(),
                          validator: Validator.lastnameValidator,
                          textInputType: TextInputType.name,
                          textInputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (Validator.firstnameValidatorString(
                            _oFirstNameController.text, wasFormSubmitted) !=
                        '' ||
                    Validator.firstnameValidatorString(
                            _oLastNameController.text, wasFormSubmitted) !=
                        '')
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.43,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10.h),
                              Text(
                                Validator.firstnameValidatorString(
                                    _oFirstNameController.text,
                                    wasFormSubmitted),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.sonaRed,
                                  height: 1.33,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.43,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10.h),
                              Text(
                                Validator.lastnameValidatorString(
                                    _oLastNameController.text,
                                    wasFormSubmitted),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.sonaRed,
                                  height: 1.33,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                SizedBox(
                  height: 20.h,
                ),
                AppTextField(
                  headerText: "country".tr(),
                  hintText: "Type here".tr(),
                  validator: Validator.requiredValidator,
                  readOnly: true,
                  controller: _countryController,
                  onChanged: (v) {
                    setState(() {});
                    // validateButton();
                  },
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
                          print("Selected country: ${_countryController.text}");
                        });
                  },
                  textInputType: TextInputType.name,
                ),
                if (Validator.requiredValidatorString(
                        _countryController.text, wasFormSubmitted) !=
                    '')
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.43,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10.h),
                        Text(
                          Validator.requiredValidatorString(
                              _countryController.text, wasFormSubmitted),
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.sonaRed,
                            height: 1.33,
                          ),
                        ),
                      ],
                    ),
                  ),
                SizedBox(
                  height: 20.h,
                ),
                AppPhoneTextField(
                  enabled: true,
                  controller: _phoneNumberController,
                  headerText: 'Phone numbere'.tr(),
                  validator: Validator.validateMobile,
                  onChanged: (val) => {
                    phoneNumberText = val != null ? val : '',
                    print('phone:' + val!),
                    setState(() {}),
                  },
                ),
                if (Validator.validateMobileString(
                        _phoneNumberController.text, wasFormSubmitted) !=
                    '')
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.43,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10.h),
                        Text(
                          Validator.validateMobileString(
                              _phoneNumberController.text, wasFormSubmitted),
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.sonaRed,
                            height: 1.33,
                          ),
                        ),
                      ],
                    ),
                  ),
                SizedBox(
                  height: 40,
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
                                  ? SvgPicture.asset('assets/svgs/checkbox.svg')
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
                if (wasFormSubmitted && !acceptTerms)
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.43,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10.h),
                        Text(
                          "You must accept the terms and conditions".tr(),
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.sonaRed,
                            height: 1.33,
                          ),
                        ),
                      ],
                    ),
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
                                  ? SvgPicture.asset('assets/svgs/checkbox.svg')
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
                    buttonText: "continue".tr(),
                    onPressed: acceptTerms && canSubmit
                        ? () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              _handleFinalSubmit();
                            } else {
                              ResponseMessage.showErrorSnack(
                                  context: context,
                                  message:
                                      "Please upload a profile picture".tr());
                            }
                          }
                        : () {
                            setState(() {
                              wasFormSubmitted = true;
                            });
                          }),
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
                      serviceLocator.get<NavigationService>().toWithPameter(
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
            )),
      ),
    );
  }

  Future<void> _handleDoesUserExistEmailVerify() async {
    await serviceLocator<SignupCubit>()
        .doesUserExistEmailVerify(_emailController.text.toLowerCase().trim());

    checkEmailLoader = false;
    setState(() {});
    emailExists = false;
    setState(() {});
  }

  Future<void> _verifyOTP() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    await serviceLocator<SignupCubit>().verifyOTP(_otpController.text.trim());
  }

  Future<void> _handleFinalSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    print("Lol I was here");

    await serviceLocator<InitialUpdateProfileCubit>().updateUserProfileLite(
      userResultData!.user!.id,
      _oFirstNameController.text.trim(),
      _oLastNameController.text.trim(),
      _countryController.text.trim(),
      phoneNumberText,
      _croppedFile,
    );
  }
}
