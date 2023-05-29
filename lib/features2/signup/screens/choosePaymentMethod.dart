import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sonalysis/core/utils/colors.dart';
import 'package:sonalysis/core/utils/styles.dart';

import '../../../core/config/config.dart';
import '../../../core/datasource/key.dart';
import '../../../core/datasource/local_storage.dart';
import '../../../core/enums/user_type.dart';
import '../../../core/models/response/UserResultModel.dart';
import '../../../core/navigation/keys.dart';
import '../../../core/navigation/navigation_service.dart';
import '../../../core/startup/app_startup.dart';
import '../../../core/utils/images.dart';
import '../../../core/utils/response_message.dart';
import '../../../core/widgets/GradientProgressBar.dart';
import '../../../core/widgets/appBar/appbarUnauth.dart';
import '../../../core/widgets/button.dart';
import '../cubit/signup_cubit.dart';
import '../widgets/payment_method_radio_button.dart';

class ChoosePaymentMethodScreen extends StatefulWidget {
  ChoosePaymentMethodScreen({Key? key}) : super(key: key);

  @override
  _ChoosePaymentMethodScreenState createState() =>
      _ChoosePaymentMethodScreenState();
}

class _ChoosePaymentMethodScreenState extends State<ChoosePaymentMethodScreen> {
  bool? canSubmit = false;
  int _value = 1;
  var publicKey = AppConfig.paystackSecretKey;
  final plugin = PaystackPlugin();
  UserResultData? userResultData;

  @override
  void initState() {
    super.initState();
    plugin.initialize(publicKey: publicKey);
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
      appBar: AppBarUnauth(),
      backgroundColor: AppColors.sonaWhite,
      body: Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          child: ListView(
            children: [
              Text(
                "Payment".tr(namedArgs: {"this": "5", "that": "5"}),
                textAlign: TextAlign.left,
                style: AppStyle.text2.copyWith(
                    color: AppColors.sonaGrey2, fontWeight: FontWeight.w400),
              ).tr(),
              SizedBox(height: 10.h),
              GradientProgressBar(
                percent: 100,
                gradient: AppColors.sonalysisGradient,
                backgroundColor: AppColors.sonaGrey6,
              ),
              SizedBox(height: 40.h),
              Text(
                "Choose payment method".tr(),
                textAlign: TextAlign.center,
                style: AppStyle.h3.copyWith(
                    color: AppColors.sonaBlack2, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 10.h),
              Text(
                "Select one to proceed".tr(),
                textAlign: TextAlign.center,
                style: AppStyle.text2.copyWith(
                    color: AppColors.sonaGrey2, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 40.h),
              ChoosePaymentMethodRadioButtons<int>(
                value: 1,
                groupValue: _value,
                title: "Pay with debit card".tr(),
                subTitle: "Use you visa or master card for payment".tr(),
                onChanged: (value) => setState(() => _value = value!),
              ),
              SizedBox(height: 20.h),
              ChoosePaymentMethodRadioButtons<int>(
                value: 2,
                groupValue: _value,
                title: "Pay with bank".tr(),
                subTitle: "Pay through your local bank".tr(),
                onChanged: (value) => setState(() => _value = value!),
              ),
              SizedBox(height: 20.h),
              ChoosePaymentMethodRadioButtons<int>(
                value: 3,
                groupValue: _value,
                title: "Pay with USSD".tr(),
                subTitle: "Pay with USSD".tr(),
                onChanged: (value) => setState(() => _value = value!),
              ),
              SizedBox(height: 40.h),
              AppButton(
                  buttonText: "continue".tr(),
                  onPressed: () async {
                    //do pay stack first
                    var random = Random();
                    //do payment
                    Charge charge = Charge()
                      ..amount = 2000 * 100
                      ..reference = 'sonalysis-${random.nextInt(1000000000)}'
                      // or ..accessCode = _getAccessCodeFrmInitialization()
                      ..email = userResultData!.user!.email;
                    CheckoutResponse response = await plugin.checkout(
                      context,
                      method: CheckoutMethod
                          .card, // Defaults to CheckoutMethod.selectable
                      charge: charge,
                      fullscreen: false,
                      logo: Image.asset(
                        AppAssets.logo,
                        width: 60,
                        fit: BoxFit.fitWidth,
                      ),
                    );

                    debugPrint("Response = $response");
                    if (response.status != false && response.method != null) {
                      //update db with paid true
                      await serviceLocator<SignupCubit>()
                          .updateUserPayment(userResultData!.user!.id);
                    } else {
                      _onPaymentCancelled(context);
                    }
                  }),
              SizedBox(height: 80.h),
              BlocConsumer(
                bloc: serviceLocator.get<SignupCubit>(),
                listener: (_, state) {
                  if (state is UpdateUserPaymentLoading) {
                    context.loaderOverlay.show();
                  }

                  if (state is UpdateUserPaymentError) {
                    context.loaderOverlay.hide();
                    setState(() {
                      canSubmit = true;
                    });
                    ResponseMessage.showErrorSnack(
                        context: context, message: state.message);
                  }

                  if (state is UpdateUserPaymentSuccess) {
                    context.loaderOverlay.hide();
                    //show dialog page
                    serviceLocator.get<NavigationService>().toWithPameter(
                        routeName: RouteKeys.routePopUpPageScreen,
                        data: {
                          "title": "Payment successfully".tr(),
                          "subTitle": "Proceed to dashboard".tr(),
                          "route": RouteKeys.routeBottomNaviScreen,
                          "routeType": "ClearAll",
                          "buttonText": "continue".tr()
                        });
                  }
                },
                builder: (_, state) {
                  return const SizedBox();
                },
              )
            ],
          )),
    );
  }

  void _onPaymentCancelled(BuildContext context) {
    print("++Cancelled");
    //
  }

  void _onPaymentPending() {
    print("++Pending");
    //
  }

  void _onPaymentFailed() {
    print("++Failed");
    // Scaffold.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text('Payment Failed'),
    //   ),
    // );
  }
}
