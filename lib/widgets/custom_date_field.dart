import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonalysis/helpers/helpers.dart';
import 'package:sonalysis/lang/strings.dart';
import 'package:sonalysis/model/validation_status_model.dart';
import 'package:sonalysis/style/styles.dart';

import 'custom_error.dart';

class CustomDateField extends StatefulWidget{

  final Icon? icon;
  final String labelText;
  final TextEditingController controller;
  final bool? isDarkModeEnabled;
  final DateTime? maxDateTime;
  final Function()? onChange;
  final bool locked ;
  CustomDateField({Key? key, this.onChange, this.locked = false, this.maxDateTime, required this.labelText, required this.controller, this.icon, this.isDarkModeEnabled}) : super(key: key);

  @override
  _CustomDateFieldState createState() => _CustomDateFieldState();
}

class _CustomDateFieldState extends State<CustomDateField> {

  bool? isValid;
  Status? status;
  String error='';
  final String dateRange = imagesDir + '/date_range.png';

  final String _format = 'yyyy-MM-dd';
  final DateTime minDateTime = DateTime.parse('2010-05-12');
  DateTime? maxDateTime;

  @override
  void initState() { 
    maxDateTime = widget.maxDateTime ?? DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    // TextStyle editTextStyle=TextStyle(
    //   color: Color(0XFF4C6174),
    //   fontFamily: generalFont,
    //   fontSize: 18.0,
    //   height: 1.3,
    //   fontStyle: FontStyle.normal,
    //   fontWeight: FontWeight.w500,
    // );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
          text: TextSpan(
            text: widget.labelText.trim().endsWith('*') ? 
                  widget.labelText.trim().substring(0, widget.labelText.trim().lastIndexOf('*')).toUpperCase() :
                  widget.labelText.trim().toUpperCase(),
            style: TextStyle(
              color: getColorHexFromStr("C9D0CD"),
              //fontFamily: generalFont,
              fontSize: 13.0.sp,
              height: 1.4,
              fontWeight: FontWeight.w400,
            ),
            children: [
              if(widget.labelText.trim().endsWith('*'))
                const TextSpan(
                  text: '*',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: 8.h,),
        InkWell(
          onTap: _showDatePicker,
          child: Container(
            width: double.infinity,
            height: 40,
            padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 10.w),
            decoration: BoxDecoration(
              //color: widget.locked ? const Color(0xFFDDDFE4) : Colors.transparent,
              //borderRadius: BorderRadiusGeometry(),
              borderRadius: BorderRadius.circular(8.w),
              border: widget.locked
                  ? Border.all(width: 1.0, color: getColorHexFromStr("5E5E5E"))
                  : Border.all(width: 1.0, color: getColorHexFromStr("5E5E5E")),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    enabled: false,
                    keyboardType: TextInputType.datetime,
                    style: TextStyle(
                      color: Colors.white,
                      //fontFamily: generalFont,
                      fontSize: 13.0.sp,
                      height: 1.3,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w500,
                    ),
                    controller: widget.controller,
                    onChanged: (value) {
                      // if(widget.onChange!=null){
                        
                      // }
                    },
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.all(0),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10.0.w),
                  child: widget.icon ?? Image(
                    image: AssetImage(dateRange),
                    height: 18,
                    width: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: CustomError(error: error),
        ),
      ],
    );
  }

  void _showDatePicker() {

  }
}