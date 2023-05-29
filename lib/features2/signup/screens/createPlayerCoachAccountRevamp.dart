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
import 'package:sonalysis/core/enums/user_type.dart';

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
import '../cubit/signup_cubit.dart';
import '../../login/cubit/login_user_cubit.dart';
import '../models/EmailExistModel.dart';

class CreateClubAccountScreenRevamp extends StatefulWidget {
  CreateClubAccountScreenRevamp({Key? key, required this.data})
      : super(key: key);

  Map? data;

  @override
  _CreateClubAccountScreenRevampState createState() =>
      _CreateClubAccountScreenRevampState();
}

class _CreateClubAccountScreenRevampState
    extends State<CreateClubAccountScreenRevamp> {
  final TextEditingController _clubNameController = TextEditingController();
  final TextEditingController _oFirstNameController = TextEditingController();
  final TextEditingController _oLastNameController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
  EmailExistModel? emailExistModel;
  bool wasFormSubmitted = false;
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    data();
  }

  data() async {
    // _emailController.text = "mahevstark+66@gmail.com";
    // _passwordController.text = "ZszTB7wT";
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
                      .tr(namedArgs: {"this": "1", "that": "3"}),
                  textAlign: TextAlign.left,
                  style: AppStyle.text2.copyWith(
                      color: AppColors.sonaGrey2, fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 10.h),
                GradientProgressBar(
                  percent: 25,
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
                Focus(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppTextField(
                          initialValue: _emailController.text,
                          headerText: "email".tr(),
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
                          onChanged: (val) => _emailController.text = val,
                          textInputType: TextInputType.emailAddress,
                        ),
                        if (Validator.emailValidatorString(
                                _emailController.text, wasFormSubmitted) !=
                            '')
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.43,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10.h),
                                Text(
                                  Validator.emailValidatorString(
                                      _emailController.text, wasFormSubmitted),
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
                      ]),
                  // onFocusChange: (hasFocus) {
                  //   //print(hasFocus.toString());
                  //   if (!hasFocus && validateEmail(_emailController.text)) {
                  //     checkEmailLoader = true;
                  //     _handleDoesUserExistEmailVerify();
                  //   } else {
                  //     checkEmailLoader = false;
                  //   }
                  //   setState(() {});
                  // },
                ),
                SizedBox(
                  height: 20.h,
                ),
                AppPasswordTextField(
                  headerText: 'password'.tr(),
                  hintText: "Type here".tr(),
                  controller: _passwordController,
                  textInputAction: TextInputAction.done,
                  onSaved: (val) => _passwordController.text = val!,
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
                          "You mush accept the terms and conditions".tr(),
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
                            } else {}
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
                  bloc: serviceLocator.get<LoginUserCubit>(),
                  listener: (_, state) async {
                    if (state is LoginUserLoading) {
                      context.loaderOverlay.show();
                    }

                    if (state is LoginUserError) {
                      context.loaderOverlay.hide();
                      setState(() {
                        isSubmitting = false;
                        canSubmit = true;
                      });
                      ResponseMessage.showErrorSnack(
                          context: context, message: state.message);
                    }

                    if (state is LoginUserSuccess) {
                      context.loaderOverlay.hide();
                      userResultData = serviceLocator.get<UserResultData>();
                      // print("loginCount: "+userResultData.toString());
                      // print("loginCount2: "+userResultData!.authToken.toString());
                      //store isLoggedIn
                      //store user email
                      serviceLocator.get<LocalStorage>().writeString(
                          key: LocalStorageKeys.kLoginEmailPrefs,
                          value: userResultData!.user!.email!);
                      serviceLocator
                          .get<LocalStorage>()
                          .writeBool(LocalStorageKeys.kLoginPrefs, true);
                      //store token
                      serviceLocator.get<LocalStorage>().writeString(
                          key: LocalStorageKeys.kTokenPrefs,
                          value: userResultData!.authToken!);

                      String? vall = await serviceLocator
                          .get<LocalStorage>()
                          .readString(LocalStorageKeys.kTokenPrefs);
                      print('token debug: token I just stored is: ' + vall!);
                      //store userID
                      serviceLocator.get<LocalStorage>().writeSecureString(
                          key: LocalStorageKeys.kUIDPrefs,
                          value: userResultData!.user!.id!);
                      //store user details
                      serviceLocator.get<LocalStorage>().writeSecureObject(
                          key: LocalStorageKeys.kUserPrefs,
                          value: userResultData);
                      print("login: da fuq");

                      //move to next page
                      //checks
                      //check role
                      if (userResultData!.user!.role!.toLowerCase() ==
                          UserType.owner.type) {
                        print("login: da fuq 2");

                        if (userResultData!.user!.emailVerified! == 0 ||
                            userResultData!.user!.paid == null ||
                            userResultData!.user!.paid == 0) {
                          print("login: da fuq 3");

                          //check if user has paid
                          serviceLocator
                              .get<NavigationService>()
                              .clearAllTo(RouteKeys.routeWelcomeBackScreen);
                        } else {
                          print("login: da fuq 4");

                          // club admin
                          serviceLocator
                              .get<NavigationService>()
                              .clearAllTo(RouteKeys.routeBottomNaviScreen);
                        }
                      } else if (userResultData!.user!.role!.toLowerCase() ==
                              UserType.coach.type ||
                          userResultData!.user!.role!.toLowerCase() ==
                              UserType.manager.type ||
                          userResultData!.user!.role!.toLowerCase() ==
                              UserType.player.type) {
                        print("login: da fuq 5");

                        //coach || player
                        if (userResultData!.user!.profileUpdated == 0) {
                          print("login: da fuq 6");

                          serviceLocator.get<NavigationService>().toWithPameter(
                              routeName: RouteKeys.routeSetPasswordScreen,
                              data: {
                                "old_password": _passwordController.text,
                                "email": _emailController.text,
                              });

                          // serviceLocator.get<NavigationService>().clearAllTo(
                          //     RouteKeys.routeInitialUpdateProfileScreen);
                        } else {
                          print("login: da fuq 7");

                          serviceLocator
                              .get<NavigationService>()
                              .clearAllTo(RouteKeys.routeBottomNaviScreen);
                        }
                      } else {
                        print("login: da fuq 8");

                        if (userResultData!.user!.loginCount == 1) {
                          print("login: da fuq 9");

                          serviceLocator.get<NavigationService>().clearAllTo(
                              RouteKeys.routeInitialUpdateProfileScreen);
                        } else {
                          print("login: da fuq 10");

                          serviceLocator
                              .get<NavigationService>()
                              .clearAllTo(RouteKeys.routeBottomNaviScreen);
                        }
                      }
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

  Future<void> _verifyOTP() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    await serviceLocator<SignupCubit>().verifyOTP(_otpController.text.trim());
  }

  Future<void> _handleFinalSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    print("Lol I was here");
    _handleLogin();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    await serviceLocator<LoginUserCubit>().loginUser(
      _emailController.text.toLowerCase().trim(),
      _passwordController.text.trim(),
      _deviceToken,
    );
  }
}
