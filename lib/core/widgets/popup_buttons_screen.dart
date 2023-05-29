
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonalysis/core/navigation/navigation_service.dart';
import 'package:sonalysis/core/utils/colors.dart';
import 'package:sonalysis/core/utils/constants.dart';

import '../startup/app_startup.dart';
import '../utils/styles.dart';
import 'button.dart';

PopUpButtonsScreen(final Map? data, BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.sonaWhite,
          content: Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                    Radius.circular(AppConstants.normalRadius))),
            width: MediaQuery.of(context).size.width,
            height: 280,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
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
                  Text(
                    data!["title"],
                    textAlign: TextAlign.center,
                    style: AppStyle.text3.copyWith(
                        color: AppColors.sonaBlack2,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: 12),
                  Text(
                    data["subTitle"],
                    textAlign: TextAlign.center,
                    style: AppStyle.text2.copyWith(
                        color: AppColors.sonaBlack2,
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp),
                  ),
                  SizedBox(height: 30),
                  for (int i=0; i < data["buttons"].length; i++)
                  Container(
                      margin: const EdgeInsets.only(top: 20),
                      width: MediaQuery.of(context).size.width,
                      child: AppButton(
                          buttonType: data["buttons"][i]["buttonType"],
                          buttonText: data["buttons"][i]["buttonText"],
                          onPressed: data["buttons"][i]["onPressed"]
                      ))
                ]),
          ),
        );
      });
}
