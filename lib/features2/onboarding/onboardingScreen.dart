import 'dart:io';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonalysis/core/enums/button.dart';
import 'package:sonalysis/core/navigation/keys.dart';
import 'package:sonalysis/core/navigation/navigation_service.dart';
import 'package:sonalysis/core/utils/colors.dart';
import 'package:sonalysis/core/widgets/button.dart';

import '../../core/startup/app_startup.dart';
import 'models/onboarding_model.dart';
import 'onboardingWrapper.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  List<OnboardingModel> slides = <OnboardingModel>[];
  var currentIndex = 0;
  PageController pageController = PageController(initialPage: 0);

  nav() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (context) => AuthHome()));
    });
  }

  @override
  void initState() {
    super.initState();
    slides = getSlides();
  }

  Widget pageIndicator(bool isCurrentPage) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3.0),
      height: 6.0,
      width: 6.0,
      decoration: BoxDecoration(
          color: isCurrentPage
              ? AppColors.sonaBlack2
              : AppColors.sonaBlack2.withOpacity(0.3),
          borderRadius: BorderRadius.circular(3.0)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        SizedBox(
          height: // 50% of the screen height
              MediaQuery.of(context).size.height * 0.75,
          width: double.infinity,
          child: PageView.builder(
            controller: pageController,
            itemCount: slides.length,
            onPageChanged: (val) {
              setState(() {
                currentIndex = val;
              });
            },
            itemBuilder: (context, index) {
              return SingleChildScrollView(
                child: Column(children: [
                  OnboardingWrapper(
                    image: slides[index].getImage(),
                    header: slides[index].getHeader(),
                    subHeader: slides[index].getSubHeader(),
                  ),
                ]),
              );
            },
          ),
        ),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  for (var i = 0; i < slides.length; i++)
                    currentIndex == i
                        ? pageIndicator(true)
                        : pageIndicator(false)
                ],
              ),
            )),
        SizedBox(
          height: 40.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: AppButton(
                  key: const Key('signup_button'),
                  buttonText: "signup".tr(),
                  buttonType: ButtonType.primary,
                  onPressed: () => serviceLocator
                      .get<NavigationService>()
                      .to(RouteKeys.routeSignupOptionScreen),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.025,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: AppButton(
                  key: const Key('login_button'),
                  buttonText: 'login'.tr(),
                  buttonType: ButtonType.secondary,
                  onPressed: () => serviceLocator
                      .get<NavigationService>()
                      .to(RouteKeys.routeLoginScreen),
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
