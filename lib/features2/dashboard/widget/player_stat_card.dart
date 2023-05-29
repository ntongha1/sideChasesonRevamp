import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/colors.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/styles.dart';

class PlayerStatCard extends StatelessWidget {
  final String? headingText;
  final double? height;
  final List<Map>? myList;

  const PlayerStatCard({
    Key? key,
    required this.headingText,
    required this.height,
    required this.myList
  })  : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        //padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              headingText!,
              textAlign: TextAlign.center,
              style: AppStyle.text2.copyWith(color: AppColors.sonaGrey4),
            ),
            SizedBox(height: 10.h),
            Container(
                height: height!,
                padding: EdgeInsets.symmetric(horizontal: 20.h),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: AppColors.sonaGrey6,
                  borderRadius: BorderRadius.all(Radius.circular(AppConstants.normalRadius)),
                ),
            child: Container(
                child: ListView.separated(
                  itemCount: myList!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Text(
                        myList![index]["leading"].toString(),
                        textAlign: TextAlign.center,
                        style: AppStyle.text2.copyWith(color: AppColors.sonaGrey2),
                      ),
                      trailing: Text(
                        myList![index]["trailing"].toString(),
                        textAlign: TextAlign.center,
                        style: AppStyle.text2.copyWith(color: AppColors.sonaBlack2),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Container(
                        height: 1,
                        color: AppColors.sonaGrey5
                    );
                  },
                ))),
            SizedBox(height: 20.h),
          ],
        ));
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
