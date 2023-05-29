import 'package:sonalysis/core/enums/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonalysis/core/utils/styles.dart';

class AppButton extends StatelessWidget {
  final Widget? child;
  final String? buttonText;
  final double vertical;
  final ButtonType buttonType;
  final VoidCallback? onPressed;
  final bool? isLoading;
  final bool? isDisabled;
  const AppButton({
    Key? key,
    this.child,
    this.buttonText,
    this.vertical = 10.0,
    this.buttonType = ButtonType.primary,
    this.onPressed,
    this.isLoading,
    this.isDisabled,
  })  : assert(buttonText != null || child != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: buttonType == ButtonType.primary
              ? buttonType.defaultGradient
              : null,
          color:
              buttonType == ButtonType.primary ? null : buttonType.defaultColor,
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: ElevatedButton(
          key: key,
          onPressed: isDisabled == true
              ? null
              : () {
                  if (onPressed != null) {
                    FocusScope.of(context).unfocus();
                    onPressed!();
                  }
                },
          style: ButtonStyle(
            elevation: MaterialStateProperty.resolveWith<double>((states) => 0),
            padding: MaterialStateProperty.resolveWith<EdgeInsets>(
              (states) => EdgeInsets.symmetric(vertical: vertical.h),
            ),
            fixedSize: MaterialStateProperty.resolveWith<Size>(
              (states) => Size(192.w, 43.h),
            ),
            shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
              (states) => RoundedRectangleBorder(
                side: BorderSide(
                  color: onPressed == null
                      ? Colors.transparent
                      : buttonType.borderColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.disabled) ||
                    onPressed == null) {
                  return buttonType.disabledColor;
                }
                return buttonType.defaultColor; // Use the component's default.
              },
            ),
          ),
          child: (isLoading ?? false)
              ? _loadingWidget()
              : child ??
                  Text(
                    buttonText!,
                    style: buttonType.buttonStyle,
                  ),
        ));
  }
}

Widget _loadingWidget() => const Center(
      child: CircularProgressIndicator(
        color: Color(0xFFF4F4F4),
      ),
    );
