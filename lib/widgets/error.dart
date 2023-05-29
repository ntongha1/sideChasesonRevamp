import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomError extends StatelessWidget {
  final String error;
  final bool center;

  const CustomError({Key? key, required this.error, this.center=false}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if(error==null)return SizedBox.shrink();

    String modError=error;
    if(modError.contains("*"))modError=modError.replaceAll(' *', '');
    return Row(
      mainAxisAlignment: center ? MainAxisAlignment.center : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(error!=null && error.isNotEmpty)
          Image.asset(
            'assets/images/error.png',
            height: 13.h,
            width: 15.w,
          ),
        SizedBox(width: 8,),
        center ? Text(
          modError,
          style: TextStyle(
            color: Colors.red,
            //fontFamily: generalFont,
            fontSize: 12.0.sp,
            height: 1,
            decoration: TextDecoration.underline,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.bold,
          ).copyWith(decoration: TextDecoration.none, fontWeight: FontWeight.w400, height: 1.3),
        ) : Expanded(
          child: Text(
            modError,
            style: TextStyle(
              color: Colors.red,
              //fontFamily: generalFont,
              fontSize: 12.0.sp,
              height: 1,
              decoration: TextDecoration.underline,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.bold,
            ).copyWith(decoration: TextDecoration.none, fontWeight: FontWeight.w400, height: 1.3),
          ),
        )
      ],
    );
  }
}