import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:sonalysis/core/utils/colors.dart';
import 'package:sonalysis/core/utils/styles.dart';

import '../../../core/navigation/keys.dart';
import '../../../core/navigation/navigation_service.dart';
import '../../../core/startup/app_startup.dart';
import '../../../core/widgets/CustomSwitch.dart';
import '../../../core/widgets/GradientProgressBar.dart';
import '../../../core/widgets/appBar/appbarUnauth.dart';
import '../../../core/widgets/button.dart';
import '../widgets/choose_sub_radio_button.dart';

class ChooseSubscriptionPlanScreen extends StatefulWidget {
  const ChooseSubscriptionPlanScreen({Key? key}) : super(key: key);

  @override
  _ChooseSubscriptionPlanScreenState createState() =>
      _ChooseSubscriptionPlanScreenState();
}

class _ChooseSubscriptionPlanScreenState
    extends State<ChooseSubscriptionPlanScreen> {
  bool? canSubmit = false, annualPayment = true;
  int _value = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarUnauth(),
      backgroundColor: AppColors.sonaWhite,
      body: Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          child: ListView(
            children: [
              Text(
                "Choose subscription plan"
                    .tr(namedArgs: {"this": "4", "that": "5"}),
                textAlign: TextAlign.left,
                style: AppStyle.text2.copyWith(
                    color: AppColors.sonaGrey2, fontWeight: FontWeight.w400),
              ).tr(),
              SizedBox(height: 10.h),
              GradientProgressBar(
                percent: 80,
                gradient: AppColors.sonalysisGradient,
                backgroundColor: AppColors.sonaGrey6,
              ),
              SizedBox(height: 40.h),
              Text(
                "Choose subscription plan2".tr(),
                textAlign: TextAlign.center,
                style: AppStyle.h3.copyWith(
                    color: AppColors.sonaBlack2, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 10.h),
              Text(
                "Select one to proceed".tr(),
                textAlign: TextAlign.center,
                style: AppStyle.text2.copyWith(
                    color: AppColors.sonaGrey2.withOpacity(0.4),
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 40.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Monthly Billing".tr(),
                    textAlign: TextAlign.center,
                    style: AppStyle.text3.copyWith(
                        color: annualPayment!
                            ? AppColors.sonaGrey2
                            : AppColors.sonaBlack2,
                        fontWeight: FontWeight.w400),
                  ),
                  CustomSwitch(
                    value: annualPayment!,
                    onChanged: (bool val) {
                      setState(() {
                        annualPayment = val;
                      });
                    },
                  ),
                  Text(
                    "Annual Billing".tr(),
                    textAlign: TextAlign.center,
                    style: AppStyle.text2.copyWith(
                        color: annualPayment!
                            ? AppColors.sonaBlack2
                            : AppColors.sonaGrey3,
                        fontWeight:
                            annualPayment! ? FontWeight.w500 : FontWeight.w400),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              ChooseSubRadioButtons<int>(
                value: 1,
                groupValue: _value,
                type: "Starter".tr(),
                price: annualPayment! ? "\$30" : "\$10",
                price_per: annualPayment! ? " / year".tr() : " / month".tr(),
                features: [
                  "Feature".tr(namedArgs: {"num": "1"}),
                  "Feature".tr(namedArgs: {"num": "2"}),
                  "Feature".tr(namedArgs: {"num": "3"}),
                  "Feature".tr(namedArgs: {"num": "4"})
                ],
                onChanged: (value) => setState(() => _value = value!),
              ),
              SizedBox(height: 20.h),
              ChooseSubRadioButtons<int>(
                value: 2,
                groupValue: _value,
                type: "Premium".tr(),
                price: annualPayment! ? "\$100" : "\$15",
                price_per: annualPayment! ? " / year".tr() : " / month".tr(),
                features: [
                  "Feature".tr(namedArgs: {"num": "1"}),
                  "Feature".tr(namedArgs: {"num": "2"}),
                  "Feature".tr(namedArgs: {"num": "3"}),
                  "Feature".tr(namedArgs: {"num": "4"})
                ],
                onChanged: (value) => setState(() => _value = value!),
              ),
              SizedBox(height: 40.h),
              AppButton(
                  buttonText: "continue".tr(),
                  onPressed: () {
                    serviceLocator
                        .get<NavigationService>()
                        .to(RouteKeys.routeChoosePaymentMethodScreen);
                  }),
              SizedBox(height: 20.h),
            ],
          )),
    );
  }
}
