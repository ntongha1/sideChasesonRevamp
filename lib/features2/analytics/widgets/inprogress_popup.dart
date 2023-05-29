import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sonalysis/core/datasource/key.dart';
import 'package:sonalysis/core/datasource/local_storage.dart';
import 'package:sonalysis/core/models/response/UserResultModel.dart';
import 'package:sonalysis/core/navigation/navigation_service.dart';
import 'package:sonalysis/core/utils/colors.dart';
import 'package:sonalysis/core/utils/styles.dart';
import 'package:sonalysis/helpers/helpers.dart';

import '../../../core/startup/app_startup.dart';
import '../../../core/utils/constants.dart';
import '../../../core/widgets/GradientProgressBar.dart';

class InProgressPopUpScreen extends StatefulWidget {
  final Map? data;

  const InProgressPopUpScreen({Key? key, this.data}) : super(key: key);

  @override
  _InProgressPopUpScreenState createState() => _InProgressPopUpScreenState();
}

class _InProgressPopUpScreenState extends State<InProgressPopUpScreen> {
  String? _homeTeam, _awayTeam;
  UserResultData? userResultData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData() async {
    userResultData = await serviceLocator.get<LocalStorage>().readSecureObject(LocalStorageKeys.kUserPrefs);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.normalRadius)),
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      backgroundColor: AppColors.sonaWhite,
      content: Container(
        decoration: BoxDecoration(
            borderRadius:  BorderRadius.all(Radius.circular(AppConstants.normalRadius))),
        width: MediaQuery.of(context).size.width,
        height: 280,
        child: ListView(
            children: [
              const SizedBox(height: 10),
              InkWell(
                  onTap: () {
                    serviceLocator.get<NavigationService>().pop();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Boxicons.bx_x_circle,
                      color: AppColors.sonaBlack2,
                      size: 30,
                    ),
                  )),
              const SizedBox(height: 10),
              Text(
                widget.data!["title"],
                textAlign: TextAlign.center,
                style:  AppStyle.text3.copyWith(fontSize: 18.sp, color: AppColors.sonaBlack2),
              ),
              const SizedBox(height: 20),
              Text(
                  widget.data!["subTitle"],
                  textAlign: TextAlign.center,
                  style: AppStyle.text1),
              SizedBox(height: 10.h),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 0.0.w, vertical: 30.0.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              widget.data!["title"],
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: AppStyle.text0.copyWith(fontSize: 10.sp),
                            ),
                            SizedBox(width: 200.h),
                            Text(
                              capitalizeSentence(widget.data!["progress"].toString()+"%"),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: AppStyle.text0.copyWith(fontSize: 10.sp, color: AppColors.sonaBlack2),
                            ),
                          ],
                        ),
                        SizedBox(height: 15.h),
                        SizedBox(
                          width: MediaQuery.of(context).size.width *0.81,
                          child: GradientProgressBar(
                            percent: widget.data!["progress"],
                            gradient: AppColors.sonalysisGradient,
                            backgroundColor: AppColors.sonaGrey4,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Iconsax.video5,
                                color: AppColors.sonaBlack2,
                                size: 18.sp,
                              ),
                              SizedBox(width: 10.h),
                              SizedBox(
                            width: 180.0,
                            child: Text(
                                widget.data!["filename"],
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                textAlign: TextAlign.center,
                                style: AppStyle.text2.copyWith(fontSize: 10.sp, color: AppColors.sonaBlack2),
                              )),
                            ],
                          ),
                      ],
                    )
                  ],
                ),
              )
            ]),
      ),
    );
  }

}
