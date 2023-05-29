import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonalysis/helpers/helpers.dart';
import 'package:sonalysis/style/styles.dart';

class DummyTextField extends StatelessWidget {
  const DummyTextField({
    Key? key,
    required this.text,
    required this.labelText,
  }) : super(key: key);

  final String text, labelText;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          textAlign: TextAlign.start,
          style: TextStyle(
            color: getColorHexFromStr("C9D0CD"),
            //fontFamily: generalFont,
            fontSize: 14.sp,
            height: 1.3,
            fontStyle: FontStyle.normal,
          ),
        ),
        SizedBox(
          height: 7.h,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.w),
            border: Border.all(color: Color(0xFFffffff)),
            color: sonaBlack,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Text(
            text,
            textAlign: TextAlign.start,
            style: TextStyle(
              color: getColorHexFromStr("5E5E5E"),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
