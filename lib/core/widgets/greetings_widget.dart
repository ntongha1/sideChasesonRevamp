import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonalysis/core/utils/helpers.dart';

class GreetingsWidget extends StatelessWidget {
  final String name;
  final String teamAndRole;

  const GreetingsWidget({Key? key, required this.name, required this.teamAndRole}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold
            )),
        Text(teamAndRole,
            style: TextStyle(
                color: getColorHexFromStr("A0A0A0"),
                fontSize: 12.sp,
                fontWeight: FontWeight.w400
            )),
      ],
    );
  }
}