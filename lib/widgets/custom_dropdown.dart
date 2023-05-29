import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonalysis/helpers/helpers.dart';
import 'package:sonalysis/style/styles.dart';

class CustomDropdown extends StatelessWidget {
  final String? labelText, selected, error, hint, parent;
  final List<String> items;
  final Function onChange;
  final bool isDarkModeEnabled;
  final TextStyle? textStyle;
  final bool locked;
  CustomDropdown({
    Key? key,
    required this.labelText,
    required this.items,
    required this.selected,
    required this.onChange,
    this.isDarkModeEnabled=false,
    required this.hint,
    this.textStyle,
    this.locked = false,
    required this.error, this.parent,
  }) : super(key: key);

  final TextStyle editTextStyle = TextStyle(
    color: const Color(0XFF4C6174),
    //fontFamily: generalFont,
    fontSize: 18.0.sp,
    height: 1.3,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
          text: TextSpan(
            text: labelText!.trim().endsWith('*') ?
                  labelText!.trim().substring(0, labelText!.trim().lastIndexOf('*')) :
                  labelText!.trim(),
            style: textStyle ?? TextStyle(
              color: const Color(0xFF4C6174),
              //fontFamily: generalFont,
              fontSize: 16.0.sp,
              height: 1.4,
              fontWeight: FontWeight.w400,
            ),
            children: [
              if(labelText!.trim().endsWith('*'))
                const TextSpan(
                  text: '*',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
            ],
          ),
        ),
        SizedBox(
          height: 6.h,
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
          decoration: BoxDecoration(
            color: locked ? const Color(0xFFDDDFE4) : sonaBlack,
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          child: GestureDetector(
            onTap: (){
              if(items.isEmpty && parent!=null && parent!.isNotEmpty){
                String message='Please select a $parent';
                String vowels='aeiou';
                if(vowels.contains(parent!.characters.first.toLowerCase())) {
                  message='Please select an $parent';
                }
                showSnackError(context, message);
              }
            },
            child: DropdownButton(
                iconEnabledColor: const Color(0xFFFFFFFF),
                value: selected!=null && selected!.isNotEmpty ? selected : null,
                hint: Text(
                  hint!,
                  style: TextStyle(
                    color: const Color(0xFFFFFFFF),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400
                  ),
                ),
                style: editTextStyle,
                isExpanded: true,
                isDense: true,
                underline: Container(),
                dropdownColor: sonaBlack,
                items: [
                  for(String item in items)
                    DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: TextStyle(
                          color: const Color(0xFFFFFFFF),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400
                        ),
                      ),
                    ),
                ],
                onChanged: (item) {
                  onChange(item);
                }),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 2.0.h),
          child: Text(
            error ?? "",
            style: TextStyle(fontSize: 10.0.sp, color: Colors.red),
          ),
        ),
      ],
    );
  }
}
