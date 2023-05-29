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

class AddStaffsScreen extends StatefulWidget {
  final Map? data;

  const AddStaffsScreen({Key? key, this.data}) : super(key: key);

  @override
  _AddStaffsScreenState createState() => _AddStaffsScreenState();
}

class _AddStaffsScreenState extends State<AddStaffsScreen> {
  String listofNames() {
    String n = "";
    for (int i = 0; i < widget.data!["players"].length; i++) {
      n = n + widget.data!["players"][i].user.firstName!;
      if (i != widget.data!["players"].length - 1) {
        n = n + ", ";
      }
    }
    return n;
  }

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
                        PicturesOfPlayers(),
                        SizedBox(height: 10),
                        Text(
                          listofNames(),
                          textAlign: TextAlign.center,
                          style: AppStyle.text1.copyWith(
                              color: AppColors.sonaGrey3,
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(height: 40),
                        Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: Text(
                              "You are about to move " +
                                  widget.data!["players"].length.toString() +
                                  " staffs from their current team",
                              textAlign: TextAlign.center,
                              style: AppStyle.text1.copyWith(
                                  color: AppColors.sonaGrey2,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.only(top: 40, bottom: 40),
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: AppButton(
                                buttonText: "Add staffs".tr(),
                                onPressed: () {
                                  widget.data!["yes"]();
                                }))
                      ]),
                ),
              )
            ]),
      ),
    );
  }

  Widget PicturesOfPlayers() {
    int start = 0;
    int len = widget.data!["players"].length;
    double pr = len * 15.0;

    return Container(
      height: 60,
      width: (MediaQuery.of(context).size.width * 0.8),
      padding: EdgeInsets.only(right: pr),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: List.generate(
            widget.data!["players"].length,
            (index) => (index < 2)
                ? Positioned.fill(
                    left: index * 50,
                    child: Align(
                      child: SizedBox(
                        height: 60,
                        width: 60,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 5,
                              color: AppColors.sonaWhite,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.network(
                              (widget.data!["players"][index].user!.photo ==
                                          null ||
                                      widget.data!["players"][index].user
                                              .photo ==
                                          "same")
                                  ? AppConstants.defaultProfilePictures
                                  : widget.data!["players"][index].user.photo,
                              height: 58.0,
                              width: 58.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : (index == 2)
                    ? Positioned.fill(
                        left: index * 50,
                        child: Align(
                          child: SizedBox(
                            height: 60,
                            width: 60,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 5,
                                  color: AppColors.sonaWhite,
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Container(
                                width: 58,
                                height: 58,
                                decoration: BoxDecoration(
                                  color: AppColors.sonaGrey2,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Center(
                                  child: Text(
                                    "+" +
                                        (widget.data!["players"].length - 2)
                                            .toString(),
                                    style: AppStyle.text1.copyWith(
                                        color: AppColors.sonaWhite,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(),
          ),
        ),
      ),
    );
  }
}
