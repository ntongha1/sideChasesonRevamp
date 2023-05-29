import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonalysis/core/utils/images.dart';
import 'package:sonalysis/core/utils/styles.dart';

import '../../core/utils/colors.dart';

class OnboardingWrapper extends StatelessWidget {
  String image, header, subHeader;

  OnboardingWrapper(
      {Key? key,
      required this.image,
      required this.header,
      required this.subHeader})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.54,
          width: double.infinity,
          child: Image.asset(
            image,
            fit: BoxFit.cover,
            repeat: ImageRepeat.noRepeat,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          margin: EdgeInsets.only(top: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                header,
                style: AppStyle.h2.copyWith(
                  color: AppColors.sonaBlack2,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.83,
                  child: Text(
                    subHeader,
                    textAlign: TextAlign.center,
                    style: AppStyle.text2.copyWith(
                        color: AppColors.sonaGrey4,
                        fontWeight: FontWeight.w400),
                  ))
            ],
          ),
        )
      ],
    );
  }
}
