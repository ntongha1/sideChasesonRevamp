import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:sonalysis/core/navigation/navigation_service.dart';
import 'package:sonalysis/core/utils/colors.dart';
import 'package:sonalysis/core/utils/constants.dart';
import 'package:sonalysis/core/utils/images.dart';

import '../startup/app_startup.dart';
import '../utils/styles.dart';
import 'button.dart';

class PopUpPageScreen extends StatefulWidget {
  final Map? data;

  const PopUpPageScreen({Key? key, this.data}) : super(key: key);

  @override
  _PopUpPageScreenState createState() => _PopUpPageScreenState();
}

class _PopUpPageScreenState extends State<PopUpPageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        color: AppColors.sonaBlack.withOpacity(0.7),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                margin: EdgeInsets.only(bottom: 40),
                decoration: BoxDecoration(
                  // give a border radius to the container
                  borderRadius: BorderRadius.circular(AppConstants.cardRadius),
                  color: AppColors.sonaWhite,
                ),
                child: Container(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 60),
                        SvgPicture.asset('assets/svgs/check_gradient_big.svg'),
                        SizedBox(height: 40),
                        Text(
                          widget.data!["title"],
                          textAlign: TextAlign.center,
                          style: AppStyle.text3.copyWith(
                              color: AppColors.sonaBlack2,
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(height: 20),
                        Text(
                          widget.data!["subTitle"],
                          textAlign: TextAlign.center,
                          style: AppStyle.text1.copyWith(
                              color: AppColors.sonaGrey2,
                              fontWeight: FontWeight.w400),
                        ),
                        Container(
                            margin: const EdgeInsets.only(top: 40, bottom: 40),
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: AppButton(
                                buttonText: widget.data!["buttonText"]! ??
                                    "continue".tr(),
                                onPressed: () {
                                  _nextPage(context);
                                }))
                      ]),
                ),
              )
            ]),
      ),
    );
  }

  Future<void> _nextPage(BuildContext context) async {
    if (widget.data!["routeType"] == "pop") {
      Navigator.of(context).pop(true);
    }
    if (widget.data!["routeType"] == "callback") {
      widget.data!["callback"]();
    }
    if (widget.data!["routeType"] == "ClearAll") {
      if (widget.data!["routeData"] == null) {
        serviceLocator
            .get<NavigationService>()
            .clearAllTo(widget.data!["route"]);
      } else {
        serviceLocator.get<NavigationService>().clearAllWithParameter(
            routeName: widget.data!["route"], data: widget.data!["routeData"]);
      }
    }
  }
}
