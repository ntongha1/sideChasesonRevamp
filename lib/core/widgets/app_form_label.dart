import 'package:sonalysis/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/styles.dart';

class AppLabel extends StatelessWidget {
  final String? headerText;
  final String? descriptionText;
  const AppLabel({
    Key? key,
    this.headerText,
    this.descriptionText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String title = headerText ?? '';
    String subtitle = descriptionText ?? '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(),
            child: RichText(
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              text: TextSpan(
                text: title.replaceAll('*', '').replaceAll('(Optional)', ''),
                style: AppStyle.text2.copyWith(
                    color: AppColors.sonaBlack2, fontWeight: FontWeight.w400),
                children: [
                  if (title.trim().endsWith('(Optional)'))
                    TextSpan(
                      text: '(Optional)',
                      style: AppStyle.text1,
                    ),
                  if (title.trim().endsWith('*'))
                    TextSpan(
                      text: '*',
                      style: AppStyle.text2.copyWith(color: AppColors.sonaRed),
                    ),
                ],
              ),
            ),
          ),
        if (subtitle.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Text(
              subtitle,
              style: AppStyle.text1
                  .copyWith(color: AppColors.sonaRed.withOpacity(0.7)),
            ),
          ),
      ],
    );
  }
}
