import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sonalysis/core/enums/button.dart';
import 'package:sonalysis/core/utils/colors.dart';
import 'package:sonalysis/core/utils/styles.dart';

import '../../../core/widgets/button.dart';
import '../../core/datasource/key.dart';
import '../../core/datasource/local_storage.dart';
import '../../core/models/response/UserResultModel.dart';
import '../../core/navigation/keys.dart';
import '../../core/navigation/navigation_service.dart';
import '../../core/startup/app_startup.dart';
import '../../core/utils/RadiantGradientMask.dart';

class WelcomeBackScreen extends StatefulWidget {
  WelcomeBackScreen({Key? key}) : super(key: key);

  @override
  _WelcomeBackScreenState createState() => _WelcomeBackScreenState();
}

class _WelcomeBackScreenState extends State<WelcomeBackScreen> {
  bool? canSubmit = false;
  int _value = 1;
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
      backgroundColor: AppColors.sonaWhite,
      body: Container(
          margin: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
          child: ListView(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.25),
              RadiantGradientMask(
                  child: Icon(
                Iconsax.signpost5,
                size: 80.sp,
                color: AppColors.sonaWhite,
              )),
              SizedBox(height: 40),
              Text(
                "Welcome back".tr(namedArgs: {
                  "name": userResultData != null
                      ? userResultData!.user!.firstName!
                      : ""
                }),
                textAlign: TextAlign.center,
                style: AppStyle.text3.copyWith(
                    color: AppColors.sonaBlack2, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 20.h),
              Text(
                "Let’s pick up where you left off".tr(),
                textAlign: TextAlign.center,
                style: AppStyle.text1.copyWith(
                    color: AppColors.sonaGrey2, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 40.h),
              AppButton(
                  buttonText: "continue".tr(),
                  onPressed: () {
                    if (userResultData!.user!.emailVerified! == 0) {
                      serviceLocator.get<NavigationService>().toWithPameter(
                          routeName: RouteKeys.routeOTPScreen,
                          data: {
                            "email": userResultData!.user!.email,
                            "routeName":
                                RouteKeys.routeChooseSubscriptionPlanScreen,
                            "sendOTPOnload": true,
                            "pageType": "clubRegistration",
                            "successTitle":
                                "Account verified successfully".tr(),
                            "successSubTitle":
                                "Proceed to choose subscription and".tr(),
                          });
                    } else {
                      serviceLocator.get<NavigationService>().clearAllTo(
                          RouteKeys.routeChooseSubscriptionPlanScreen);
                    }
                  }),
              SizedBox(height: 40.h),
              AppButton(
                  buttonType: ButtonType.secondary,
                  buttonText: "Logout".tr(),
                  onPressed: () {
                    serviceLocator
                        .get<LocalStorage>()
                        .clearAllExcept(LocalStorageKeys.kLoginEmailPrefs);
                    serviceLocator
                        .get<NavigationService>()
                        .clearAllTo(RouteKeys.routeLoginScreen);
                  })
            ],
          )),
    );
  }
}
