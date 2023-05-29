import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color color;
  final Function()? action;
  final Color? borderColor;
  final TextStyle? textStyle;
  final IconData? iconData;
  final Icon? buttonIcon;
  final bool? showLoader;
  final double? verticalPadding;

  const CustomButton({Key? key, required this.text, required this.color, required this.action, this.borderColor, this.textStyle, this.iconData, this.buttonIcon, this.showLoader, this.verticalPadding,}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: action,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: verticalPadding ?? 10),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.w),
        color: color,
        border: Border.all(color: borderColor ?? color, width: 1.5.w),
        ),
        child: Center(
          child: iconData!=null ? Icon(
            iconData, 
            color: textStyle!.color,
            size: textStyle!.fontSize,
          ) :
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buttonIcon ?? const SizedBox.shrink(),
              buttonIcon!= null ? SizedBox(width: 10.w,) : const SizedBox.shrink(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  text.toUpperCase(),
                  style: textStyle ?? TextStyle(
                      color: const Color(0xFFFFFFFF),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      height: 1.2
                  ),
                ),
              ),
              showLoader != null && showLoader!
                  ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Container(
                    height: 20,
                    width: 20,
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    child: const CircularProgressIndicator(
                      strokeWidth: 2.0,
                      valueColor : AlwaysStoppedAnimation(Colors.white),
                    ),
                  ),
                ),
              ],
            )
                  : const SizedBox.shrink()
            ],
          ),
        ),

      ),
    );
  }
}