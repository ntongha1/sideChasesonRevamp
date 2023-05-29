import 'dart:async';
// //
import 'package:connectycube_flutter_call_kit/connectycube_flutter_call_kit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sonalysis/core/datasource/key.dart';
import 'package:sonalysis/core/datasource/local_storage.dart';
import 'package:sonalysis/core/enums/user_type.dart';
import 'package:sonalysis/core/models/response/UserResultModel.dart';
import 'package:sonalysis/core/navigation/keys.dart';
import 'package:sonalysis/core/navigation/navigation_service.dart';
import 'package:sonalysis/core/startup/app_startup.dart';
import 'package:sonalysis/core/utils/colors.dart';
import 'package:sonalysis/core/utils/response_message.dart';
import 'package:sonalysis/core/utils/validator.dart';
import 'package:sonalysis/core/widgets/app_gradient_text.dart';
import 'package:sonalysis/core/widgets/app_password_textfield.dart';
import 'package:sonalysis/core/widgets/app_textfield.dart';
import 'package:sonalysis/core/widgets/button.dart';
import 'package:sonalysis/core/widgets/popup_screen.dart';

import '../../core/utils/styles.dart';
import '../../core/widgets/appBar/appbarUnauth.dart';
import 'cubit/login_user_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController? _emailController = TextEditingController();
  TextEditingController? _passwordController = TextEditingController();
  bool? _isRememberMeChecked = false, canSubmit = false, isSubmitting = false;
  final _formKey = GlobalKey<FormState>();
  UserResultData? userResultData;
  String? deviceToken;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData() async {
    String? loginEmail;
    loginEmail = (await serviceLocator
        .get<LocalStorage>()
        .readString(LocalStorageKeys.kLoginEmailPrefs))!;
    if (loginEmail != null) {
      _emailController = TextEditingController(text: loginEmail);
      _passwordController = TextEditingController(); //text: "Password1##"
    }
    print(loginEmail);
    setState(() {});

    await ConnectycubeFlutterCallKit.getToken().then((token) {
      print('Device Token: ' '${token}');
      setState(() {
        deviceToken = token;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBarUnauth(),
          backgroundColor: AppColors.sonaWhite,
          body: Form(
              key: _formKey,
              onChanged: () {
                setState(() {
                  canSubmit = _formKey.currentState!.validate();
                });
              },
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Login to your account".tr(),
                        textAlign: TextAlign.center,
                        style: AppStyle.h3.copyWith(
                            color: AppColors.sonaBlack2,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(height: 60.h),
                      AppTextField(
                        headerText: "email".tr(),
                        hintText: "Type here".tr(),
                        validator: Validator.emailValidator,
                        controller: _emailController,
                        readOnly: false,
                        onChanged: (v) {
                          setState(() {});
                          // validateButton();
                        },
                        textInputType: TextInputType.emailAddress,
                        onSaved: (val) => _emailController!.text = val!,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      AppPasswordTextField(
                        headerText: 'password'.tr(),
                        hintText: "Type here".tr(),
                        controller: _passwordController,
                        textInputAction: TextInputAction.done,
                        onSaved: (val) => _passwordController!.text = val!,
                      ),
                      SizedBox(
                        height: 40.h,
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: <Widget>[
                      //     Row(
                      //       children: <Widget>[
                      //         Container(
                      //           height: 19,
                      //           width: 19,
                      //           child: Checkbox(
                      //             value: _isRememberMeChecked,
                      //             onChanged: (bool? newValue) => setState(() {
                      //               _isRememberMeChecked = newValue!;
                      //               if (_isRememberMeChecked!) {
                      //                 // TODO: Here goes your functionality that remembers the user.
                      //               } else {
                      //                 // TODO: Forget the user
                      //               }
                      //             }),
                      //             checkColor: AppColors.sonaWhite,
                      //             activeColor: AppColors.sonalysisMediumPurple,
                      //           ),
                      //         ),
                      //         SizedBox(width: 10),
                      //         GestureDetector(
                      //           onTap: () => print("remember_me".tr()),
                      //           child: Text(
                      //             "remember_me".tr(),
                      //             style: AppStyle.text2.copyWith(
                      //                 color: AppColors.sonaBlack2, fontSize: 12.sp),
                      //           ),
                      //         )
                      //       ],
                      //     ),
                      //     InkWell(
                      //       onTap: () async {
                      //         serviceLocator
                      //             .get<NavigationService>()
                      //             .to(RouteKeys.routeRecoverPasswordScreen);
                      //       },
                      //       child: Text(
                      //         "forgot_password".tr(),
                      //         style: AppStyle.text2.copyWith(
                      //             color: AppColors.sonaBlack2, fontSize: 12.sp),
                      //       ),
                      //     )
                      //   ],
                      // ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: AppButton(
                              buttonText: "login".tr(),
                              onPressed: canSubmit!
                                  ? () {
                                      if (_formKey.currentState!.validate()) {
                                        _formKey.currentState!.save();
                                        _handleLogin();
                                      }
                                    }
                                  : null)),
                      SizedBox(
                        height: 20.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          InkWell(
                              onTap: () async {
                                serviceLocator
                                    .get<NavigationService>()
                                    .to(RouteKeys.routeRecoverPasswordScreen);
                              },
                              child: Row(
                                children: [
                                  Text(
                                    "Forgot your password? ".tr(),
                                    style: AppStyle.text2.copyWith(
                                        color: AppColors.sonaBlack2,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  GradientText("Reset it here",
                                      gradient: AppColors.sonalysisGradient,
                                      style: AppStyle.text2.copyWith(
                                          color: AppColors.sonaBlack2,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w400)),
                                ],
                              ))
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          InkWell(
                              onTap: () async {
                                serviceLocator
                                    .get<NavigationService>()
                                    .to(RouteKeys.routeSignupOptionScreen);
                              },
                              child: Row(
                                children: [
                                  Text(
                                    "Don't have an account? ".tr(),
                                    style: AppStyle.text2.copyWith(
                                        color: AppColors.sonaBlack2,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  GradientText("Get one here",
                                      gradient: AppColors.sonalysisGradient,
                                      style: AppStyle.text2.copyWith(
                                          color: AppColors.sonaBlack2,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w400)),
                                ],
                              ))
                        ],
                      ),
                      SizedBox(
                        height: 50.h,
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
                            userResultData =
                                serviceLocator.get<UserResultData>();
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
                            print('token debug: token I just stored is: ' +
                                vall!);
                            //store userID
                            serviceLocator
                                .get<LocalStorage>()
                                .writeSecureString(
                                    key: LocalStorageKeys.kUIDPrefs,
                                    value: userResultData!.user!.id!);
                            //store user details
                            serviceLocator
                                .get<LocalStorage>()
                                .writeSecureObject(
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
                                // serviceLocator
                                //     .get<NavigationService>()
                                //     .clearAllTo(
                                //         RouteKeys.routeBottomNaviScreen);
                                //check if user has paid
                                serviceLocator
                                    .get<NavigationService>()
                                    .clearAllTo(
                                        RouteKeys.routeWelcomeBackScreen);
                              } else {
                                print("login: da fuq 4");

                                // club admin
                                serviceLocator
                                    .get<NavigationService>()
                                    .clearAllTo(
                                        RouteKeys.routeBottomNaviScreen);
                              }
                            } else if (userResultData!.user!.role!
                                        .toLowerCase() ==
                                    UserType.coach.type ||
                                userResultData!.user!.role!.toLowerCase() ==
                                    UserType.manager.type ||
                                userResultData!.user!.role!.toLowerCase() ==
                                    UserType.player.type) {
                              //coach || player
                              if (userResultData!.user!.profileUpdated == 0) {
                                serviceLocator
                                    .get<NavigationService>()
                                    .toWithPameter(
                                        routeName:
                                            RouteKeys.routeSetPasswordScreen,
                                        data: {
                                      "email": userResultData!.user!.email,
                                    });
                              } else {
                                serviceLocator
                                    .get<NavigationService>()
                                    .clearAllTo(
                                        RouteKeys.routeBottomNaviScreen);
                              }
                            } else {
                              if (userResultData!.user!.loginCount == 1) {
                                serviceLocator
                                    .get<NavigationService>()
                                    .clearAllTo(RouteKeys
                                        .routeInitialUpdateProfileScreen);
                              } else {
                                serviceLocator
                                    .get<NavigationService>()
                                    .clearAllTo(
                                        RouteKeys.routeBottomNaviScreen);
                              }
                            }
                          }
                        },
                        builder: (_, state) {
                          return const SizedBox();
                        },
                      ),
                    ],
                  ),
                ),
              )),
        )
      ],
    );
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    await serviceLocator<LoginUserCubit>().loginUser(
      _emailController!.text.toLowerCase().trim(),
      _passwordController!.text.trim(),
      deviceToken,
    );
  }
}
