import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sonalysis/core/utils/colors.dart';
import 'package:sonalysis/core/utils/constants.dart';
import 'package:sonalysis/core/utils/helpers.dart';
import 'package:sonalysis/core/utils/styles.dart';

import '../../../core/enums/button.dart';
import '../../../core/navigation/keys.dart';
import '../../../core/navigation/navigation_service.dart';
import '../../../core/startup/app_startup.dart';
import '../../../core/widgets/appBar/appbarUnauth.dart';
import '../../../core/widgets/button.dart';
import '../widgets/signup_options_radio_button.dart';

class SocialMediasignupScreen extends StatefulWidget {
  const SocialMediasignupScreen({Key? key, required this.data})
      : super(key: key);

  final Map? data;
  @override
  _SocialMediasignupScreenState createState() =>
      _SocialMediasignupScreenState();
}

class _SocialMediasignupScreenState extends State<SocialMediasignupScreen> {
  String? option1 = "clubAdmin", option2 = "coach_player";
  // String _selectedOption = widget.data!['option']!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarUnauth(),
      backgroundColor: AppColors.sonaWhite,
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 34.h),
            Text(
              "How would you like to sign-up?".tr(),
              textAlign: TextAlign.center,
              style: AppStyle.h3.copyWith(color: AppColors.sonaBlack2),
            ),
            SizedBox(height: 40.h),
            GestureDetector(
              onTap: (() => {
                    showToast("Google login under development".tr(), "error"),
                  }),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 14.5),
                decoration: BoxDecoration(
                    color: AppColors.sonaGrey6,
                    borderRadius:
                        BorderRadius.circular(AppConstants.smallRadius)),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/svgs/google_icon.svg',
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        "Sign up with Google".tr(),
                        textAlign: TextAlign.center,
                        style: AppStyle.text2.copyWith(
                            color: AppColors.sonaBlack2,
                            fontWeight: FontWeight.w400),
                      ),
                    ]),
              ),
            ),
            SizedBox(height: 20.h),
            GestureDetector(
              onTap: (() => {
                    showToast("Twitter login under development".tr(), "error"),
                  }),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 14.5),
                decoration: BoxDecoration(
                    color: AppColors.sonaGrey6,
                    borderRadius:
                        BorderRadius.circular(AppConstants.smallRadius)),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/svgs/twitter_icon.svg',
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        "Sign up with Twitter".tr(),
                        textAlign: TextAlign.center,
                        style: AppStyle.text2.copyWith(
                            color: AppColors.sonaBlack2,
                            fontWeight: FontWeight.w400),
                      ),
                    ]),
              ),
            ),
            SizedBox(height: 20.h),
            GestureDetector(
              onTap: (() => {
                    showToast("LinkedIn login under development".tr(), "error"),
                  }),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 14.5),
                decoration: BoxDecoration(
                    color: AppColors.sonaGrey6,
                    borderRadius:
                        BorderRadius.circular(AppConstants.smallRadius)),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/svgs/linkedin_icon.svg',
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        "Sign up with LinkedIn".tr(),
                        textAlign: TextAlign.center,
                        style: AppStyle.text2.copyWith(
                            color: AppColors.sonaBlack2,
                            fontWeight: FontWeight.w400),
                      ),
                    ]),
              ),
            ),
            SizedBox(height: 20.h),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: AppButton(
                buttonText: "Sign up with mail".tr(),
                buttonType: ButtonType.primary,
                onPressed: () => widget.data!['option'] == option1
                    ? serviceLocator
                        .get<NavigationService>()
                        .to(RouteKeys.routeCreateCLubAccountEmailScreen)
                    : serviceLocator.get<NavigationService>().toWithPameter(
                        routeName:
                            RouteKeys.routeCreatePlayerCoachAccountRevamp,
                        data: {"no": "lol"}),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
