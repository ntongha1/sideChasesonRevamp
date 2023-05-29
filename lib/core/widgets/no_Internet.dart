import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:lottie/lottie.dart';
import 'package:sonalysis/core/utils/colors.dart';
import 'package:sonalysis/core/utils/images.dart';

import '../navigation/keys.dart';
import '../navigation/navigation_service.dart';
import '../startup/app_startup.dart';
import 'button.dart';

class ConnectionFailedScreen extends StatelessWidget {
  const ConnectionFailedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sonaBlack,
      body: Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                AppAssets.lottieNoInternet,
                repeat: true,
                height: 200.h,
                width: 200.w,
              ),
              SizedBox(height: 20.h),
              Text(
                "no_internet_connection".tr(),
                style: TextStyle(
                    color: Colors.white,
                  fontSize: 20.sp
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 50.w),
                child: AppButton(
                    buttonText: "retry".tr(),
                    onPressed: () {
                      serviceLocator.get<NavigationService>().clearAllTo(RouteKeys.routeSplash);
                    }),
              ),
            ],
          )
      ),
    );
  }
}
