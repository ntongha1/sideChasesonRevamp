import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/utils/colors.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/styles.dart';

class DashboardCard extends StatelessWidget {
  final String? headingText;
  final String? counterText;
  final String? subText;
  final String? image;
  final Color? bgColor;
  final bool? isLoading;

  const DashboardCard({
    Key? key,
    required this.headingText,
    required this.counterText,
    required this.subText,
    required this.image,
    required this.bgColor,
    this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: bgColor!,
              borderRadius:
                  BorderRadius.all(Radius.circular(AppConstants.normalRadius)),
            ),
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      headingText!,
                      textAlign: TextAlign.center,
                      style: AppStyle.text2.copyWith(
                          color: AppColors.sonaWhite,
                          fontWeight: FontWeight.w400),
                    ),
                    Image.asset(
                      image!,
                      width: 30,
                      color: AppColors.sonaWhite,
                    )
                  ],
                ),
                SizedBox(height: 20.h),
                (isLoading ?? false)
                    ? Padding(
                        padding: EdgeInsets.symmetric(vertical: 13),
                        child: _loadingWidget(),
                      )
                    : Text(
                        counterText!,
                        textAlign: TextAlign.center,
                        style: AppStyle.h3.copyWith(
                            color: AppColors.sonaWhite,
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w700),
                      ),
                SizedBox(height: 15.h),
                // Text(
                //   subText!,
                //   textAlign: TextAlign.center,
                //   style: AppStyle.text1.copyWith(
                //       color: AppColors.sonaWhite,
                //       fontStyle: FontStyle.italic,
                //       fontWeight: FontWeight.w400),
                // ),
              ],
            ))
      ],
    );
  }
}

Widget _loadingWidget() => Center(
      child: SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          color: AppColors.sonaWhite,
          strokeWidth: 2.0,
        ),
      ),
    );
