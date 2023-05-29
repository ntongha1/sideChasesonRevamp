import 'package:sonalysis/core/navigation/navigation_service.dart';
import 'package:sonalysis/core/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

import '../startup/app_startup.dart';

class InformationModalWidget extends StatefulWidget {
  const InformationModalWidget({
    Key? key,
    required this.typeIsError,
    required this.description,
  }) : super(key: key);

  final String description;
  final bool typeIsError;

  @override
  _InformationModalWidgetState createState() => _InformationModalWidgetState();
}

class _InformationModalWidgetState extends State<InformationModalWidget> {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: CupertinoPageScaffold(
      child: Container(
        color: Colors.black.withOpacity(0.8),
        height: 280.h,
        child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0.r),
                topRight: Radius.circular(30.0.r),
              ),
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 20.h, bottom: 10.h),
                  padding: EdgeInsets.only(left: 32.0.w, right: 32.0.w),
                  child: Text(
                    widget.typeIsError ? "Error!!!" : "Success!!!",
                    textAlign: TextAlign.center,
                    style: widget.typeIsError
                        ? TextStyle(
                            fontSize: 18.sp,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          )
                        : TextStyle(
                            color: Colors.green,
                            fontSize: 18.0.sp,
                            height: 1.2,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.bold,
                          ),
                  ),
                ),
                Divider(height: 1.h),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 40.h),
                  padding: EdgeInsets.symmetric(horizontal: 80.w),
                  child: Text(
                    widget.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF242F40),
                      fontSize: 16.sp,
                      height: 1.3,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      alignment: Alignment.center,
                      child: ButtonTheme(
                          minWidth: MediaQuery.of(context).size.width * 0.9,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: AppColors.sonaBlack,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.r),
                              ),
                            ),
                            child: Text(
                              'OK',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0.sp,
                                height: 1,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            onPressed: () =>
                                serviceLocator.get<NavigationService>().pop(),
                          )),
                    ),
                  ],
                )
              ],
            )),
      ),
    ));
  }
}
