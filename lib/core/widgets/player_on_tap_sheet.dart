import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonalysis/core/navigation/navigation_service.dart';
import 'package:sonalysis/core/utils/colors.dart';
import 'package:sonalysis/core/utils/constants.dart';

import '../startup/app_startup.dart';
import '../utils/styles.dart';
import 'button.dart';

PlayerOnTapSheet(final Map? data, BuildContext context, Function closeModal) {
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
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    // give a border radius to the container
                    borderRadius:
                        BorderRadius.circular(AppConstants.cardRadius),
                    color: AppColors.sonaWhite,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                            Radius.circular(AppConstants.normalRadius))),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                              onTap: () {
                                closeModal();
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
                          SizedBox(height: 40),
                          for (int i = 0; i < data!["buttons"].length; i++)
                            data["buttons"][i] == null
                                ? Container()
                                : Container(
                                    margin: const EdgeInsets.only(bottom: 20),
                                    width: MediaQuery.of(context).size.width,
                                    child: AppButton(
                                        buttonType: data["buttons"][i]
                                            ["buttonType"],
                                        buttonText: data["buttons"][i]
                                            ["buttonText"],
                                        onPressed: data["buttons"][i]
                                            ["onPressed"]))
                        ]),
                  ),
                )
              ])));
}
