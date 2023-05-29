import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonalysis/core/utils/colors.dart';

import '../utils/styles.dart';

class EmptyResponseWidget extends StatelessWidget {
  final String? buttonText, route;
  final String msg;
  final IconData iconData;
  final bool? showButton;
  final double? height;

  const EmptyResponseWidget({
    Key? key,
    required this.iconData,
    required this.msg,
    this.showButton = false,
    this.height = 0.1,
    this.buttonText,
    this.route,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Center(
        child: Container(
      margin: EdgeInsets.symmetric(vertical: size.width * height!),
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: Column(
        children: [
          Icon(iconData, size: 60.0, color: AppColors.sonaGrey4),
          SizedBox(height: 40.h),
          Text(
            msg,
            textAlign: TextAlign.center,
            style: AppStyle.text3.copyWith(fontWeight: FontWeight.w400),
          ),
          SizedBox(height: 20.h),
          showButton! && buttonText != null
              ? SizedBox(
                  width: size.width - 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: SizedBox(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: const Color.fromRGBO(36, 36, 36, 1),
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                            ),
                            child: Text(
                              buttonText!,
                              style: TextStyle(
                                color: const Color.fromRGBO(211, 188, 166, 1),
                                fontWeight: FontWeight.w800,
                                fontSize: 18.sp,
                              ),
                            ),
                            onPressed: () async {
                              Navigator.of(context).pushNamed(route ?? '');
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Container()
        ],
      ),
    ));
  }
}
