import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sonalysis/core/utils/colors.dart';
import 'package:sonalysis/core/utils/styles.dart';

import '../../core/enums/button.dart';
import '../../core/navigation/keys.dart';
import '../../core/navigation/navigation_service.dart';
import '../../core/startup/app_startup.dart';
import '../../core/widgets/appBar/appbarUnauth.dart';
import '../../core/widgets/button.dart';
import 'widgets/signup_options_radio_button.dart';

class SignupOptionScreen extends StatefulWidget {
  const SignupOptionScreen({Key? key}) : super(key: key);

  @override
  _SignupOptionScreenState createState() => _SignupOptionScreenState();
}

class _SignupOptionScreenState extends State<SignupOptionScreen> {
  String? option1 = "clubAdmin", option2 = "coach_player";
  String _selectedOption = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarUnauth(),
      backgroundColor: AppColors.sonaWhite,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 34.h),
              Text(
                "Select sign up option".tr(),
                textAlign: TextAlign.center,
                style: AppStyle.h3.copyWith(color: AppColors.sonaBlack2),
              ),
              SizedBox(height: 10.h),
              Text(
                "Select one to proceed".tr(),
                textAlign: TextAlign.center,
                style: AppStyle.text2.copyWith(
                    color: AppColors.sonaGrey2, fontWeight: FontWeight.w400),
              ),
              SignupOptionsRadioButtons<String>(
                value: option1!,
                groupValue: _selectedOption,
                icon: Iconsax.profile_circle,
                onImage: './assets/svgs/user_gradient.svg',
                offImage: './assets/svgs/user_grey.svg',
                title: "Club Admin".tr(),
                subTitle: "Create your club’s account and start analyzing".tr(),
                onChanged: (value) => setState(() => _selectedOption = value!),
              ),
              SignupOptionsRadioButtons<String>(
                value: option2!,
                groupValue: _selectedOption,
                icon: Iconsax.user_cirlce_add4,
                onImage: './assets/svgs/coach_gradient.svg',
                offImage: './assets/svgs/coach_grey.svg',
                title: "Coach/Player".tr(),
                subTitle:
                    "Use your email access to set up your profile and start analyzing"
                        .tr(),
                onChanged: (value) => setState(() => _selectedOption = value!),
              ),
              SizedBox(height: 40.h),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: AppButton(
                  isDisabled: _selectedOption == '',
                  buttonText: "Continue".tr(),
                  buttonType: ButtonType.primary,
                  onPressed: () {
                    serviceLocator.get<NavigationService>().toWithPameter(
                        routeName: RouteKeys.routeSignupSocialMediaScreen,
                        data: {
                          "option": _selectedOption,
                        });
                  },
                ),
              ),
              SizedBox(height: 80.h),
            ],
          ),
        ),
      ),
    );
  }
}
