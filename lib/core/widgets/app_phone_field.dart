import 'package:sonalysis/core/utils/colors.dart';
import 'package:sonalysis/core/widgets/app_textfield.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/helpers.dart';
import '../utils/styles.dart';

class AppPhoneTextField extends StatefulWidget {
  final String? initialValue;
  final String? headerText;
  final String? hintText;
  final bool readOnly;
  final bool enabled;
  final Widget? suffix;
  final AppTextFieldSize textFieldSize;
  final TextInputAction textInputAction;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final ValueChanged<String?> onChanged;
  final TextEditingController? controller;

  const AppPhoneTextField({
    Key? key,
    this.headerText,
    this.hintText,
    this.readOnly = false,
    this.enabled = true,
    this.textInputAction = TextInputAction.next,
    required this.onChanged,
    this.controller,
    this.suffix,
    this.validator,
    this.onSaved,
    this.initialValue,
    this.textFieldSize = AppTextFieldSize.normal,
  }) : super(key: key);

  @override
  State<AppPhoneTextField> createState() => _AppPhoneTextFieldState();
}

class _AppPhoneTextFieldState extends State<AppPhoneTextField> {
  String _dialCode = '+234';

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      headerText: widget.headerText,
      hintText: widget.hintText,
      initialValue: widget.initialValue,
      controller: widget.controller,
      textInputAction: widget.textInputAction,
      textInputFormatters: [FilteringTextInputFormatter.digitsOnly],
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      onChanged: (val) {
        widget.onChanged(_dialCode + val);
      },
      validator: (val) {
        if (widget.validator != null) {
          return widget.validator!((val ?? ''));
        }
      },
      onSaved: (val) {
        if (widget.onSaved != null) widget.onSaved!(_dialCode + (val ?? ''));
      },
      textInputType: TextInputType.number,
      prefixWidget: SizedBox(
        width: 125.w,
        child: Row(
          children: [
            MediaQuery.removePadding(
              context: context,
              removeRight: true,
              removeLeft: true,
              child: CountryCodePicker(
                onChanged: (countryCode) {
                  if (countryCode.dialCode == null) return;
                  _dialCode = countryCode.dialCode!;
                  String tt = widget.controller!.text != ""
                      ? widget.controller!.text
                      : '';
                  widget.onChanged(_dialCode + tt);
                },
                initialSelection:
                    _dialCode, //widget.countryCodeController?.text,
                showCountryOnly: false,
                hideMainText: false,
                alignLeft: false,
                searchDecoration: inputDecoration(),
                textStyle: AppStyle.text1.copyWith(color: AppColors.sonaBlack2),
                showDropDownButton: true,
                enabled: widget.enabled,
                flagWidth: 22.w,
                padding: EdgeInsets.zero,
              ),
            ),
            // SizedBox(
            //   height: 15.h,
            //   child: VerticalDivider(
            //     width: 1,
            //     thickness: 1,
            //     color: AppColors.sonaGrey,
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
